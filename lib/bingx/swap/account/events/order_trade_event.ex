defmodule BingX.Swap.Account.OrderTradeEvent do
  import BingX.Helpers
  import BingX.Swap.Interpretators

  defstruct [
    :symbol,
    :status,
    :order_id,
    :client_order_id,
    :trigger_order_id,
    :side,
    :position_side,
    :type,
    :execution_type,
    :quantity,
    :price,
    :trigger_price,
    :actual_price,
    :fee,
    :fee_asset,
    :working_type,
    :accumulated_quantity,
    :timestamp
  ]

  @type t :: %__MODULE__{
          symbol: binary() | nil,
          status: :placed | :triggered | :filled | :partially_filled | :canceled | :expired | nil,
          order_id: binary() | nil,
          client_order_id: binary() | nil,
          trigger_order_id: binary() | nil,
          side: :buy | :sell | nil,
          position_side: :long | :short | nil,
          type: :market | :trigger_market | :stop_loss | :take_profit | :limit | :stop_loss_market | :take_profit_market | nil,
          execution_type: :placed | :canceled | :calculated | :expired | :trade | nil,
          quantity: float() | nil,
          price: float() | nil,
          trigger_price: float() | nil,
          actual_price: float() | nil,
          fee: float() | nil,
          fee_asset: binary() | nil,
          working_type: :index_price | :mark_price | :contract_price | nil,
          accumulated_quantity: float() | nil,
          timestamp: integer()
        }

  @spec new(map()) :: t()
  def new(data) do
    order = Map.get(data, "o", %{})

    %__MODULE__{
      symbol: get_and_transform(order, "s", &interp_as_non_empty_binary/1),
      status: get_and_transform(order, "X", &to_internal_order_status/1),
      order_id: get_and_transform(order, "i", &interp_as_non_empty_binary/1),
      client_order_id: get_and_transform(order, "c", &interp_as_non_empty_binary/1),
      trigger_order_id: get_and_transform(order, "ti", &interp_as_non_empty_binary/1),
      side: get_and_transform(order, "S", &to_internal_order_side/1),
      position_side: get_and_transform(order, "ps", &to_internal_position_side/1),
      type: get_and_transform(order, "o", &to_internal_order_type/1),
      execution_type: get_and_transform(order, "x", &to_internal_order_execution_type/1),
      quantity: get_and_transform(order, "q", &interp_as_float/1),
      price: get_and_transform(order, "p", &interp_as_float/1),
      trigger_price: get_and_transform(order, "sp", &interp_as_float/1),
      actual_price: get_and_transform(order, "ap", &interp_as_float/1),
      fee: get_and_transform(order, "n", &interp_as_abs/1),
      fee_asset: get_and_transform(order, "N", &interp_as_non_empty_binary/1),
      # guaranteed_sl_tp: get_and_transform(order, "sg", &interp_as_boolean/1),
      working_type: get_and_transform(order, "wt", &to_internal_working_type/1),
      accumulated_quantity: get_and_transform(order, "z", &interp_as_float/1),
      timestamp: Map.get(data, "E")
    }
  end
end
