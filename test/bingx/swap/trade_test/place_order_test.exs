defmodule BingX.Swap.TradeTest.PlaceOrderTest do
  @moduledoc """
  This is module is used to test BingX.API.Trade module.

  ## ATTENTION
  Patch **every** network request to the real world!
  These tests are used only to verify internal logic of the module, nothing else.
  """

  use ExUnit.Case
  use Patch

  alias BingX.Swap.{PlaceOrderResponse, Trade, Order}
  alias BingX.HTTP.{Client, Response, Error}
  alias BingX.Swap.Trade.Contract

  setup_all do
    order =
      %Order{
        side: :buy,
        position_side: :long,
        price: 51000,
        stop_price: 51000,
        quantity: 0.0001,
        symbol: "BTC-USDT"
      }

    {
      :ok,
      order: order, api_key: "API_KEY_FOR_TEST", secret_key: "SECRET_KEY_FOR_TEST", path: "/openApi/swap/v2/trade/order"
    }
  end

  describe "BingX.Swap.Trade place_order/3" do
    test "should make POST request", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(Client.signed_request(:post, _path, _api_key, _secret_key, _options))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, secret_key: secret_key, path: path, order: order} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(Client.signed_request(_method, ^path, _api_key, _secret_key, _options))
    end

    test "should make secure request using provided credentials", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(Client.signed_request(_method, _path, ^api_key, ^secret_key, _options))
    end

    test "should put transformed Order struct into query params", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      contract = %{"K" => "V"}
      options = [params: contract]

      patch(Contract, :from_order, contract)
      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(Contract.from_order(^order))
      assert_called_once(Client.signed_request(_method, _path, _api_key, _secret_key, ^options))
    end

    test "should return the original request http-error", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      error = {:error, :http_error, %Error{message: :timeout}}

      patch(Contract, :from_order, %{"K" => "V"})
      patch(Client, :signed_request, error)

      assert ^error = Trade.place_order(order, api_key, secret_key)
    end

    test "should extract and validate response content", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      content = "X"
      response = %Response{body: %{"data" => content}}
      struct = %{"A" => :s}

      patch(PlaceOrderResponse, :new, struct)
      patch(Response, :process_response, {:ok, content})
      patch(Client, :signed_request, {:ok, response})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(Response.process_response(^response))
    end

    test "should wrap the content into PlaceOrderResponse struct", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      content = "X"
      response = %Response{body: %{"data" => content}}
      struct = %{"A" => :s}

      patch(PlaceOrderResponse, :new, struct)
      patch(Response, :process_response, {:ok, content})
      patch(Client, :signed_request, {:ok, response})

      assert {:ok, ^struct} = Trade.place_order(order, api_key, secret_key)

      assert_called_once(PlaceOrderResponse.new(^content))
      assert_called_once(Response.process_response(^response))
    end

    test "should return the original content-error", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      error = {:error, :content_error, "yep"}
      response = %Response{body: %{"data" => "a"}}

      patch(Response, :process_response, error)
      patch(Client, :signed_request, {:ok, response})

      assert ^error = Trade.place_order(order, api_key, secret_key)

      assert_called_once(Response.process_response(^response))
    end
  end
end
