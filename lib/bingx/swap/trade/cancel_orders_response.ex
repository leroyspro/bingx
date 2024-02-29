defmodule BingX.Swap.Trade.CancelOrdersResponse do
  alias BingX.Swap.Trade.CanceledOrder

  defstruct [:failed, :succeeded]

  @type t() :: %__MODULE__{
          failed: list(map()),
          succeeded: list(map())
        }

  @spec new(map()) :: t()
  def new(%{"success" => succeeded, "failed" => failed}) do
    %__MODULE__{
      succeeded: transform_succeeded(succeeded),
      failed: failed
    }
  end

  def transform_succeeded(x) when is_list(x), do: Enum.map(x, &CanceledOrder.new/1)
  def transform_succeeded(_), do: []
end
