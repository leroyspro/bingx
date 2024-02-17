defmodule BingX.Account do
  use HTTPoison.Base

  alias BingX.Helpers.{Response, Headers, QueryParams}

  @endpoint Application.compile_env(
              :bingx,
              :endpoint,
              "https://open-api.bingx.com"
            )

  @impl true
  def process_request_url(url), do: @endpoint <> url

  @spec get_perpetual_swap_positions(String.t(), String.t()) :: {:ok, Map} | {:error, term()}
  def get_perpetual_swap_positions(api_key, secret_key) when is_binary(api_key) do
    with(
      {:ok, %{body: body}} <- do_get_perpetual_swap_positions(api_key, secret_key),
      {:ok, response} <- Jason.decode(body, keys: :strings)
    ) do
      IO.puts(inspect(body))
      Response.extract_payload(response, "balance")
    else
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      {:error, %Jason.DecodeError{}} ->
        {:error, "bad JSON parse"}

      _ ->
        {:error, "unexpected error"}
    end
  end

  defp do_get_perpetual_swap_positions(api_key, secret_key) do
    headers = Headers.append_api_key(api_key)

    params =
      Map.new()
      |> QueryParams.append_timestamp()
      |> QueryParams.append_receive_window()
      |> QueryParams.sign(secret_key)

    __MODULE__.get("/openApi/swap/v2/user/balance", headers, params: params)
  end
end
