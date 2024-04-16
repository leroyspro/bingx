defmodule BingX.Swap.CancelOrderResponse do
  alias BingX.Swap.Trade.DetailedOrderInfo

  defstruct DetailedOrderInfo.fields()

  @spec new(map()) :: struct()
  def new(data) do
    order = Map.get(data, "order") || %{}

    DetailedOrderInfo.cast(order, as: __MODULE__)
  end
end
