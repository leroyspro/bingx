if Code.ensure_loaded?(HTTPoison) do
  defmodule BingX.HTTP.Adapter.HTTPoison do
    alias BingX.HTTP.{Response, Error}

    @behaviour BingX.HTTP.Adapter

    @impl true
    def request(method, url, body, headers, options \\ []) do
      %HTTPoison.Request{
        method: method, 
        url: url, 
        headers: headers, 
        body: body, 
        options: options
      }
      |> HTTPoison.request()
      |> adapt_result()
    end

    defp adapt_result({:ok, response}) do
      {:ok, adapt_response(response)}
    end

    defp adapt_result({:error, error}) do
      {:error, :http_error, adapt_error(error)}
    end

    defp adapt_response(%HTTPoison.Response{} = resp) do
      %Response{
        status_code: resp.status_code,
        body: resp.body,
        headers: resp.headers,
        request_url: resp.request_url
      }
    end

    defp adapt_error(%HTTPoison.Error{} = err) do 
      %Error{message: err.reason}
    end
  end
end
