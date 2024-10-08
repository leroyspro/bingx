defmodule BingX.Swap.TradeTest.GetOrderTest do
  @moduledoc """
  This is module is used to test BingX.API.Trade module.

  ## ATTENTION
  Patch **every** network request to the real world!
  These tests are used only to verify internal logic of the module, nothing else.
  """

  use ExUnit.Case
  use Patch

  alias BingX.Swap.{Trade, GetOrderResponse}
  alias BingX.HTTP.{Client, Response, Error}

  setup_all do
    {
      :ok,
      api_key: "API_KEY_FOR_TEST", secret_key: "SECRET_KEY_FOR_TEST", path: "/openApi/swap/v2/trade/order"
    }
  end

  describe "BingX.Swap.Trade get_order/4" do
    test "should make GET request", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.get_order("BTC-USDT", "ORDER_ID", api_key, secret_key)

      assert_called_once(Client.signed_request(:get, _path, _api_key, _secret_key, _options))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.get_order("BTC-USDT", "ORDER_ID", api_key, secret_key)

      assert_called_once(Client.signed_request(_method, ^path, _api_key, _secret_key, _options))
    end

    test "should make secure request using provided credentials", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.get_order("BTC-USDT", "ORDER_ID", api_key, secret_key)

      assert_called_once(Client.signed_request(_method, _path, ^api_key, ^secret_key, _options))
    end

    test "should put the symbol into query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.get_order("BTC-USDT", "ORDER_ID", api_key, secret_key)

      assert_called_once(
        Client.signed_request(
          _method,
          _path,
          _api_key,
          _secret_key,
          params: %{
            "symbol" => "BTC-USDT",
            "orderId" => "ORDER_ID"
          }
        )
      )
    end

    test "should return the original request http-error", context do
      %{api_key: api_key, secret_key: secret_key} = context

      error = {:error, :http_error, %Error{message: :timeout}}

      patch(Client, :signed_request, error)

      assert ^error = Trade.get_order("BTC-USDT", "ORDER_ID", api_key, secret_key)
    end

    test "should extract and validate response content", context do
      %{api_key: api_key, secret_key: secret_key} = context

      content = "X"
      response = %Response{body: %{"data" => content}}
      struct = %{"A" => :s}

      patch(GetOrderResponse, :new, struct)
      patch(Response, :process_response, {:ok, content})
      patch(Client, :signed_request, {:ok, response})

      Trade.get_order("BTC-USDT", "ORDER_ID", api_key, secret_key)

      assert_called_once(Response.process_response(^response))
    end

    test "should wrap the content into GetOrderResponse struct", context do
      %{api_key: api_key, secret_key: secret_key} = context

      content = "X"
      response = %Response{body: %{"order" => content}}
      struct = %{"A" => :s}

      patch(GetOrderResponse, :new, struct)
      patch(Response, :process_response, {:ok, content})
      patch(Client, :signed_request, {:ok, response})

      assert {:ok, ^struct} = Trade.get_order("BTC-USDT", "ORDER_ID", api_key, secret_key)

      assert_called_once(GetOrderResponse.new(^content))
      assert_called_once(Response.process_response(^response))
    end

    test "should return the original content-error", context do
      %{api_key: api_key, secret_key: secret_key} = context

      error = {:error, :content_error, "yep"}
      response = %Response{body: %{"data" => "a"}}

      patch(Response, :process_response, error)
      patch(Client, :signed_request, {:ok, response})

      assert ^error = Trade.get_order("BTC-USDT", "ORDER_ID", api_key, secret_key)

      assert_called_once(Response.process_response(^response))
    end
  end
end
