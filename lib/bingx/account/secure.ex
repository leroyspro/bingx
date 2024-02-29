defmodule BingX.Account.Secure do
  alias BingX.{Request, Response}
  alias BingX.Account.Secure.GenListenKeyResponse

  @api_scope "/openApi/user/auth"
  @gen_listen_key_path @api_scope <> "/userDataStream"

  def gen_listen_key(api_key, secret_key) do
    with(
      {:ok, resp} <- do_gen_listen_key(api_key, secret_key),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body)
    ) do
      {:ok, GenListenKeyResponse.new(data)}
    end
  end

  defp do_gen_listen_key(api_key, secret_key) do
    url = Request.build_url(@gen_listen_key_path, sign: secret_key)
    headers = Request.auth_headers(api_key)

    HTTPoison.post(url, "", headers)
  end
end
