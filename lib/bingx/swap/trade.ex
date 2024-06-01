defmodule BingX.Swap.Trade do
  @moduledoc """
  This module provides functions making requests for swap trade API methods using abstractions on known internal interfaces.

  BingX swap trade API: https://bingx-api.github.io/docs/#/en-us/swapV2/trade-api.html#Trade%20order%20test
  """

  import BingX.HTTP.Client, only: [signed_request: 5]
  import BingX.Swap.Interpretators, only: [to_external_margin_mode: 1, to_external_position_side: 1]

  alias BingX.Helpers
  alias BingX.HTTP.Response
  alias BingX.Swap.Trade.Contract
  alias BingX.Swap.Order

  alias BingX.Swap.{
    PlaceOrderResponse,
    PlaceOrdersResponse,
    CancelOrderResponse,
    CancelOrdersResponse,
    CloseAllPositionsResponse,
    CancelAllOrdersResponse,
    SetLeverageResponse,
    PendingOrdersResponse,
    GetAllOrdersResponse,
    GetOrderResponse
  }

  @api_scope_v2 "/openApi/swap/v2/trade"
  @api_scope_v1 "/openApi/swap/v1/trade"

  @place_order_path @api_scope_v2 <> "/order"
  @cancel_order_path @api_scope_v2 <> "/order"
  @get_order_path @api_scope_v2 <> "/order"

  @place_orders_path @api_scope_v2 <> "/batchOrders"
  @cancel_orders_path @api_scope_v2 <> "/batchOrders"

  @close_all_positions_path @api_scope_v2 <> "/closeAllPositions"
  @cancel_all_orders_path @api_scope_v2 <> "/allOpenOrders"

  @set_margin_mode_path @api_scope_v2 <> "/marginType"
  @set_leverage_path @api_scope_v2 <> "/leverage"

  @get_pending_orders_path @api_scope_v2 <> "/openOrders"
  @get_all_orders_path @api_scope_v1 <> "/fullOrder"

  # Interface
  # =========

  @doc """
  Requests to place an order using order data with account credentials.
  """
  def place_order(%Order{} = order, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_place_order(order, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, PlaceOrderResponse.new(payload)}
    end
  end

  @doc """
  Requests to place bunch of orders using list of order data with account credentials.
  """
  def place_orders(orders, api_key, secret_key)
      when is_list(orders) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_place_orders(orders, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, PlaceOrdersResponse.new(payload)}
    end
  end

  @doc """
  Requests to cancel an order by its market symbol (ex. BTC-USDT) and order ID with account credentials.
  """
  def cancel_order_by_id(symbol, order_id, api_key, secret_key)
      when is_binary(symbol) and is_binary(order_id) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_order(symbol, order_id, "", api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, CancelOrderResponse.new(payload)}
    end
  end

  @doc """
  Requests to cancel an order by its market symbol (ex. BTC-USDT) and client order ID with account credentials.
  """
  def cancel_order_by_client_id(symbol, client_id, api_key, secret_key)
      when is_binary(symbol) and is_binary(client_id) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_order(symbol, "", client_id, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, CancelOrderResponse.new(payload)}
    end
  end

  @doc """
  Requests to cancel a batch of orders by their market symbol (ex. BTC-USDT) and order IDs with account credentials.
  """
  def cancel_orders_by_ids(symbol, order_ids, api_key, secret_key)
      when is_binary(symbol) and is_list(order_ids) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_orders(symbol, order_ids, [], api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, CancelOrdersResponse.new(payload)}
    end
  end

  @doc """
  Requests to cancel bunch of orders by their market symbol (ex. BTC-USDT) and client order IDs with account credentials.
  """
  def cancel_orders_by_client_ids(symbol, client_order_ids, api_key, secret_key)
      when is_binary(symbol) and is_list(client_order_ids) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_orders(symbol, [], client_order_ids, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, CancelOrdersResponse.new(payload)}
    end
  end

  @doc """
  Request to close all positions by market symbol (ex. BTC-USDT) with account credentials.
  """
  def close_all_positions(symbol, api_key, secret_key)
      when is_binary(symbol) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_close_all_positions(symbol, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, CloseAllPositionsResponse.new(payload)}
    end
  end

  @doc """
  Requests to cancel all orders by their market symbol (ex. BTC-USDT) with account credentials.
  """
  def cancel_all_orders(symbol, api_key, secret_key)
      when is_binary(symbol) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_all_orders(symbol, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, CancelAllOrdersResponse.new(payload)}
    end
  end

  @doc """
  Request to set user's margin mode by market symbol and account credentials.
  Margin mode can be either `:crossed` or `:isolated`.
  """
  def set_margin_mode(symbol, margin_mode, api_key, secret_key)
      when is_binary(symbol) and
             is_atom(margin_mode) and
             is_binary(api_key) and
             is_binary(secret_key) do
    with(
      {:ok, resp} <- do_set_margin_mode(symbol, margin_mode, api_key, secret_key),
      {:ok, _payload} <- Response.process_response(resp)
    ) do
      :ok
    end
  end

  @doc """
  Request to set user's leverage amount by market symbol, position side and account credentials.
  Position side can be either `:crossed` or `:isolated`.
  Currently, BingX allows leverage from 1 to 125.
  """
  def set_leverage(symbol, position_side, leverage, api_key, secret_key)
      when is_binary(symbol) and
             is_atom(position_side) and
             is_integer(leverage) and
             leverage > 0 and
             is_binary(api_key) and
             is_binary(secret_key) do
    with(
      {:ok, resp} <- do_set_leverage(symbol, position_side, leverage, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, SetLeverageResponse.new(payload)}
    end
  end

  @doc """
  Retrieves all the pending (not triggered) orders by their market symbol (ex. BTC-USDT) with account credentials.
  """
  def get_pending_orders(symbol, api_key, secret_key)
      when is_binary(symbol) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_get_pending_orders(symbol, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, PendingOrdersResponse.new(payload)}
    end
  end

  @doc """
  Request to get all user's orders (pending, active, ...) by an optional period (start_time, end_time)
  and an optional limit of returned amount of orders with account credentials.
  """
  def get_all_orders(symbol, start_time \\ nil, end_time \\ nil, limit \\ 50, api_key, secret_key)
      when is_binary(symbol) and is_integer(limit) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_get_all_orders(symbol, start_time, end_time, limit, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, GetAllOrdersResponse.new(payload)}
    end
  end

  @doc """
  Request to get a specific user's order (pending, active, ...) with account credentials.
  """
  def get_order(symbol, order_id, api_key, secret_key)
      when is_binary(symbol) and is_binary(order_id) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_get_order(symbol, order_id, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, GetOrderResponse.new(payload)}
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
      |> Helpers.to_string()

    params = %{"batchOrders" => raw_orders}

    signed_request(:post, @place_orders_path, api_key, secret_key, params: params)
  end

  defp do_close_all_positions(symbol, api_key, secret_key) do
    params = %{"symbol" => symbol}
    signed_request(:post, @close_all_positions_path, api_key, secret_key, params: params)
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

  defp do_set_margin_mode(symbol, margin_mode, api_key, secret_key) do
    params = %{
      "symbol" => symbol,
      "marginType" => to_external_margin_mode(margin_mode)
    }

    signed_request(:post, @set_margin_mode_path, api_key, secret_key, params: params)
  end

  defp do_set_leverage(symbol, position_side, leverage, api_key, secret_key) do
    params = %{
      "symbol" => symbol,
      "side" => to_external_position_side(position_side),
      "leverage" => leverage
    }

    signed_request(:post, @set_leverage_path, api_key, secret_key, params: params)
  end

  defp do_get_pending_orders(symbol, api_key, secret_key) do
    params = %{"symbol" => symbol}
    signed_request(:get, @get_pending_orders_path, api_key, secret_key, params: params)
  end

  defp do_get_all_orders(symbol, start_time, end_time, limit, api_key, secret_key) do
    params =
      %{
        "symbol" => symbol,
        "startTime" => start_time,
        "endTime" => end_time,
        "limit" => limit
      }
      |> Enum.reject(fn {_, v} -> is_nil(v) end)
      |> Map.new()

    signed_request(:get, @get_all_orders_path, api_key, secret_key, params: params)
  end

  defp do_get_order(symbol, order_id, api_key, secret_key) do
    params = %{"symbol" => symbol, "orderId" => order_id}
    signed_request(:get, @get_order_path, api_key, secret_key, params: params)
  end
end
