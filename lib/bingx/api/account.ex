defmodule BingX.API.Account do
  use HTTPoison.Base

  alias BingX.API.Helpers.{Response, Headers, QueryParams}

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
      {:ok, resp} <- do_get_perpetual_swap_positions(api_key, secret_key),
      {:ok, data} <- Jason.decode(resp.body, keys: :strings)
    ) do
      {:ok, _payload} = Response.extract_payload(data, "balance")
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
