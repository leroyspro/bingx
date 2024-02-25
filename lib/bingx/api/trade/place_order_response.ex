defmodule BingX.API.Trade.PlaceOrderResponse do
  import BingX.Helpers
  import BingX.API.Interpretators

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
      order_id: get_and_transform(data, "orderId", &interp_order_id/1),
      client_order_id: get_and_transform(data, "clientOrderID", &to_string/1),
      type: get_and_transform(data, "type", &interp_order_type/1),
      symbol: Map.get(data, "symbol"),
      side: get_and_transform(data, "side", &interp_order_side/1),
      position_side: get_and_transform(data, "positionSide", &interp_position_side/1),
      price: get_and_transform(data, "price", &interp_as_float/1),
      stop_price: get_and_transform(data, "stopPrice", &interp_as_float/1),
      working_type: Map.get(data, "workingType"),
      quantity: get_and_transform(data, "quantity", &interp_as_float/1),
      stop_loss: Map.get(data, "stopLoss"),
      take_profit: Map.get(data, "takeProfit"),
      time_in_force: Map.get(data, "timeInForce"),
      reduce_only?: Map.get(data, "reduceOnly"),
      price_rate: Map.get(data, "priceRate")
    }
  end
end
