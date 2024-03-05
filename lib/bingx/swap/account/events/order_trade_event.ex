defmodule BingX.Swap.Account.OrderTradeEvent do
  import BingX.Helpers
  import BingX.Swap.Interpretators

  defstruct [
    :timestamp,
    :asset,
    :status,
    :symbol,
    :client_order_id,
    :order_id,
    :side,
    :type,
    :execution_type,
    :quantity,
    :price,
    :trigger_price,
    :actual_price,
    :accumulated_quantity
  ]

  def new(%{"E" => timestamp, "o" => data}) do
    %__MODULE__{
      timestamp: timestamp,
      symbol: get_and_transform(data, "s", &interp_as_binary/1),
      asset: get_and_transform(data, "N", &interp_as_binary/1),
      status: get_and_transform(data, "X", &to_internal_order_status/1),
      client_order_id: get_and_transform(data, "c", &interp_as_binary/1),
      order_id: Map.get(data, "i"),
      side: get_and_transform(data, "S", &to_internal_order_side/1),
      type: get_and_transform(data, "o", &to_internal_order_type/1),
      execution_type: get_and_transform(data, "x", &to_internal_order_execution_type/1),
      quantity: get_and_transform(data, "q", &interp_as_float/1),
      price: get_and_transform(data, "p", &interp_as_float/1),
      trigger_price: get_and_transform(data, "sp", &interp_as_float/1),
      actual_price: get_and_transform(data, "ap", &interp_as_float/1),
      accumulated_quantity: get_and_transform(data, "z", &interp_as_float/1)
    }
  end
end
