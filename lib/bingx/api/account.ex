defmodule BingX.API.Account do
  use HTTPoison.Base

  alias BingX.API.Helpers.{Response, Headers, QueryParams}

  alias BingX.API.Account.BalanceResponse

  @endpoint Application.compile_env!(:bingx, :endpoint)

  @impl true
  def process_request_url(url), do: @endpoint <> url

  @spec get_balance(String.t(), String.t()) :: {:ok, Map} | {:error, term()}
  def get_balance(api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_get_balance(api_key, secret_key),
      {:ok, data} <- Jason.decode(resp.body, keys: :strings),
      {:ok, payload} = Response.extract_payload(data, "balance")
    ) do
      {:ok, BalanceResponse.new(payload)}
    end
  end

  defp do_get_balance(api_key, secret_key) do
    headers = Headers.append_api_key(api_key)

    params =
      Map.new()
      |> QueryParams.append_timestamp()
      |> QueryParams.append_receive_window()
      |> QueryParams.sign(secret_key)

    __MODULE__.get("/openApi/swap/v2/user/balance", headers, params: params)
  end
end
