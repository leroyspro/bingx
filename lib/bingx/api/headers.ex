defmodule BingX.API.Headers do
  def append_api_key(%{} = headers, key) do
    Map.merge(headers, %{"X-BX-APIKEY" => key})
  end
end
