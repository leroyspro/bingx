defmodule BingX.Swap.Market.PriceUpdateEvent do
  import BingX.Helpers, only: [get_and_transform: 3, downcase: 1]
  import BingX.Swap.Interpretators

  defstruct [
    :type,
    :value,
    :symbol,
    :timestamp
  ]

  def new(data) do
    type = Map.get(data, "dataType", "")
    data = Map.get(data, "data", %{})

    %__MODULE__{
      type: extract_event_type(type),
      value: get_and_transform(data, "c", &interp_as_float/1),
      symbol: get_and_transform(data, "s", &interp_as_non_empty_binary/1),
      timestamp: Map.get(data, "E"),
    }
  end

  defp extract_event_type(""), do: nil

  defp extract_event_type(x) when is_binary(x) do
    x
    |> String.slice((byte_size(x) - 9)..(byte_size(x) - 6))
    |> downcase()
    |> case do
      "last" -> :last
      "mark" -> :mark
      _ -> nil
    end
  end

  defp extract_event_type(_x), do: nil
end
