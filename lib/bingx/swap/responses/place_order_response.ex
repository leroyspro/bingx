defmodule BingX.Swap.PlaceOrderResponse do
  @moduledoc false

  alias BingX.Swap.Trade.PlacedOrder

  defstruct PlacedOrder.fields()

  @spec new(map()) :: map()
  def new(data) do
    data = Map.get(data, "order", %{})

    PlacedOrder.cast(data, as: __MODULE__)
  end
end
