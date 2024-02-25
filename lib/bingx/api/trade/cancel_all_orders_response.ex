defmodule BingX.API.Trade.CancelAllOrdersResponse.Succeeded do
  import BingX.Helpers
  import BingX.API.Interpretators 

  defstruct [ 
    :order_id,
    :symbol,
    :side,
    :position_side,
    :status,
    :stop_price,
    :price,
    :type,
    :working_type,
    :leverage,
    :fee,
    :transaction_amount,
    :executed_quantity,
    :only_one_position?,
    :order_type,
    :original_quantity,
    :position_id,
    :profit,
    :reduce_only?,
    :stop_loss,
    :stop_loss_entrust_price,
    :take_profit,
    :take_profit_entrust_price,
    :timestamp,
    :update_time
  ]

  def new(data) do
    %__MODULE__{
      order_id: get_and_transform(data, "orderId", &to_internal_order_id/1),
      symbol: get_and_transform(data, "symbol", &interp_as_binary(&1, empty?: false)),
      side: get_and_transform(data, "side", &to_internal_order_side/1),
      position_side: get_and_transform(data, "positionSide", &to_internal_position_side/1),
      status: get_and_transform(data, "status", &to_internal_order_status/1),
      stop_price: get_and_transform(data, "stopPrice", &interp_as_float/1),
      price: get_and_transform(data, "price", &interp_as_float/1),
      type: get_and_transform(data, "symbol", &to_internal_order_type/1),
      working_type: get_and_transform(data, "workingType", &to_internal_working_type/1),
      leverage: get_and_transform(data, "leverage", &interp_as_float/1),
      fee: get_and_transform(data, "commission", &interp_as_float/1),
      transaction_amount: get_and_transform(data, "cumQuote", &interp_as_float/1),
      executed_quantity: get_and_transform(data, "executedQty", &interp_as_float/1),
      only_one_position?: Map.get(data, "onlyOnePosition"),
      order_type: get_and_transform(data, "orderType", &interp_as_binary(&1, empty?: false)),
      original_quantity: get_and_transform(data, "origQty", &interp_as_float/1),
      position_id: Map.get(data, "positionID"),
      profit: get_and_transform(data, "profit", &interp_as_float/1),
      reduce_only?: Map.get(data, "reduceOnly"),
      stop_loss: Map.get(data, "stopLoss"),
      stop_loss_entrust_price: get_and_transform(data, "stopLossEntrustPrice", &interp_as_float/1),
      take_profit: Map.get(data, "takeProfit"),
      take_profit_entrust_price: get_and_transform(data, "takeProfitEntrustPrice", &interp_as_float/1),
      timestamp: Map.get(data, "time"),
      update_time: Map.get(data, "updateTime")
    }
  end
end

defmodule BingX.API.Trade.CancelAllOrdersResponse.Failed do
  defstruct []

  def new(_data) do
    %__MODULE__{}
  end
end

defmodule BingX.API.Trade.CancelAllOrdersResponse do
  alias BingX.API.Trade.CancelAllOrdersResponse.{Failed, Succeeded}

  defstruct [:failed, :succeeded]

  @type t() :: %__MODULE__{
          failed: list(map()),
          succeeded: list(map())
        }

  @spec new(map()) :: t()
  def new(%{"success" => succeeded, "failed" => failed}) do
    %__MODULE__{
      succeeded: transform_succeeded(succeeded),
      failed: transform_failed(failed)
    }
  end

  def transform_succeeded(x) when is_list(x), do: Enum.map(x, &Succeeded.new/1)
  def transform_succeeded(_), do: []

  def transform_failed(x) when is_list(x), do: Enum.map(x, &Failed.new/1)
  def transform_failed(_), do: []
end
