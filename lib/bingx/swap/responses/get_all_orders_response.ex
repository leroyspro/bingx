defmodule BingX.Swap.GetAllOrdersResponse do
  alias BingX.Swap.Trade.DetailedOrderInfo

  defstruct [:orders]

  @type t() :: %__MODULE__{
          orders: list(DetailedOrderInfo.t())
        }

  @spec new(map()) :: t()
  def new(data) do
    orders = Map.get(data, "orders") || []

    %__MODULE__{
      orders: Enum.map(orders, &DetailedOrderInfo.new/1)
    }
  end
end
