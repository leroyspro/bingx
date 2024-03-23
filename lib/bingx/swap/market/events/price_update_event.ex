defmodule BingX.Swap.Market.PriceUpdateEvent do
  @moduledoc false

  import BingX.Helpers, only: [get_and_transform: 3]
  import BingX.Swap.Interpretators

  @type t :: %__MODULE__{
          :type => :last | :mark | nil,
          :value => float | nil,
          :symbol => binary | nil,
          :timestamp => integer | nil
        }

  defstruct [
    :type,
    :value,
    :symbol,
    :timestamp
  ]

  def new(data) when is_map(data) do
    type = Map.get(data, "dataType", "")
    data = Map.get(data, "data") || %{}

    %__MODULE__{
      type: extract_event_type(type),
      value: get_and_transform(data, "p", &interp_as_float/1),
      symbol: get_and_transform(data, "s", &interp_as_non_empty_binary/1),
      timestamp: Map.get(data, "E")
    }
  end

  defp extract_event_type(""), do: nil

  defp extract_event_type(x) when is_binary(x) do
    size = byte_size(x)

    x
    |> String.slice((size - 9)..(size - 6))
    |> case do
      "last" -> :last
      "mark" -> :mark
      _ -> nil
    end
  end

  defp extract_event_type(_x), do: nil
end
