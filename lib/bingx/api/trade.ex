defmodule BingX.API.Trade do
  alias BingX.Order
  alias BingX.API.{Exception, Headers, QueryParams}
  alias BingX.API.Trade.{Contract, PlaceOrderResponse, CancelAllOrdersResponse, CancelOrderResponse}

  @origin Application.compile_env!(:bingx, :origin)

  def url_base, do: @origin <> "/openApi/swap/v2/trade"

  def place_order(%Order{} = order, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, %{body: body, status_code: 200}} <-
        do_place_order(order, api_key, secret_key)
    ) do
      {:ok, data} = Jason.decode(body, keys: :strings)

      case data do
        %{"code" => 0, "data" => %{"order" => payload}} ->
          {:ok, PlaceOrderResponse.new(payload)}

        %{"code" => code, "msg" => message} ->
          {:error, Exception.new(code, message)}
      end
    end
  end

  defp do_place_order(order, api_key, secret_key) do
    url = url_base() <> "/order"
    body = ""
    headers = Headers.append_api_key(Map.new(), api_key)

    params =
      order
      |> Contract.from_order()
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.append_signature(secret_key)

    HTTPoison.post(url, body, headers, params: params)
  end

  def cancel_order(%Order{} = order, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, %{body: body, status_code: 200}} <-
        do_cancel_order(order, api_key, secret_key)
    ) do
      {:ok, data} = Jason.decode(body, keys: :strings)

      case data do
        %{"code" => 0, "data" => %{"order" => payload}} ->
          {:ok, CancelOrderResponse.new(payload)}

        %{"code" => code, "msg" => message} ->
          {:error, Exception.new(code, message)}
      end
    end
  end

  defp do_cancel_order(order, api_key, secret_key) do
    url = url_base() <> "/order"
    headers = Headers.append_api_key(Map.new(), api_key)

    symbol = order.symbol || raise ArgumentError, "expected :symbol param to be given"
    order_id = order.order_id || ""
    client_order_id = order.client_order_id || ""

    params =
      %{
        "symbol" => symbol,
        "orderId" => order_id,
        "clientOrderID" => client_order_id
      }
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.append_signature(secret_key)

    HTTPoison.delete(url, headers, params: params)
  end

  def cancel_all_orders(symbol, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, %{body: body, status_code: 200}} <-
        do_cancel_all_orders(symbol, api_key, secret_key)
    ) do
      {:ok, data} = Jason.decode(body, keys: :strings)

      case data do
        %{"code" => 0, "data" => payload} ->
          {:ok, CancelAllOrdersResponse.new(payload)}

        %{"code" => code, "msg" => message} ->
          {:error, Exception.new(code, message)}
      end
    end
  end

  defp do_cancel_all_orders(symbol, api_key, secret_key) do
    url = url_base() <> "/allOpenOrders"
    headers = Headers.append_api_key(Map.new(), api_key)

    params =
      %{"symbol" => symbol}
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.append_signature(secret_key)

    HTTPoison.delete(url, headers, params: params)
  end
end
