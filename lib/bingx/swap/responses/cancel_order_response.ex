defmodule BingX.Swap.CancelOrderResponse do
  alias BingX.Swap.Trade.CanceledOrder

  defstruct CanceledOrder.fields()

  @spec new(map()) :: map()
  def new(%{"order" => data}), do: CanceledOrder.cast(data, as: __MODULE__)
end
