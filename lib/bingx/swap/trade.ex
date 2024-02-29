defmodule BingX.Swap.Trade do
  alias BingX.Response
  alias BingX.Swap.Trade.Contract
  alias BingX.Helpers
  alias BingX.Request
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

  @spec place_order(order :: Order.t(), api_key :: binary(), secret_key :: binary()) ::
          {:error,
           {:bad_decode, binary()}
           | {:unexpected_status_code, integer()}
           | %BingX.Exception{}
           | %HTTPoison.Error{}}
          | {:ok, %BingX.Swap.Trade.PlaceOrderResponse{}}
  def place_order(%Order{} = order, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_place_order(order, api_key, secret_key),
      :ok <- Response.validate(resp, only: 200),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body),
      {:ok, content} <- Response.extract_content(data)
    ) do
      {:ok, PlaceOrderResponse.new(content)}
    end
  end

  @spec place_orders(orders :: list(Order.t()), api_key :: binary(), secret_key :: binary()) ::
          {:error,
           {:bad_decode, binary()}
           | {:unexpected_status_code, integer()}
           | %BingX.Exception{}
           | %HTTPoison.Error{}}
          | {:ok, map()}
  def place_orders(orders, api_key, secret_key)
      when is_list(orders) and is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_place_orders(orders, api_key, secret_key),
      :ok <- Response.validate(resp, only: 200),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body),
      {:ok, content} <- Response.extract_content(data)
    ) do
      {:ok, PlaceOrdersResponse.new(content)}
    end
  end

  @spec cancel_order_by_id(symbol :: binary(), order_id :: binary(), api_key :: binary(), secret_key :: binary()) ::
          {:error,
           {:bad_decode, binary()}
           | {:unexpected_status_code, integer()}
           | %BingX.Exception{}
           | %HTTPoison.Error{}}
          | {:ok, %CancelOrderResponse{}}
  def cancel_order_by_id(symbol, order_id, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do

    with(
      {:ok, resp} <- do_cancel_order(symbol, order_id, "", api_key, secret_key),
      :ok <- Response.validate(resp, only: 200),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body),
      {:ok, content} <- Response.extract_content(data)
    ) do
      {:ok, CancelOrderResponse.new(content)}
    end
  end

  @spec cancel_order_by_client_id(symbol :: binary(), client_id :: binary(), api_key :: binary(), secret_key :: binary()) ::
          {:error,
           {:bad_decode, binary()}
           | {:unexpected_status_code, integer()}
           | %BingX.Exception{}
           | %HTTPoison.Error{}}
          | {:ok, %CancelOrderResponse{}}
  def cancel_order_by_client_id(symbol, client_id, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_order(symbol, "", client_id, api_key, secret_key),
      :ok <- Response.validate(resp, only: 200),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body),
      {:ok, content} <- Response.extract_content(data)
    ) do
      {:ok, CancelOrderResponse.new(content)}
    end
  end

  @spec cancel_orders_by_ids(
          symbol :: binary(),
          order_ids :: list(),
          api_key :: binary(),
          secret_key :: binary()
        ) ::
          {:error,
           {:bad_decode, binary()}
           | {:unexpected_status_code, integer()}
           | %BingX.Exception{}
           | %HTTPoison.Error{}}
          | {:ok, %CancelOrderResponse{}}
  def cancel_orders_by_ids(symbol, order_ids, api_key, secret_key)
      when is_binary(symbol) and
             is_list(order_ids) and
             is_binary(api_key) and
             is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_orders(symbol, order_ids, [], api_key, secret_key),
      :ok <- Response.validate(resp, only: 200),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body),
      {:ok, content} <- Response.extract_content(data)
    ) do
      {:ok, CancelOrdersResponse.new(content)}
    end
  end

  @spec cancel_orders_by_client_ids(
          symbol :: binary(),
          client_order_ids :: list(),
          api_key :: binary(),
          secret_key :: binary()
        ) ::
          {:error,
           {:bad_decode, binary()}
           | {:unexpected_status_code, integer()}
           | %BingX.Exception{}
           | %HTTPoison.Error{}}
          | {:ok, %CancelOrderResponse{}}
  def cancel_orders_by_client_ids(symbol, client_order_ids, api_key, secret_key)
      when is_binary(symbol) and
             is_list(client_order_ids) and
             is_binary(api_key) and
             is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_orders(symbol, [], client_order_ids, api_key, secret_key),
      :ok <- Response.validate(resp, only: 200),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body),
      {:ok, content} <- Response.extract_content(data)
    ) do
      {:ok, CancelOrdersResponse.new(content)}
    end
  end

  @spec cancel_all_orders(any(), binary(), binary()) ::
          {:error,
           {:bad_decode, binary()}
           | {:unexpected_status_code, integer()}
           | %BingX.Exception{}
           | %HTTPoison.Error{}}
          | {:ok, BingX.Swap.Trade.CancelAllOrdersResponse.t()}
  def cancel_all_orders(symbol, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_cancel_all_orders(symbol, api_key, secret_key),
      :ok <- Response.validate(resp, only: 200),
      {:ok, body} <- Response.extract_body(resp),
      {:ok, data} <- Response.decode_body(body),
      {:ok, content} <- Response.extract_content(data)
    ) do
      {:ok, CancelAllOrdersResponse.new(content)}
    end
  end

  # Helpers
  # =======

  defp do_place_order(order, api_key, secret_key) do
    params = Contract.from_order(order)
    url = Request.build_url(@place_order_path, params, sign: secret_key)
    headers = Request.auth_headers(api_key)

    HTTPoison.post(url, "", headers)
  end

  defp do_place_orders(orders, api_key, secret_key) do
    raw_orders =
      orders
      |> Enum.map(&Contract.from_order/1)
      |> Enum.map(&Jason.encode!/1)
      |> Helpers.to_string()

    params = %{"batchOrders" => raw_orders}

    url = Request.build_url(@place_orders_path, params, sign: secret_key)
    headers = Request.auth_headers(api_key)

    HTTPoison.post(url, "", headers)
  end

  defp do_cancel_order(symbol, order_id, client_order_id, api_key, secret_key) do
    params = %{
      "symbol" => symbol,
      "orderId" => order_id,
      "clientOrderID" => client_order_id
    }

    url = Request.build_url(@cancel_order_path, params, sign: secret_key)
    headers = Request.auth_headers(api_key)

    HTTPoison.delete(url, headers)
  end

  defp do_cancel_orders(symbol, order_ids, client_order_ids, api_key, secret_key) do
    params = %{
      "symbol" => symbol,
      "orderIdList" => Helpers.to_string(order_ids),
      "clientOrderIDList" => Helpers.to_string(client_order_ids)
    }

    url = Request.build_url(@cancel_orders_path, params, sign: secret_key)
    headers = Request.auth_headers(api_key)

    HTTPoison.delete(url, headers)
  end

  defp do_cancel_all_orders(symbol, api_key, secret_key) do
    params = %{"symbol" => symbol}
    url = Request.build_url(@cancel_all_orders_path, params, sign: secret_key)
    headers = Request.auth_headers(api_key)

    HTTPoison.delete(url, headers)
  end
end
