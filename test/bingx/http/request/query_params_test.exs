defmodule BingX.HTTP.Request.QueryParamsTest do
  use ExUnit.Case
  use Patch

  alias BingX.HTTP.Request.QueryParams
  alias :crypto, as: Crypto
  alias BingX.Helpers

  describe "BingX.HTTP.Request.QueryParams append_receive_window/1" do
    setup _context do
      {:ok, default: 5000}
    end

    test "should append a default value", context do
      %{default: default} = context

      assert %{"recvWindow" => default} = QueryParams.append_receive_window(%{})
    end

    test "should append only single param", context do
      params = %{"EXTRA" => 100}
      result = QueryParams.append_receive_window(params)

      assert 2 === map_size(result)
    end
  end

  describe "BingX.HTTP.Request.QueryParams append_receive_window/2" do
    test "should append a custom value", _context do
      custom = 21312
      assert %{"recvWindow" => custom} = QueryParams.append_receive_window(%{}, custom)
    end

    test "should append only single param", _context do
      params = %{"EXTRA" => 100}
      result = QueryParams.append_receive_window(params, 3_212_312)

      assert 2 === map_size(result)
    end
  end

  describe "BingX.HTTP.Request.QueryParams append_timestamp/1" do
    test "should append a valid timestamp" do
      timestamp = 129_312_331_231

      patch(Helpers, :timestamp, timestamp)

      assert %{"timestamp" => timestamp} = QueryParams.append_timestamp(%{})
    end

    test "should append only single param" do
      params = %{"EXTRA" => 21312}
      result = QueryParams.append_timestamp(params)

      assert 2 === map_size(result)
    end
  end

  describe "BingX.HTTP.Request.QueryParams append_signature/2" do
    setup _context do
      {:ok, secret_key: "TEST_SECRET_KEY"}
    end

    test "should append correct param key", context do
      %{secret_key: secret_key} = context

      assert %{"signature" => _signature} = QueryParams.append_signature(%{}, secret_key)
    end

    test "should append only single param", context do
      %{secret_key: secret_key} = context

      params = %{"EXTRA" => "____"}
      result = QueryParams.append_signature(params, secret_key)

      assert 2 = map_size(result)
    end

    test "should encrypt with list value correctly", context do
      %{secret_key: secret_key} = context

      params = %{"k" => ["y", [1]]}
      query = "k=[y,[1]]"

      signature = encrypt(query, secret_key)

      assert %{"signature" => ^signature} = QueryParams.append_signature(params, secret_key)
    end

    test "should encrypt with map value correctly", context do
      %{secret_key: secret_key} = context

      params = %{"k" => %{"a"=>[1]}}
      query = "k={\"a\":[1]}"

      signature = encrypt(query, secret_key)

      assert %{"signature" => ^signature} = QueryParams.append_signature(params, secret_key)
    end

    defp encrypt(raw, secret_key) do
      Crypto.mac(:hmac, :sha256, secret_key, raw)
      |> Base.encode16(case: :lower)
    end
  end
end
