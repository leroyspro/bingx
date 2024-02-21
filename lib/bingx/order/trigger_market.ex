defmodule BingX.Order.TriggerMarket do
  alias BingX.Order

  @order_type "TRIGGER_MARKET"
  @type t() :: %Order{
          :order_id => any(),
          :position_side => any(),
          :price => any(),
          :quantity => any(),
          :side => any(),
          :stop_price => any(),
          :symbol => any()
        }

  def new(params) do
    params
    |> Map.merge(%{type: @order_type})
    |> Order.new()
  end
end
