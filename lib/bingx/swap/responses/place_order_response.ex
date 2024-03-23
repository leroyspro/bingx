defmodule BingX.Swap.PlaceOrderResponse do
  @moduledoc false

  alias BingX.Swap.Trade.OrderInfo

  defstruct OrderInfo.fields()

  @spec new(map()) :: map()
  def new(data) do
    data = Map.get(data, "order") || %{}

    OrderInfo.cast(data, as: __MODULE__)
  end
end
