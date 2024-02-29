defmodule BingX.Swap.Trade.PlaceOrderResponse do
  alias BingX.Swap.Trade.PlacedOrder

  defstruct PlacedOrder.fields()

  @spec new(map()) :: %__MODULE__{}
  def new(%{"order" => data}), do: PlacedOrder.cast(data, as: __MODULE__)
end
