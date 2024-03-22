defmodule BingX.Swap.PendingOrdersResponse do
  alias BingX.Swap.Trade.DetailedOrderInfo

  defstruct [:orders]

  @type t() :: %__MODULE__{orders: list(%DetailedOrderInfo{})}

  @spec new(map()) :: map()
  def new(data) do
    data = Map.get(data, "orders", [])
    orders = Enum.map(data, &DetailedOrderInfo.new/1)

    %__MODULE__{orders: orders}
  end
end
