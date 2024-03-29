defmodule BingX.Swap.Account do
  @moduledoc """
  This module provides functions making requests for swap account API methods using abstractions on known internal interfaces.

  BingX swap account API: https://bingx-api.github.io/docs/#/en-us/swapV2/account-api.html#Get%20Perpetual%20Swap%20Account%20Asset%20Information
  """

  import BingX.HTTP.Client, only: [signed_request: 4]

  alias BingX.Swap.GetBalanceResponse
  alias BingX.HTTP.Response

  @api_scope "/openApi/swap/v2/user"

  @get_balance_path @api_scope <> "/balance"

  # Interface
  # =========

  def get_balance(api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, response} <- do_get_balance(api_key, secret_key),
      {:ok, payload} <- Response.get_response_payload(response)
    ) do
      {:ok, GetBalanceResponse.new(payload)}
    end
  end

  # Helpers
  # =======

  defp do_get_balance(api_key, secret_key) do
    signed_request(:get, @get_balance_path, api_key, secret_key)
  end
end
