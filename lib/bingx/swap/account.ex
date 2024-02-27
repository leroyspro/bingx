defmodule BingX.Swap.Account do
  alias BingX.Exception
  alias BingX.Request.{QueryParams, Headers}
  alias BingX.Swap.Account.BalanceResponse

  @origin Application.compile_env!(:bingx, :origin)

  def url_base, do: @origin <> "/openApi/swap/v2/user"

  @spec get_balance(String.t(), String.t()) :: {:ok, Map} | {:error, term()}
  def get_balance(api_key, secret_key) when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, %{body: body, status_code: 200}} <-
        do_get_balance(api_key, secret_key),
      {:ok, data} <- Jason.decode(body, keys: :strings)
    ) do

      case data do
        %{"code" => 0, "data" => %{"balance" => payload}} ->
          {:ok, BalanceResponse.new(payload)}

        %{"code" => code, "msg" => message} ->
          {:error, Exception.new(code, message)}
      end
    end
  end

  defp do_get_balance(api_key, secret_key) do
    url = url_base() <> "/balance"

    headers = Headers.append_api_key(Map.new(), api_key)

    params =
      Map.new()
      |> QueryParams.append_timestamp()
      |> QueryParams.append_receive_window()
      |> QueryParams.append_signature(secret_key)

    HTTPoison.get(url, headers, params: params)
  end
end
