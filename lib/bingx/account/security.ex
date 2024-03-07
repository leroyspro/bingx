defmodule BingX.Account.Security do
  @moduledoc """
  This module provides functions making requests for account API methods using abstractions on known internal interfaces.
  """

  import BingX.HTTP.Client, only: [authed_request: 3, authed_request: 4]

  alias BingX.HTTP.Response
  alias BingX.Account.GenerateListenKeyResponse

  @api_scope "/openApi/user/auth"
  @generate_listen_key_path @api_scope <> "/userDataStream"
  @extend_listen_key_path @api_scope <> "/userDataStream"

  def generate_listen_key(api_key) when is_binary(api_key) do
    with(
      {:ok, resp} <- do_generate_listen_key(api_key),
      {:ok, payload} <- Response.get_response_payload(resp)
    ) do
      {:ok, GenerateListenKeyResponse.new(payload)}
    end
  end

  def extend_listen_key(listen_key, api_key)
      when is_binary(listen_key) and is_binary(api_key) do
    with(
      {:ok, response} <- do_extend_listen_key(listen_key, api_key),
      {:ok, _payload} <- Response.validate_statuses(response, [200, 204])
    ) do
      :ok
    end
  end

  defp do_generate_listen_key(api_key) do
    authed_request(:post, @generate_listen_key_path, api_key)
  end

  defp do_extend_listen_key(listen_key, api_key) do
    authed_request(:put, @extend_listen_key_path, api_key, params: %{"listenKey" => listen_key})
  end
end
