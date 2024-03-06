defmodule BingX.Swap.TradeTest.PlaceOrders do
  @moduledoc """
  This is module is used to test BingX.API.Trade module.

  ## ATTENTION
  Patch **every** network request to the real world!
  These tests are used only to verify internal logic of the module, nothing else.
  """

  use ExUnit.Case
  use Patch

  alias BingX.Swap.{PlaceOrdersResponse, Trade, Order}
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
    orders =
      [
        %Order{
          side: :buy,
          position_side: :long,
          price: 51000,
          stop_price: 51000,
          quantity: 0.0001,
          symbol: "BTC-USDT"
        },
        %Order{
          side: :sell,
          position_side: :short,
          price: 52000,
          stop_price: 51000,
          quantity: 0.0001,
          symbol: "BTC-XRP"
        },
      ]

    {
      :ok,
      orders: orders,
      api_key: "API_KEY_FOR_TEST", 
      secret_key: "SECRET_KEY_FOR_TEST",
      path: "/openApi/swap/v2/trade/batchOrders"
    }
  end

  describe "BingX.Swap.Trade place_orders/3" do
    test "should make POST request", context do
      %{api_key: api_key, secret_key: secret_key, orders: orders} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.place_orders(orders, api_key, secret_key)

      assert_called_once(Client.signed_request(:post, _path, _api_key, _secret_key, _options))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, secret_key: secret_key, path: path, orders: orders} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.place_orders(orders, api_key, secret_key)

      assert_called_once(Client.signed_request(_method, ^path, _api_key, _secret_key, _options))
    end

    test "should make secure request using provided credentials", context do
      %{api_key: api_key, secret_key: secret_key, orders: orders} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.place_orders(orders, api_key, secret_key)

      assert_called_once(Client.signed_request(_method, _path, ^api_key, ^secret_key, _options))
    end

    test "should put transformed Order struct into query params", context do
      %{api_key: api_key, secret_key: secret_key, orders: orders} = context

      contract = %{"K" => "V"}
      options = [params: %{"batchOrders" => "[{\"K\":\"V\"},{\"K\":\"V\"}]"}]

      patch(Contract, :from_order, contract)
      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.place_orders(orders, api_key, secret_key)

      for order <- orders do
        assert_called_once(Contract.from_order(^order))
      end


      assert_called_once(Client.signed_request(_method, _path, _api_key, _secret_key, ^options))
    end

    test "should return the original request http-error", context do
      %{api_key: api_key, secret_key: secret_key, orders: orders} = context

      error = {:error, :http_error, %Error{message: :timeout}}

      patch(Contract, :from_order, %{"K" => "V"})
      patch(Client, :signed_request, error)

      assert ^error = Trade.place_orders(orders, api_key, secret_key)
    end

    test "should extract and validate response content", context do
      %{api_key: api_key, secret_key: secret_key, orders: orders} = context

      content = "X"
      response = %Response{body: %{"data" => content}}
      struct = %{"A" => :s}

      patch(PlaceOrdersResponse, :new, struct)
      patch(Response, :get_response_payload, {:ok, content})
      patch(Client, :signed_request, {:ok, response})

      Trade.place_orders(orders, api_key, secret_key)

      assert_called_once(Response.get_response_payload(^response))
    end

    test "should wrap the content into PlaceOrdersResponse struct", context do
      %{api_key: api_key, secret_key: secret_key, orders: orders} = context

      content = "X"
      response = %Response{body: %{"data" => content}}
      struct = %{"A" => :s}

      patch(PlaceOrdersResponse, :new, struct)
      patch(Response, :get_response_payload, {:ok, content})
      patch(Client, :signed_request, {:ok, response})

      assert {:ok, ^struct} = Trade.place_orders(orders, api_key, secret_key)

      assert_called_once(PlaceOrdersResponse.new(^content))
      assert_called_once(Response.get_response_payload(^response))
    end

    test "should return the original content-error", context do
      %{api_key: api_key, secret_key: secret_key, orders: orders} = context

      error = {:error, :content_error, "yep"}
      response = %Response{body: %{"data" => "a"}}

      patch(Response, :get_response_payload, error)
      patch(Client, :signed_request, {:ok, response})

      assert ^error = Trade.place_orders(orders, api_key, secret_key)

      assert_called_once(Response.get_response_payload(^response))
    end
  end
end
