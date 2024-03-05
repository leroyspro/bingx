defmodule BingX.Account.Security do
  @moduledoc """
  This module provides functions making requests for account API methods using abstractions on known internal interfaces.
  """

  import BingX.HTTP.Client, only: [signed_request: 4]

  alias BingX.HTTP.Response
  alias BingX.Account.GenerateListenKeyResponse

  @api_scope "/openApi/user/auth"
  @generate_listen_key_path @api_scope <> "/userDataStream"
  @extend_listen_key_path @api_scope <> "/userDataStream"

  def generate_listen_key(api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_generate_listen_key(api_key, secret_key),
      :ok <- Response.validate(resp, code: 200),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body)
    ) do
      {:ok, GenerateListenKeyResponse.new(data)}
    end
  end

  def extend_listen_key(api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_extend_listen_key(api_key, secret_key),
      :ok <- Response.validate(resp, code: 200)
    ) do
      :ok
    end
  end

  defp do_generate_listen_key(api_key, secret_key) do
    signed_request(:post, @generate_listen_key_path, api_key, secret_key)
  end

  defp do_extend_listen_key(api_key, secret_key) do
    signed_request(:post, @extend_listen_key_path, api_key, secret_key)
  end
end
