defmodule BingX.API.Trade do
  alias BingX.Order
  alias BingX.API.{Exception, Headers, QueryParams}
  alias BingX.API.Trade.{Contract, PlaceOrderResponse, CancelAllOrdersResponse}

  @hostname Application.compile_env!(:bingx, :hostname)

  def url_base, do: @hostname <> "/openApi/swap/v2/trade"

  def place_order(%Order{} = order, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with {:ok, %{body: body}} <- do_place_order(order, api_key, secret_key) do
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

  def cancel_all_orders(api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with {:ok, %{body: body}} <- do_cancel_all_orders(api_key, secret_key) do
      {:ok, data} = Jason.decode(body, keys: :strings)

      case data do
        %{"code" => 0, "data" => payload} ->
          {:ok, CancelAllOrdersResponse.new(payload)}

        %{"code" => code, "msg" => message} ->
          {:error, Exception.new(code, message)}
      end
    end
  end

  defp do_cancel_all_orders(api_key, secret_key) do
    url = url_base() <> "/allOpenOrders"
    headers = Headers.append_api_key(Map.new(), api_key)

    params =
      %{"symbol" => "BTC-USDT"}
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.append_signature(secret_key)

    HTTPoison.delete(url, headers, params: params)
  end
end
