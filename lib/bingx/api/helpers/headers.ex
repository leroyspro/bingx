defmodule BingX.API.Helpers.Headers do
  def append_api_key(headers \\ %{}, value)

  def append_api_key(%{} = headers, value) do
    Map.merge(headers, %{"X-BX-APIKEY" => value})
  end
end
