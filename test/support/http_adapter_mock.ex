defmodule BingX.HTTP.Adapter.Mock do
  alias BingX.HTTP.Response

  @behaviour BingX.HTTP.Adapter

  def request(_method, _url, _body, _headers) do
    {:ok, %Response{status_code: 300, body: ""}}
  end
end
