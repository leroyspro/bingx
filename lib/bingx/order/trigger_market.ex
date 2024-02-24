defmodule BingX.Order.TriggerMarket do
  alias BingX.Order
  alias __MODULE__

  @type t() :: %Order{
          :order_id => Order.order_id(),
          :side => any(),
          :position_side => Order.position_side(),
          :price => float(),
          :quantity => float(),
          :symbol => Order.symbol(),
          :stop_price => float(),
          :working_type => Order.working_type()
        }

  @spec new(%{
          :side => any(),
          :position_side => any(),
          :price => any(),
          :quantity => any(),
          :symbol => any(),
          :stop_price => any(),
          optional(:working_type) => any()
        }) :: TriggerMarket.t()
  def new(
        %{
          side: side,
          position_side: position_side,
          price: price,
          quantity: quantity,
          symbol: symbol,
          stop_price: stop_price
        } = params
      ) do
    %{
      side: side,
      position_side: position_side,
      price: price,
      quantity: quantity,
      symbol: symbol,
      stop_price: stop_price,
      working_type: Map.get(params, :working_type, :mark_price),
      type: :trigger_market
    }
    |> Order.new()
  end
end
