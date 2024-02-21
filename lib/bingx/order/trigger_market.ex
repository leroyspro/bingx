defmodule BingX.Order.TriggerMarket do
  alias BingX.Order
  alias __MODULE__

  @type t() :: %Order{
          :order_id => any(),
          :position_side => any(),
          :price => any(),
          :quantity => any(),
          :side => any(),
          :symbol => any(),
          :stop_price => any(),
          :working_type => any()
        }

  @spec new(%{
          :position_side => any(),
          :price => any(),
          :quantity => any(),
          :side => any(),
          :symbol => any(),
          :stop_price => any(),
          :working_type => any()
        }) :: TriggerMarket.t()
  def new(
        %{
          position_side: _,
          price: _,
          quantity: _,
          side: _,
          symbol: _,
          stop_price: _
        } = params
      ) do
    params
    |> Map.merge(%{type: Order.type(:trigger_market)})
    |> Order.new()
  end
end
