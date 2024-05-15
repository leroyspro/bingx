defmodule BingX.HTTP.Client do
  @moduledoc """
  This module provides functions to make requests to BingX API with enhanced interface.
  """

  require BingX.HTTP.Adapter.Loader

  alias BingX.HTTP.Request

  BingX.HTTP.Adapter.Loader.load()

  def authed_request(method, path, api_key, options \\ []) do
    body = Keyword.get(options, :body, "")
    params = Keyword.get(options, :params, %{})

    url = Request.build_url(path, params)
    headers = Request.auth_headers(api_key)

    @http_adapter.request(method, url, body, headers)
  end

  def signed_request(method, path, api_key, secret_key, options \\ []) do
    body = Keyword.get(options, :body, "")
    params = Keyword.get(options, :params, %{})

    url = Request.build_url(path, params, sign: secret_key)
    headers = Request.auth_headers(api_key)

    @http_adapter.request(method, url, body, headers)
  end

  def adapter(), do: @http_adapter
end
