defmodule BingX.Swap.Account do
  alias BingX.Request
  alias BingX.Swap.Account.BalanceResponse
  alias BingX.Response

  @api_scope "/openApi/swap/v2/user"

  @get_balance_path @api_scope <> "/order"

  # Interface
  # =========

  @spec get_balance(String.t(), String.t()) :: {:ok, Map} | {:error, term()}
  def get_balance(api_key, secret_key) when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_get_balance(api_key, secret_key),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body),
      {:ok, content} <- Response.extract_content(data)
    ) do
      {:ok, BalanceResponse.new(content)}
    end
  end

  # Helpers
  # =======

  defp do_get_balance(api_key, secret_key) do
    headers = Request.auth_headers(api_key)
    url = Request.build_url(@get_balance_path, sign: secret_key)

    HTTPoison.get(url, headers)
  end
end
