defmodule BingX.Swap.CancelAllOrdersResponse do
  alias BingX.Swap.Trade.DetailedOrderInfo

  defstruct [:failed, :succeeded]

  @type t() :: %__MODULE__{
          failed: list(map()),
          succeeded: list(map())
        }

  @spec new(map()) :: t()
  def new(data) do
    succeeded = Map.get(data, "success") || []
    failed = Map.get(data, "failed") || []

    %__MODULE__{
      succeeded: transform_succeeded(succeeded),
      failed: failed
    }
  end

  def transform_succeeded(x) when is_list(x), do: Enum.map(x, &DetailedOrderInfo.new/1)
  def transform_succeeded(_), do: []
end
