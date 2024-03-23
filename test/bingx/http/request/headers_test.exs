defmodule BingX.HTTP.Request.HeadersTest do
  use ExUnit.Case, async: true

  alias BingX.HTTP.Request.Headers

  describe "BingX.HTTP.Request.Headers append_api_key/1" do
    setup _context do
      {:ok, api_key: "DSJFLKSDJFLKDSJLKFJDSKL"}
    end

    test "should append correct key value", context do
      %{api_key: api_key} = context

      assert %{"X-BX-APIKEY" => ^api_key} = Headers.append_api_key(%{}, api_key)
    end

    test "should append only single param", context do
      %{api_key: api_key} = context

      params = %{"EXTRA" => 100}
      result = Headers.append_api_key(params, api_key)

      assert 2 === map_size(result)
    end
  end
end
