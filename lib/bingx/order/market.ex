defmodule BingX.Order.Market do
  alias BingX.Order
  alias __MODULE__

  @type t() :: %Order{
          :order_id => Order.order_id(),
          :side => any(),
          :position_side => Order.position_side(),
          :quantity => float(),
          :symbol => Order.symbol()
        }

  @spec new(%{
          :side => any(),
          :position_side => any(),
          :quantity => any(),
          :symbol => any()
        }) :: Market.t()
  def new(%{
        side: side,
        position_side: position_side,
        quantity: quantity,
        symbol: symbol
      }) do
    %{
      side: side,
      position_side: position_side,
      quantity: quantity,
      symbol: symbol,
      type: :market
    }
    |> Order.new()
  end
end
