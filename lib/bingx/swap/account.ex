defmodule BingX.Swap.Account do
  alias BingX.Request.{QueryParams, Headers}
  alias BingX.Swap.Account.BalanceResponse
  alias BingX.Response

  alias BingX.Request.{Headers, QueryParams}

  @origin Application.compile_env!(:bingx, :origin)

  # Interface
  # =========

  def url_base, do: @origin <> "/openApi/swap/v2/user"

  @spec get_balance(String.t(), String.t()) :: {:ok, Map} | {:error, term()}
  def get_balance(api_key, secret_key) when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_get_balance(api_key, secret_key),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, content} <- Response.extract_content(body)
    ) do
      {:ok, BalanceResponse.new(content)}
    end
  end

  # Helpers
  # =======

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
