defmodule BingX.Swap.PlaceOrdersResponse do
  alias BingX.Swap.Trade.PlacedOrder

  @enforce_keys [:orders]
  defstruct [:orders]

  @type t() :: %__MODULE__{orders: list(%PlacedOrder{})}

  @spec new(map()) :: t()
  def new(%{"orders" => data}) do
    %__MODULE__{orders: Enum.map(data, &PlacedOrder.new/1)}
  end
end
