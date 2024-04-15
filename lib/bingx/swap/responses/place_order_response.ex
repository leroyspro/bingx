defmodule BingX.Swap.PlaceOrderResponse do
  alias BingX.Swap.Trade.PlacedOrder

  defstruct PlacedOrder.fields()

  @spec new(map()) :: struct()
  def new(data) do
    data = Map.get(data, "order", %{})

    PlacedOrder.cast(data, as: __MODULE__)
  end
end
