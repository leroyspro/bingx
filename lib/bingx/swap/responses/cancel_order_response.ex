defmodule BingX.Swap.CancelOrderResponse do
  alias BingX.Swap.Trade.CanceledOrder

  defstruct CanceledOrder.fields()

  @spec new(map()) :: struct()
  def new(data) do
    data = Map.get(data, "order", %{})

    CanceledOrder.cast(data, as: __MODULE__)
  end
end
