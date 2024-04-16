defmodule BingX.Swap.PlaceOrderResponse do
  alias BingX.Swap.Trade.OrderInfo

  defstruct OrderInfo.fields()

  @spec new(map()) :: struct()
  def new(data) do
    order = Map.get(data, "order") || %{}

    OrderInfo.cast(order, as: __MODULE__)
  end
end
