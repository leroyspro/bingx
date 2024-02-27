defmodule BingX.API.Trade.CancelOrderResponse do
  alias BingX.API.Trade.CanceledOrder

  defstruct CanceledOrder.fields()

  @spec new(map()) :: map()
  def new(data), do: CanceledOrder.cast(data, as: __MODULE__)
end
