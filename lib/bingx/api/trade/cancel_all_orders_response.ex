defmodule BingX.API.Trade.CancelAllOrdersResponse.Succeeded do
  import BingX.Helpers

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
      order_id: get_and_transform(data, "orderId", &to_string/1),
      symbol: Map.get(data, "symbol"),
      side: Map.get(data, "side"),
      position_side: Map.get(data, "positionSide"),
      status: Map.get(data, "status"),
      stop_price: get_and_transform(data, "stopPrice", &parse_float!/1),
      price: get_and_transform(data, "price", &parse_float!/1),
      type: Map.get(data, "type"),
      working_type: Map.get(data, "workingType"),
      leverage: get_and_transform(data, "leverage", &parse_float!/1),
      fee: get_and_transform(data, "commission", &parse_float!/1),
      transaction_amount: get_and_transform(data, "cumQuote", &parse_float!/1),
      executed_quantity: get_and_transform(data, "executedQty", &parse_float!/1),
      only_one_position?: Map.get(data, "onlyOnePosition"),
      order_type: Map.get(data, "orderType"),
      original_quantity: Map.get(data, "origQty"),
      position_id: Map.get(data, "positionID"),
      profit: Map.get(data, "profit"),
      reduce_only?: Map.get(data, "reduceOnly"),
      stop_loss: Map.get(data, "stopLoss"),
      stop_loss_entrust_price: get_and_transform(data, "stopLossEntrustPrice", &parse_float!/1),
      take_profit_entrust_price:
        get_and_transform(data, "takeProfitEntrustPrice", &parse_float!/1),
      timestamp: Map.get(data, "time"),
      update_time: Map.get(data, "updateTime")
    }
  end
end

defmodule BingX.API.Trade.CancelAllOrdersResponse.Failed do
  import BingX.Helpers

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
      order_id: get_and_transform(data, "orderId", &to_string/1),
      symbol: Map.get(data, "symbol"),
      side: Map.get(data, "side"),
      position_side: Map.get(data, "positionSide"),
      status: Map.get(data, "status"),
      stop_price: get_and_transform(data, "stopPrice", &parse_float!/1),
      price: get_and_transform(data, "price", &parse_float!/1),
      type: Map.get(data, "type"),
      working_type: Map.get(data, "workingType"),
      leverage: get_and_transform(data, "leverage", &parse_float!/1),
      fee: get_and_transform(data, "commission", &parse_float!/1),
      transaction_amount: get_and_transform(data, "cumQuote", &parse_float!/1),
      executed_quantity: get_and_transform(data, "executedQty", &parse_float!/1),
      only_one_position?: Map.get(data, "onlyOnePosition"),
      order_type: Map.get(data, "orderType"),
      original_quantity: Map.get(data, "origQty"),
      position_id: Map.get(data, "positionID"),
      profit: Map.get(data, "profit"),
      reduce_only?: Map.get(data, "reduceOnly"),
      stop_loss: Map.get(data, "stopLoss"),
      stop_loss_entrust_price: get_and_transform(data, "stopLossEntrustPrice", &parse_float!/1),
      take_profit_entrust_price:
        get_and_transform(data, "takeProfitEntrustPrice", &parse_float!/1),
      timestamp: Map.get(data, "time"),
      update_time: Map.get(data, "updateTime")
    }
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
    # %__MODULE__{
    #   succeeded: transform_succeeded(succeeded),
    #   failed: transform_failed(failed)
    # }
    %__MODULE__{
      succeeded: succeeded,
      failed: failed
    }
  end

  def transform_succeeded(x) when is_list(x), do: Enum.map(x, &Succeeded.new/1)
  def transform_succeeded(_), do: []

  def transform_failed(x) when is_list(x), do: Enum.map(x, &Failed.new/1)
  def transform_failed(_), do: []
end
