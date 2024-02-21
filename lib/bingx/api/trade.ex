defmodule BingX.API.Trade do
  use HTTPoison.Base

  alias BingX.Order
  alias BingX.API.Helpers.{Response, QueryParams, Headers}

  @endpoint Application.compile_env!(:bingx, :endpoint)

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
    |> Map.from_struct()
    |> Stream.reject(fn {_k, v} -> is_nil(v) end)
    |> Stream.map(fn
      {:position_side, x} -> {"positionSide", x}
      {:client_order_id, x} -> {"clientOrderID", x}
      {:stop_price, x} -> {"stopPrice", x}
      {:stop_loss, x} -> {"stopLoss", x}
      {:take_profit, x} -> {"takeProfit", x}
      {:working_type, x} -> {"workingType", x}
      {k, v} -> {to_string(k), v}
    end)
    |> Map.new()
  end
end
