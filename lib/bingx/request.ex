defmodule BingX.Request do
  alias BingX.Request.{QueryParams, Headers}

  @origin Application.compile_env!(:bingx, :origin)

  def create_secured(method, path, body \\ "", options)
      when is_atom(method) and is_binary(path) and is_list(options) do
    api_key = Keyword.fetch!(options, :api_key)
    secret_key = Keyword.fetch!(options, :secret_key)
    params = Keyword.get(options, :params, %{})
    headers = Keyword.get(options, :headers, %{})

    authenticated_headers = Headers.append_api_key(headers, api_key)

    secured_params =
      params
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.append_signature(secret_key)

    %HTTPoison.Request{
      url: @origin <> path,
      method: method,
      body: body,
      headers: authenticated_headers,
      params: secured_params,
      options: options
    }
  end
end
