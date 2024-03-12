defmodule BingX.Swap.TradeTest.CancelAllOrdersTest do
  @moduledoc """
  This is module is used to test BingX.API.Trade module.

  ## ATTENTION
  Patch **every** network request to the real world!
  These tests are used only to verify internal logic of the module, nothing else.
  """

  use ExUnit.Case
  use Patch

  alias BingX.Swap.{CancelAllOrdersResponse, Trade}
  alias BingX.HTTP.{Client, Response, Error}
  alias BingX.Swap.Trade.Contract

  setup_all do
    {
      :ok,
      api_key: "API_KEY_FOR_TEST", secret_key: "SECRET_KEY_FOR_TEST", path: "/openApi/swap/v2/trade/allOpenOrders"
    }
  end

  describe "BingX.Swap.Trade cancel_all_orders/3" do
    test "should make DELETE request", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(Client.signed_request(:delete, _path, _api_key, _secret_key, _options))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(Client.signed_request(_method, ^path, _api_key, _secret_key, _options))
    end

    test "should make secure request using provided credentials", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(Client.signed_request(_method, _path, ^api_key, ^secret_key, _options))
    end

    test "should put the symbol into query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      symbol = "BTC-USDT"

      patch(Client, :signed_request, {:error, :http_error, %Error{message: :timeout}})

      Trade.cancel_all_orders(symbol, api_key, secret_key)

      assert_called_once(
        Client.signed_request(
          _method,
          _path,
          _api_key,
          _secret_key,
          params: %{"symbol" => ^symbol}
        )
      )
    end

    test "should extract and validate response content", context do
      %{api_key: api_key, secret_key: secret_key} = context

      content = "X"
      response = %Response{body: %{"data" => content}}
      struct = %{"A" => :B}

      patch(CancelAllOrdersResponse, :new, struct)
      patch(Response, :get_response_payload, {:ok, content})
      patch(Client, :signed_request, {:ok, response})

      Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(Response.get_response_payload(^response))
    end

    test "should wrap the success content into CancelAllOrdersResponse struct", context do
      %{api_key: api_key, secret_key: secret_key} = context

      content = "X"
      response = %Response{body: %{"data" => content}}
      struct = %{"A" => :B}

      patch(CancelAllOrdersResponse, :new, struct)
      patch(Response, :get_response_payload, {:ok, content})
      patch(Client, :signed_request, {:ok, response})

      assert {:ok, ^struct} = Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(CancelAllOrdersResponse.new(^content))
      assert_called_once(Response.get_response_payload(^response))
    end

    test "should return the original content error", context do
      %{api_key: api_key, secret_key: secret_key} = context

      error = {:error, :content_error, "yep"}
      response = %Response{body: %{"data" => "a"}}

      patch(Response, :get_response_payload, error)
      patch(Client, :signed_request, {:ok, response})

      assert ^error = Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)

      assert_called_once(Response.get_response_payload(^response))
    end

    test "should return the original request http error", context do
      %{api_key: api_key, secret_key: secret_key} = context

      error = {:error, :http_error, %Error{message: :timeout}}

      patch(Client, :signed_request, error)

      assert ^error = Trade.cancel_all_orders("BTC-USDT", api_key, secret_key)
    end
  end
end
