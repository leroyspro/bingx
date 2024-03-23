defmodule BingX.HTTP.Client do
  @moduledoc """
  This module provides functions to make requests to BingX API with an enhanced interface.
  """

  alias BingX.HTTP.Request

  case Code.ensure_loaded(HTTPoison) do
    {:module, _} ->
      @http_adapter Application.compile_env(:bingx, :http_adapter, BingX.HTTP.Adapter.HTTPoison)

    {:error, :nofile} ->
      @http_adapter Application.compile_env!(:bingx, :http_adapter)
  end

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
end
