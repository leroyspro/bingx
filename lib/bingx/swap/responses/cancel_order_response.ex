defmodule BingX.Swap.CancelOrderResponse do
  alias BingX.Swap.Trade.DetailedOrderInfo

  defstruct DetailedOrderInfo.fields()

  @spec new(map()) :: map()
  def new(data) do
    data = Map.get(data, "order", %{})

    DetailedOrderInfo.cast(data, as: __MODULE__)
  end
end
