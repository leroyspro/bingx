defmodule BingX.API.Trade.PlaceOrderResponse do
  import BingX.Helpers

  alias BingX.Order

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

  @type t() :: %__MODULE__{
          :order_id => Order.order_id(),
          :symbol => Order.symbol(),
          :side => Order.side(),
          :position_side => Order.position_side(),
          :price => Order.price(),
          :stop_price => Order.stop_price(),
          :working_type => Order.working_type(),
          :quantity => Order.quantity(),
          :type => Order.type(),
          :client_order_id => Order.client_order_id(),
          :stop_loss => any(),
          :take_profit => any(),
          :time_in_force => binary(),
          :reduce_only? => boolean(),
          :price_rate => float()
        }

  @spec new(map()) :: BalanceResponse.t()
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

  @spec to_order(t()) :: BingX.Order.t()
  def to_order(contract), do: Order.new(contract)
end
