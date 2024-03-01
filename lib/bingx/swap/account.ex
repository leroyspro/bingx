defmodule BingX.Swap.Account do
  import BingX.HTTP.Client, only: [signed_request: 4]

  alias BingX.Swap.Account.BalanceResponse
  alias BingX.HTTP.Response 

  @api_scope "/openApi/swap/v2/user"

  @get_balance_path @api_scope <> "/order"

  # Interface
  # =========

  def get_balance(api_key, secret_key) 
      when is_binary(api_key) and is_binary(secret_key) do

    with(
      {:ok, resp} <- do_get_balance(api_key, secret_key),
      {:ok, content} <- Response.extract_validated_content(resp)
    ) do
      {:ok, BalanceResponse.new(content)}
    end
  end

  # Helpers
  # =======

  defp do_get_balance(api_key, secret_key) do
    signed_request(:delete, @get_balance_path, api_key, secret_key)
  end
end
