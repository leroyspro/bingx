defmodule BingX.Account.Security do
  import BingX.HTTP.Client, only: [signed_request: 4]
  
  alias BingX.HTTP.Response
  alias BingX.Account.Security.GenListenKeyResponse

  @api_scope "/openApi/user/auth"
  @gen_listen_key_path @api_scope <> "/userDataStream"
  @extend_listen_key_path @api_scope <> "/userDataStream"

  def gen_listen_key(api_key, secret_key) do
    with(
      {:ok, resp} <- do_gen_listen_key(api_key, secret_key),
      :ok <- Response.validate(resp, code: 200),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body)
    ) do
      {:ok, GenListenKeyResponse.new(data)}
    end
  end

  def extend_listen_key(api_key, secret_key) do
    with(
      {:ok, resp} <- do_extend_listen_key(api_key, secret_key),
      :ok <- Response.validate(resp, code: 200)
    ) do
      :ok
    end
  end

  defp do_gen_listen_key(api_key, secret_key) do
    signed_request(:post, @gen_listen_key_path, api_key, secret_key)
  end

  defp do_extend_listen_key(api_key, secret_key) do
    signed_request(:post, @extend_listen_key_path, api_key, secret_key)
  end
end
