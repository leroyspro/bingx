defmodule BingX.API.TradeTest do
  @moduledoc """
  Module to test BingX.API.Trade.

  ## ATTENTION
  Patch **every** network request to the real world!
  These tests are used only to verify internal logic of the module, nothing else.
  """

  use ExUnit.Case
  use Patch

  alias BingX.API.{QueryParams, Headers, Trade, Exception}
  alias BingX.API.Trade.{PlaceOrderResponse, CancelAllOrdersResponse, CancelOrderResponse}
  alias BingX.Order
  alias BingX.Order.TriggerMarket

  @origin Application.compile_env!(:bingx, :origin)

  setup_all do
    {
      :ok,
      api_key: "API_KEY_FOR_TEST", secret_key: "SECRET_KEY_FOR_TEST"
    }
  end

  describe "BingX.API.Trade place_order/3" do
    setup _context do
      order =
        TriggerMarket.new(%{
          side: :buy,
          position_side: :long,
          price: 51000,
          stop_price: 51000,
          quantity: 0.0001,
          symbol: "BTC-USDT"
        })

      {:ok, endpoint: @origin <> "/openApi/swap/v2/trade/order", order: order}
    end

    test "should make POST request", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      patch(HTTPoison, :post, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.post(_endpoint, _body, _headers, _options))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, secret_key: secret_key, endpoint: endpoint, order: order} = context

      patch(HTTPoison, :post, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.post(^endpoint, _body, _headers, _options))
    end

    test "should request with authentication in headers", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      headers = %{"API_KEY" => api_key}

      patch(Headers, :append_api_key, headers)
      patch(HTTPoison, :post, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(Headers.append_api_key(_, ^api_key))
      assert_called_once(HTTPoison.post(_url, _body, ^headers, _options))
    end

    test "should request with receive window in query params", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      receive_window = 2_310_293_323

      patch(
        QueryParams,
        :append_receive_window,
        &Map.merge(&1, %{"RECEIVE_WINDOW" => receive_window})
      )

      patch(HTTPoison, :post, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.post(_url, _body, _headers, params: %{"RECEIVE_WINDOW" => ^receive_window}))

      assert_called_once(QueryParams.append_receive_window(_params))
    end

    test "should request with timestamp in query params", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      timestamp = 1_923_812_312_342

      patch(QueryParams, :append_timestamp, &Map.merge(&1, %{"TIMESTAMP" => timestamp}))
      patch(HTTPoison, :post, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.post(_url, _body, _headers, params: %{"TIMESTAMP" => ^timestamp}))

      assert_called_once(QueryParams.append_timestamp(_params))
    end

    test "should request with signature in query params", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      signature = "********"

      patch(QueryParams, :append_signature, fn params, _secret_key ->
        Map.merge(params, %{"SIGNATURE" => signature})
      end)

      patch(HTTPoison, :post, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.place_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.post(_url, _body, _headers, params: %{"SIGNATURE" => ^signature}))

      assert_called_once(QueryParams.append_signature(_, ^secret_key))
    end

    test "should return the original error if request failed", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      result = {:error, %HTTPoison.Error{reason: :timeout}}

      patch(HTTPoison, :post, result)

      assert ^result = Trade.place_order(order, api_key, secret_key)
    end

    test "should return the original error if request is not 200", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      result = {:error, %HTTPoison.Response{status_code: 301}}

      patch(HTTPoison, :post, result)

      assert ^result = Trade.place_order(order, api_key, secret_key)
    end

    test "should wrap the successful response in PlaceOrderResponse", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      data = %{"success" => "ALWAYS!"}
      body = Jason.encode!(%{"code" => 0, "data" => %{"order" => data}})
      struct = %{success: "ALWAYS!"}

      patch(HTTPoison, :post, {:ok, %HTTPoison.Response{body: body, status_code: 200}})
      patch(PlaceOrderResponse, :new, struct)

      assert {:ok, ^struct} = Trade.place_order(order, api_key, secret_key)

      assert_called_once(PlaceOrderResponse.new(^data))
    end

    test "should wrap the unsuccessful response in Exception", context do
      %{api_key: api_key, secret_key: secret_key, order: order} = context

      code = 1001
      message = "Some ridiculous response from megaminds"
      body = Jason.encode!(%{"code" => code, "msg" => message})
      struct = %{success: "NEVER!"}

      patch(HTTPoison, :post, {:ok, %HTTPoison.Response{body: body, status_code: 200}})
      patch(Exception, :new, struct)

      assert {:error, ^struct} = Trade.place_order(order, api_key, secret_key)

      assert_called_once(Exception.new(^code, ^message))
    end
  end

  describe "BingX.API.Trade cancel_all_orders/3" do
    setup _context do
      {:ok, endpoint: @origin <> "/openApi/swap/v2/trade/allOpenOrders"}
    end

    test "should make DELETE request", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(HTTPoison.delete(_endpoint, _headers, _options))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, secret_key: secret_key, endpoint: endpoint} = context

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(HTTPoison.delete(^endpoint, _headers, _options))
    end

    test "should request with authentication in headers", context do
      %{api_key: api_key, secret_key: secret_key} = context

      headers = %{"API_KEY" => api_key}

      patch(Headers, :append_api_key, headers)
      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(Headers.append_api_key(_, ^api_key))
      assert_called_once(HTTPoison.delete(_url, ^headers, _options))
    end

    test "should request with symbol in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      symbol = "BTC-USDT"

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"symbol" => ^symbol}))
    end

    test "should request with receive window in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      receive_window = 2_312_321_321

      patch(
        QueryParams,
        :append_receive_window,
        &Map.merge(&1, %{"RECEIVE_WINDOW" => receive_window})
      )

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"RECEIVE_WINDOW" => ^receive_window}))

      assert_called_once(QueryParams.append_receive_window(_))
    end

    test "should request with timestamp in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      timestamp = 102_312_321
      patch(QueryParams, :append_timestamp, &Map.merge(&1, %{"TIMESTAMP" => timestamp}))

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"TIMESTAMP" => ^timestamp}))
      assert_called_once(QueryParams.append_timestamp(_params))
    end

    test "should request with signature in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      signature = 102_312_321

      patch(QueryParams, :append_signature, fn params, _secret_key ->
        Map.merge(params, %{"SIGNATURE" => signature})
      end)

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"SIGNATURE" => ^signature}))
      assert_called_once(QueryParams.append_signature(_params, ^secret_key))
    end

    test "should return the original error if request failed", context do
      %{api_key: api_key, secret_key: secret_key} = context

      result = {:error, %HTTPoison.Error{reason: :timeout}}

      patch(HTTPoison, :delete, result)

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)
    end

    test "should return the original error if request is not 200", context do
      %{api_key: api_key, secret_key: secret_key} = context

      result = {:error, %HTTPoison.Response{status_code: 301}}

      patch(HTTPoison, :delete, result)

      assert ^result = Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)
    end

    test "should wrap the successful response in CancelAllOrdersResponse", context do
      %{api_key: api_key, secret_key: secret_key} = context

      data = %{"success" => "ALWAYS!"}
      body = Jason.encode!(%{"code" => 0, "data" => data})
      struct = %{success: "ALWAYS!"}

      patch(HTTPoison, :delete, {:ok, %HTTPoison.Response{body: body, status_code: 200}})
      patch(CancelAllOrdersResponse, :new, struct)

      assert {:ok, ^struct} = Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(CancelAllOrdersResponse.new(^data))
    end

    test "should wrap the unsuccessful response in Exception", context do
      %{api_key: api_key, secret_key: secret_key} = context

      code = 1001
      message = "Too funny"
      body = Jason.encode!(%{"code" => code, "msg" => message})
      struct = %{success: "NEVER!"}

      patch(HTTPoison, :delete, {:ok, %HTTPoison.Response{body: body, status_code: 200}})
      patch(Exception, :new, struct)

      assert {:error, ^struct} = Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(Exception.new(^code, ^message))
    end
  end

  describe "BingX.API.Trade cancel_order/3" do
    setup _context do
      {:ok, endpoint: @origin <> "/openApi/swap/v2/trade/order"}
    end

    test "should make DELETE request", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      order = %Order{symbol: "BTC-USDT"}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.delete(_endpoint, _headers, _options))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, secret_key: secret_key, endpoint: endpoint} = context

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      order = %Order{symbol: "BTC-USDT"}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.delete(^endpoint, _headers, _options))
    end

    test "should request with authentication in headers", context do
      %{api_key: api_key, secret_key: secret_key} = context

      headers = %{"API_KEY" => api_key}

      patch(Headers, :append_api_key, headers)
      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      order = %Order{symbol: "BTC-USDT"}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(Headers.append_api_key(_, ^api_key))
      assert_called_once(HTTPoison.delete(_url, ^headers, _options))
    end

    test "should request with symbol in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      symbol = "BTC-USDT"
      order = %Order{symbol: symbol}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"symbol" => ^symbol}))
    end

    test "should raise error for missed symbol param", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      assert_raise ArgumentError,
                   "expected :symbol param to be given",
                   fn -> Trade.cancel_order(%Order{}, api_key, secret_key) end
    end

    test "should request with default order id in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      order = %Order{symbol: "BTC-USDT"}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"orderId" => ""}))
    end

    test "should request with default client order id in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      order = %Order{symbol: "BTC-USDT"}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"clientOrderID" => ""}))
    end

    test "should request with the provided order id in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      order_id = "ORDER_ID_FOR_TEST"
      order = %Order{symbol: "BTC-USDT", order_id: order_id}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"orderId" => ^order_id}))
    end

    test "should request with the provided client order id in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      client_order_id = "CLIENT_ORDER_ID_FOR_TEST"
      order = %Order{symbol: "BTC-USDT", client_order_id: client_order_id}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"clientOrderID" => ^client_order_id}))
    end

    test "should request with receive window in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      receive_window = 2_312_321_321

      patch(
        QueryParams,
        :append_receive_window,
        &Map.merge(&1, %{"RECEIVE_WINDOW" => receive_window})
      )

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      order = %Order{symbol: "BTC-USDT"}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"RECEIVE_WINDOW" => ^receive_window}))
      assert_called_once(QueryParams.append_receive_window(_))
    end

    test "should request with timestamp in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      timestamp = 102_312_321
      patch(QueryParams, :append_timestamp, &Map.merge(&1, %{"TIMESTAMP" => timestamp}))

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      order = %Order{symbol: "BTC-USDT"}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"TIMESTAMP" => ^timestamp}))
      assert_called_once(QueryParams.append_timestamp(_params))
    end

    test "should request with signature in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      signature = 102_312_321

      patch(QueryParams, :append_signature, fn params, _secret_key ->
        Map.merge(params, %{"SIGNATURE" => signature})
      end)

      patch(HTTPoison, :delete, {:error, %HTTPoison.Error{reason: :timeout}})

      order = %Order{symbol: "BTC-USDT"}
      Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(HTTPoison.delete(_url, _headers, params: %{"SIGNATURE" => ^signature}))
      assert_called_once(QueryParams.append_signature(_params, ^secret_key))
    end

    test "should return the original error if request is not 200", context do
      %{api_key: api_key, secret_key: secret_key} = context

      result = {:error, %HTTPoison.Response{status_code: 301}}

      patch(HTTPoison, :delete, result)

      order = %Order{symbol: "BTC-USDT"}
      assert ^result = Trade.cancel_order(order, api_key, secret_key)
    end

    test "should wrap the successful response in CancelAllOrdersResponse", context do
      %{api_key: api_key, secret_key: secret_key} = context

      data = %{"success" => "ALWAYS!"}
      body = Jason.encode!(%{"code" => 0, "data" => %{"order" => data}})
      struct = %{success: "ALWAYS!"}

      patch(HTTPoison, :delete, {:ok, %HTTPoison.Response{body: body, status_code: 200}})
      patch(CancelOrderResponse, :new, struct)

      order = %Order{symbol: "BTC-USDT"}
      assert {:ok, ^struct} = Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(CancelOrderResponse.new(^data))
    end

    test "should wrap the unsuccessful response in Exception", context do
      %{api_key: api_key, secret_key: secret_key} = context

      code = 1001
      message = "Too funny"
      body = Jason.encode!(%{"code" => code, "msg" => message})
      struct = %{success: "NEVER!"}

      patch(HTTPoison, :delete, {:ok, %HTTPoison.Response{body: body, status_code: 200}})
      patch(Exception, :new, struct)

      order = %Order{symbol: "BTC-USDT"}
      assert {:error, ^struct} = Trade.cancel_order(order, api_key, secret_key)

      assert_called_once(Exception.new(^code, ^message))
    end
  end
end
