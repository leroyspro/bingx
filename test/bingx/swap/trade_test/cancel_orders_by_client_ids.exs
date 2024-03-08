defmodule BingX.Swap.TradeTest.CancelOrdersByClientIDs do
  @moduledoc """
  This is module is used to test BingX.API.Trade module.

  ## ATTENTION
  Patch **every** network request to the real world!
  These tests are used only to verify internal logic of the module, nothing else.
  """

  use ExUnit.Case
  use Patch

  alias BingX.Swap.{CancelOrdersResponse, Trade, Order}
  alias BingX.HTTP.{Client, Response, Error}
  alias BingX.Swap.Trade.Contract

  # should make *** request
  # should request correct endpoint
  # should make secure request using provided credentials
  # should put all transformed orders into query params
  # should return the original request http-error
  # should extract and validate response content
  # should wrap the content into PlaceOrdersResponse struct
  # should return the original content-error

  setup_all do
    {
      :ok,
      api_key: "API_KEY_FOR_TEST", secret_key: "SECRET_KEY_FOR_TEST", path: "/openApi/swap/v2/trade/batchOrders"
    }
  end

  describe "BingX.Swap.Trade cancel_orders_by_client_ids/4" do
    test "should make DELETE request", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.cancel_orders_by_client_ids("BTC-USDT", ["1", "2"], api_key, secret_key)

      assert_called_once(Client.signed_request(:delete, _path, _api_key, _secret_key, _options))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.cancel_orders_by_client_ids("BTC-USDT", ["1", "2"], api_key, secret_key)

      assert_called_once(Client.signed_request(_method, ^path, _api_key, _secret_key, _options))
    end

    test "should make secure request using provided credentials", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.cancel_orders_by_client_ids("BTC-USDT", ["1", "2"], api_key, secret_key)

      assert_called_once(Client.signed_request(_method, _path, ^api_key, ^secret_key, _options))
    end

    test "should put the symbol and order IDs into query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.cancel_orders_by_client_ids("BTC-USDT", ["1", "2"], api_key, secret_key)

      assert_called_once(
        Client.signed_request(
          _method,
          _path,
          _api_key,
          _secret_key,
          params: %{
            "symbol" => "BTC-USDT",
            "clientOrderIDList" => "[1,2]"
          }
        )
      )
    end

    test "should return the original request http-error", context do
      %{api_key: api_key, secret_key: secret_key} = context

      error = {:error, :http_error, %Error{message: :timeout}}

      patch(Client, :signed_request, error)

      assert ^error = Trade.cancel_orders_by_client_ids("BTC-USDT", ["1", "2"], api_key, secret_key)
    end

    test "should extract and validate response content", context do
      %{api_key: api_key, secret_key: secret_key} = context

      content = "X"
      response = %Response{body: %{"data" => content}}
      struct = %{"A" => :s}

      patch(CancelOrdersResponse, :new, struct)
      patch(Response, :get_response_payload, {:ok, content})
      patch(Client, :signed_request, {:ok, response})

      Trade.cancel_orders_by_client_ids("BTC-USDT", ["1", "2"], api_key, secret_key)

      assert_called_once(Response.get_response_payload(^response))
    end

    test "should wrap the content into CancelOrdersResponse struct", context do
      %{api_key: api_key, secret_key: secret_key} = context

      content = "X"
      response = %Response{body: %{"data" => content}}
      struct = %{"A" => :s}

      patch(CancelOrdersResponse, :new, struct)
      patch(Response, :get_response_payload, {:ok, content})
      patch(Client, :signed_request, {:ok, response})

      assert {:ok, ^struct} = Trade.cancel_orders_by_client_ids("BTC-USDT", ["1", "2"], api_key, secret_key)

      assert_called_once(CancelOrdersResponse.new(^content))
      assert_called_once(Response.get_response_payload(^response))
    end

    test "should return the original content-error", context do
      %{api_key: api_key, secret_key: secret_key} = context

      error = {:error, :content_error, "yep"}
      response = %Response{body: %{"data" => "a"}}

      patch(Response, :get_response_payload, error)
      patch(Client, :signed_request, {:ok, response})

      assert ^error = Trade.cancel_orders_by_client_ids("BTC-USDT", ["1", "2"], api_key, secret_key)

      assert_called_once(Response.get_response_payload(^response))
    end
  end
end
