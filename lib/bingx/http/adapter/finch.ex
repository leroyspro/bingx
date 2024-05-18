if Code.ensure_loaded?(Finch) do
  defmodule BingX.HTTP.Adapter.Finch do
    alias BingX.Helpers
    alias BingX.HTTP.{Response, Error}

    @behaviour BingX.HTTP.Adapter
    @name Application.compile_env(:bingx, :finch, BingX.Finch)

    @impl true
    def request(method, url, body, headers, options \\ []) do
      kw_headers = Helpers.keyword_from_map(headers)
      request = Finch.build(method, url, kw_headers, body, options)

      case Finch.request(request, @name) do
        {:ok, resp} -> {:ok, adapt_response(url, resp)}
        {:error, err} -> {:error, :http_error, adapt_error(err)}
      end
    end

    defp adapt_response(url, %Finch.Response{} = resp) do
      %Response{
        status_code: resp.status,
        body: resp.body,
        headers: resp.headers,
        request_url: url
      }
    end

    defp adapt_error(%{reason: message}), do: %Error{message: message}
    defp adapt_error(error), do: %Error{message: inspect(error)}
  end
end
