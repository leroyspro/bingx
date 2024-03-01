defmodule BingX.Swap.Trade do
  import BingX.HTTP.Client, only: [signed_request: 5]

  alias BingX.HTTP.Response
  alias BingX.Swap.Trade.Contract
  alias BingX.Helpers
  alias BingX.Swap.Order

  alias BingX.Swap.Trade.{
    PlaceOrderResponse,
    PlaceOrdersResponse,
    CancelAllOrdersResponse, CancelOrdersResponse,
    CancelOrderResponse
  }

  @api_scope "/openApi/swap/v2/trade"

  @cancel_order_path @api_scope <> "/order"
  @place_order_path @api_scope <> "/order"

  @place_orders_path @api_scope <> "/batchOrders"
  @cancel_orders_path @api_scope <> "/batchOrders"

  @cancel_all_orders_path @api_scope <> "/allOpenOrders"

  # Interface
  # =========

  def place_order(%Order{} = order, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do

    with(
      {:ok, resp} <- do_place_order(order, api_key, secret_key),
      {:ok, content} <- Response.extract_validated_content(resp)
    ) do
      {:ok, PlaceOrderResponse.new(content)}
    end
  end

  def place_orders(orders, api_key, secret_key)
      when is_list(orders) and is_binary(api_key) and is_binary(secret_key) do

    with(
      {:ok, resp} <- do_place_orders(orders, api_key, secret_key),
      {:ok, content} <- Response.extract_validated_content(resp)
    ) do
      {:ok, PlaceOrdersResponse.new(content)}
    end
  end

  def cancel_order_by_id(symbol, order_id, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do

    with(
      {:ok, resp} <- do_cancel_order(symbol, order_id, "", api_key, secret_key),
      {:ok, content} <- Response.extract_validated_content(resp)
    ) do
      dbg()
      {:ok, CancelOrderResponse.new(content)}
    end
  end

  def cancel_order_by_client_id(symbol, client_id, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_order(symbol, "", client_id, api_key, secret_key),
      {:ok, content} <- Response.extract_validated_content(resp)
    ) do
      {:ok, CancelOrderResponse.new(content)}
    end
  end

  def cancel_orders_by_ids(symbol, order_ids, api_key, secret_key)
      when is_binary(symbol) and
             is_list(order_ids) and
             is_binary(api_key) and
             is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_orders(symbol, order_ids, [], api_key, secret_key),
      {:ok, content} <- Response.extract_validated_content(resp)
    ) do
      {:ok, CancelOrdersResponse.new(content)}
    end
  end

  def cancel_orders_by_client_ids(symbol, client_order_ids, api_key, secret_key)
      when is_binary(symbol) and
             is_list(client_order_ids) and
             is_binary(api_key) and
             is_binary(secret_key) do

    with(
      {:ok, resp} <- do_cancel_orders(symbol, [], client_order_ids, api_key, secret_key),
      {:ok, content} <- Response.extract_validated_content(resp)
    ) do
      {:ok, CancelOrdersResponse.new(content)}
    end
  end

  def cancel_all_orders(symbol, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do

    with(
      {:ok, resp} <- do_cancel_all_orders(symbol, api_key, secret_key),
      {:ok, content} <- Response.extract_validated_content(resp)
    ) do
      {:ok, CancelAllOrdersResponse.new(content)}
    end
  end

  # Helpers
  # =======

  defp do_place_order(order, api_key, secret_key) do
    params = Contract.from_order(order)

    signed_request(:post, @place_order_path, api_key, secret_key, params: params)
  end

  defp do_place_orders(orders, api_key, secret_key) do
    raw_orders =
      orders
      |> Enum.map(&Contract.from_order/1)
      |> Enum.map(&Jason.encode!/1)
      |> Helpers.to_string()

    params = %{"batchOrders" => raw_orders}

    signed_request(:post, @place_orders_path, api_key, secret_key, params: params)
  end

  defp do_cancel_order(symbol, order_id, client_order_id, api_key, secret_key) do
    params = %{
      "symbol" => symbol,
      "orderId" => order_id,
      "clientOrderID" => client_order_id
    }

    signed_request(:delete, @cancel_order_path, api_key, secret_key, params: params)
  end

  defp do_cancel_orders(symbol, order_ids, client_order_ids, api_key, secret_key) do
    params = %{
      "symbol" => symbol,
      "orderIdList" => Helpers.to_string(order_ids),
      "clientOrderIDList" => Helpers.to_string(client_order_ids)
    }

    signed_request(:delete, @cancel_orders_path, api_key, secret_key, params: params)
  end

  defp do_cancel_all_orders(symbol, api_key, secret_key) do
    params = %{"symbol" => symbol}

    signed_request(:delete, @cancel_all_orders_path, api_key, secret_key, params: params)
  end
end
