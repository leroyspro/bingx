defmodule BingX.Swap.GetOrderResponse do
  alias BingX.Swap.Trade.DetailedOrderInfo

  @fields DetailedOrderInfo.fields()

  defstruct @fields

  @spec new(map()) :: map()
  def new(data) do
    info = Map.get(data, "order") || %{}
    DetailedOrderInfo.cast(info, as: __MODULE__)
  end
end
