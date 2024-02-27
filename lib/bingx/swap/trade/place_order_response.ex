defmodule BingX.Swap.Trade.PlaceOrderResponse do
  import BingX.Helpers
  import BingX.Swap.Interpretators

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
      order_id: get_and_transform(data, "orderId", &interp_as_binary(&1, empty?: false)),
      client_order_id: get_and_transform(data, "clientOrderID", &interp_as_binary(&1, empty?: false)),
      type: get_and_transform(data, "type", &to_internal_order_type/1),
      symbol: get_and_transform(data, "symbol", &interp_as_binary(&1, empty?: false)),
      side: get_and_transform(data, "side", &to_internal_order_side/1),
      position_side: get_and_transform(data, "positionSide", &to_internal_position_side/1),
      price: get_and_transform(data, "price", &interp_as_float/1),
      stop_price: get_and_transform(data, "stopPrice", &interp_as_float/1),
      working_type: get_and_transform(data, "workingType", &to_internal_working_type/1),
      quantity: get_and_transform(data, "quantity", &interp_as_float/1),
      stop_loss: Map.get(data, "stopLoss"),
      take_profit: Map.get(data, "takeProfit"),
      time_in_force: Map.get(data, "timeInForce"),
      reduce_only?: Map.get(data, "reduceOnly"),
      price_rate: get_and_transform(data, "priceRate", &interp_as_float/1)
    }
  end
end
