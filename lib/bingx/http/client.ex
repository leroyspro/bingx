defmodule BingX.HTTP.Client do
  @moduledoc """
  This module provides functions to make requests to BingX API with enhanced interface.
  """

  alias BingX.HTTP.{Request, Response, Error}

  def signed_request(method, path, api_key, secret_key, options \\ []) do
    body = Keyword.get(options, :body, "")
    params = Keyword.get(options, :params, %{})

    url = Request.build_url(path, params, sign: secret_key)
    headers = Request.auth_headers(api_key)

    case do_request(method, url, body, headers) do
      {:ok, resp} -> {:ok, adapt_response(resp)}
      {:error, err} -> {:error, :http_error, adapt_error(err)}
    end
  end

  defp do_request(method, url, body, headers) do
    %HTTPoison.Request{method: method, url: url, headers: headers, body: body}
    |> HTTPoison.request()
  end

  defp adapt_response(%HTTPoison.Response{} = resp) do
    %Response{
      status_code: resp.status_code,
      body: resp.body,
      headers: resp.headers,
      request_url: resp.request_url
    }
  end

  defp adapt_error(%HTTPoison.Error{} = err), do: %Error{message: err.reason}
end
