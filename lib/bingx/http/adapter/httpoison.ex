if Code.ensure_loaded?(HTTPoison) do
  defmodule BingX.HTTP.Adapter.HTTPoison do
    alias BingX.HTTP.{Response, Error}

    @behaviour BingX.HTTP.Adapter

    @impl true
    def request(method, url, body, headers, options \\ []) do
      request = 
        %HTTPoison.Request{
          method: method,
          url: url,
          headers: headers,
          body: body,
          options: options
        }
      
      case HTTPoison.request(request) do
        {:ok, resp} -> {:ok, adapt_response(resp)}
        {:error, err} -> {:error, :http_error, adapt_error(err)}
      end
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
end
