defmodule BingX.Swap.PlaceOrdersResponse do
  @moduledoc false

  alias BingX.Swap.Trade.OrderInfo

  defstruct [:orders]

  @type t() :: %__MODULE__{orders: list(OrderInfo.t())}

  @spec new(map()) :: map()
  def new(data) do
    data = Map.get(data, "orders") || []
    orders = Enum.map(data, &OrderInfo.new/1)

    %__MODULE__{orders: orders}
  end
end
