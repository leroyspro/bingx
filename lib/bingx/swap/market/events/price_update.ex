defmodule BingX.Swap.Market.Events.PriceUpdate do
  import BingX.Helpers, only: [get_and_transform: 3, downcase: 1]
  import BingX.Swap.Interpretators

  defstruct [
    :type,
    :value,
    :symbol,
    :timestamp
  ]

  def new(%{"dataType" => dataType, "data" => data}) do
    %__MODULE__{
      type: extract_event_type(dataType),
      value: get_and_transform(data, "c", &interp_as_float/1),
      timestamp: Map.get(data, "E"),
      symbol: get_and_transform(data, "s", &interp_as_binary/1),
    }
  end

  defp extract_event_type(x) when is_binary(x) do
    x
    |> String.slice((byte_size(x) - 9)..(byte_size(x) - 6))
    |> downcase()
    |> case do
      "last" -> :last
      "mark" -> :mark
      type -> type
    end
  end

  defp extract_event_type(_x), do: nil
end
