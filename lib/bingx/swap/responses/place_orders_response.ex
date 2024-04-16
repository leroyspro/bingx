defmodule BingX.Swap.PlaceOrdersResponse do
  alias BingX.Swap.Trade.OrderInfo

  defstruct [:orders]

  @type t() :: %__MODULE__{orders: list(%OrderInfo{})}

  @spec new(map()) :: t()
  def new(data) do
    data = Map.get(data, "orders", []) || []
    orders = Enum.map(data, &OrderInfo.new/1)

    %__MODULE__{orders: orders}
  end
end
