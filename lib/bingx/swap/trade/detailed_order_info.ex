defmodule BingX.Swap.Trade.DetailedOrderInfo do
  import BingX.Helpers
  import BingX.Swap.Interpretators

  @fields [
    :order_id,
    :symbol,
    :side,
    :position_side,
    :status,
    :stop_price,
    :price,
    :type,
    :client_order_id,
    :trigger_order_id,
    :working_type,
    :leverage,
    :fee,
    :transaction_amount,
    :executed_quantity,
    :only_one_position?,
    :order_type,
    :original_quantity,
    :average_price,
    :position_id,
    :profit,
    :reduce_only?,
    :stop_loss,
    :stop_loss_entrust_price,
    :take_profit,
    :take_profit_entrust_price,
    :stop_guaranteed?,
    :timestamp,
    :update_time
  ]

  defstruct @fields

  @type t() :: %__MODULE__{
          :symbol => binary() | nil,
          :side => BingX.Swap.Order.side() | nil,
          :position_side => BingX.Swap.Order.position_side() | nil,
          :price => float() | nil,
          :stop_price => float() | nil,
          :working_type => BingX.Swap.Order.working_type() | nil,
          :type => BingX.Swap.Order.type() | nil,
          :order_id => binary() | nil,
          :client_order_id => binary() | nil,
          :stop_loss => term(),
          :take_profit => term(),
          :reduce_only? => boolean() | nil,
          :stop_guaranteed? => boolean() | nil,
          :status => BingX.Swap.Order.status() | nil,
          :trigger_order_id => binary() | nil,
          :leverage => integer() | nil,
          :fee => float() | nil,
          :transaction_amount => float() | nil,
          :executed_quantity => float() | nil,
          :only_one_position? => boolean() | nil,
          :order_type => term(),
          :original_quantity => float() | nil,
          :average_price => float() | nil,
          :position_id => binary() | nil,
          :profit => float() | nil,
          :reduce_only? => boolean() | nil,
          :stop_loss => term(),
          :stop_loss_entrust_price => float() | nil,
          :take_profit => term(),
          :take_profit_entrust_price => float() | nil,
          :stop_guaranteed? => boolean() | nil,
          :timestamp => term(),
          :update_time => term()
        }

  def fields, do: @fields

  def cast(data, as: module) do
    params = %{
      order_id: get_and_transform(data, "orderId", &interp_as_non_empty_binary/1),
      symbol: get_and_transform(data, "symbol", &interp_as_non_empty_binary/1),
      side: get_and_transform(data, "side", &to_internal_order_side/1),
      position_side: get_and_transform(data, "positionSide", &to_internal_position_side/1),
      status: get_and_transform(data, "status", &to_internal_order_status/1),
      stop_price: get_and_transform(data, "stopPrice", &interp_as_float/1),
      price: get_and_transform(data, "price", &interp_as_float/1),
      type: get_and_transform(data, "type", &to_internal_order_type/1),
      client_order_id: get_and_transform(data, "clientOrderId", &interp_as_non_empty_binary/1),
      trigger_order_id: get_and_transform(data, "triggerOrderId", &interp_as_non_empty_binary/1),
      working_type: get_and_transform(data, "workingType", &to_internal_working_type/1),
      leverage: get_and_transform(data, "leverage", &interp_as_float/1),
      fee: get_and_transform(data, "commission", &interp_as_float/1),
      transaction_amount: get_and_transform(data, "cumQuote", &interp_as_float/1),
      executed_quantity: get_and_transform(data, "executedQty", &interp_as_float/1),
      only_one_position?: get_and_transform(data, "onlyOnePosition", &interp_as_boolean/1),
      original_quantity: get_and_transform(data, "origQty", &interp_as_float/1),
      average_price: get_and_transform(data, "avgPrice", &interp_as_float/1),
      position_id: get_and_transform(data, "positionID", &interp_as_non_empty_binary/1),
      profit: get_and_transform(data, "profit", &interp_as_float/1),
      reduce_only?: get_and_transform(data, "reduceOnly", &interp_as_boolean/1),
      order_type: Map.get(data, "orderType"),
      stop_loss: Map.get(data, "stopLoss"),
      stop_loss_entrust_price: get_and_transform(data, "stopLossEntrustPrice", &interp_as_float/1),
      take_profit: Map.get(data, "takeProfit"),
      take_profit_entrust_price: get_and_transform(data, "takeProfitEntrustPrice", &interp_as_float/1),
      stop_guaranteed?: get_and_transform(data, "stopGuaranteed", &interp_as_boolean/1),
      timestamp: Map.get(data, "time"),
      update_time: Map.get(data, "updateTime")
    }

    struct(module, params)
  end

  def new(data), do: cast(data, as: __MODULE__)
end
