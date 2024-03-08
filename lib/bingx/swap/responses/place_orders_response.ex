defmodule BingX.Swap.PlaceOrdersResponse do
  alias BingX.Swap.Trade.PlacedOrder

  defstruct [:orders]

  @type t() :: %__MODULE__{orders: list(%PlacedOrder{})}

  @spec new(map()) :: map()
  def new(data) do
    data = Map.get(data, "orders", [])
    orders = Enum.map(data, &PlacedOrder.new/1)

    %__MODULE__{orders: orders}
  end
end
