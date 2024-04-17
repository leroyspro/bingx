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
      fee: get_and_transform(data, "commission", &interp_as_abs/1),
      transaction_amount: get_and_transform(data, "cumQuote", &interp_as_float/1),
      executed_quantity: get_and_transform(data, "executedQty", &interp_as_float/1),
      only_one_position?: get_and_transform(data, "onlyOnePosition", &interp_as_boolean/1),
      order_type: get_and_transform(data, "orderType", &interp_as_non_empty_binary/1),
      original_quantity: get_and_transform(data, "origQty", &interp_as_float/1),
      average_price: get_and_transform(data, "avgPrice", &interp_as_float/1),
      position_id: get_and_transform(data, "positionID", &interp_as_non_empty_binary/1),
      profit: get_and_transform(data, "profit", &interp_as_float/1),
      reduce_only?: get_and_transform(data, "reduceOnly", &interp_as_boolean/1),
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
