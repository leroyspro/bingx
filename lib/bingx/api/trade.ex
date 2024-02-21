defmodule Bingx.API.Trade do
  use HTTPoison.Base

  alias BingX.Order
  alias BingX.API.Helpers.{Response, QueryParams, Headers}

  @endpoint Application.compile_env(
              :bingx,
              :endpoint,
              "https://open-api.bingx.com"
            )
  @api_v2 "/openApi/swap/v2"
  @scope "/trade"
  @url_base @api_v2 <> @scope

  @impl true
  def process_request_url(url), do: @endpoint <> url

  def cancel_all_orders(api_key, secret_key) when is_binary(api_key) do
    with(
      {:ok, resp} <- do_cancel_all_orders(api_key, secret_key),
      {:ok, data} <- Jason.decode(resp.body, keys: :strings)
    ) do
      {:ok, _payload} = Response.extract_payload(data, "balance")
    end
  end

  defp do_cancel_all_orders(api_key, secret_key) do
    headers = Headers.append_api_key(api_key)

    params =
      %{"symbol" => "BTC-USDT"}
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.sign(secret_key)

    __MODULE__.delete(@url_base <> "/allOpenOrders", headers, params: params)
  end

  def place_order(%Order{} = order, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, resp} <- do_place_order(order, api_key, secret_key),
      {:ok, data} <- Jason.decode(resp.body, keys: :strings)
    ) do
      {:ok, _payload} = Response.extract_payload(data, "order")
    end
  end

  defp do_place_order(order, api_key, secret_key) do
    headers = Headers.append_api_key(api_key)

    params =
      order
      |> order_to_query_params()
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.sign(secret_key)

    __MODULE__.post(@url_base <> "/order", "", headers, params: params)
  end

  defp order_to_query_params(order) do
    order
    |> Enum.reduce(fn
      {:order_id, x}, acc -> Map.merge(acc, %{"orderId" => x})
      {:type, x}, acc -> Map.merge(acc, %{"type" => x})
      {:symbol, x}, acc -> Map.merge(acc, %{"symbol" => x})
      {:side, x}, acc -> Map.merge(acc, %{"side" => x})
      {:position_side, x}, acc -> Map.merge(acc, %{"positionSide" => x})
      {:stop_price, x}, acc -> Map.merge(acc, %{"stopPrice" => x})
      {:price, x}, acc -> Map.merge(acc, %{"price" => x})
      {:quantity, x}, acc -> Map.merge(acc, %{"quantity" => x})
      {_key, _value}, acc -> acc
    end)
  end
end
