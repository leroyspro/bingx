defmodule BingX.Swap.CloseAllPositionsResponse do
  defstruct [:failed, :succeeded]

  @type t() :: %__MODULE__{
          failed: list(integer()),
          succeeded: list(integer())
        }

  @spec new(map()) :: t()
  def new(data) do
    succeeded = Map.get(data, "success", [])
    failed = Map.get(data, "failed", [])

    %__MODULE__{
      succeeded: succeeded || [] |> Enum.map(&to_string/1),
      failed: failed || []
    }
  end
end
