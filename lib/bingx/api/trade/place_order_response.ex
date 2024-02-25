defmodule BingX.API.Trade.PlaceOrderResponse do
  import BingX.Helpers

  defstruct [
    :symbol,
    :side,
    :position_side,
    :price,
    :stop_price,
    :working_type,
    :quantity,
    :type,
    :order_id,
    :client_order_id,
    :stop_loss,
    :take_profit,
    :time_in_force,
    :reduce_only?,
    :price_rate
  ]

  @spec new(map()) :: %__MODULE__{}
  def new(data) do
    %__MODULE__{
      order_id: get_and_transform(data, "orderId", &to_string/1),
      client_order_id: Map.get(data, "clientOrderID"),
      type: Map.get(data, "type"),
      symbol: Map.get(data, "symbol"),
      side: Map.get(data, "side"),
      position_side: Map.get(data, "positionSide"),
      price: get_and_transform(data, "price", &parse_float!/1),
      stop_price: get_and_transform(data, "stopPrice", &parse_float!/1),
      working_type: Map.get(data, "workingType"),
      quantity: get_and_transform(data, "quantity", &parse_float!/1),
      stop_loss: Map.get(data, "stopLoss"),
      take_profit: Map.get(data, "takeProfit"),
      time_in_force: Map.get(data, "timeInForce"),
      reduce_only?: Map.get(data, "reduceOnly"),
      price_rate: Map.get(data, "priceRate")
    }
  end
end
