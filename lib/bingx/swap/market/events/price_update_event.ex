defmodule BingX.Swap.Market.PriceUpdateEvent do
  import BingX.Helpers, only: [get_and_transform: 3]
  import BingX.Interpretators

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
    type = get_type(data)
    content = Map.get(data, "data") || %{}
    value = get_value(content, type)
    symbol = get_and_transform(content, "s", &interp_as_non_empty_binary/1)
    timestamp = Map.get(content, "E")

    %__MODULE__{
      type: type,
      value: value,
      symbol: symbol,
      timestamp: timestamp
    }
  end

  defp get_value(data, type) do
    case type do
      :last ->
        get_and_transform(data, "c", &interp_as_float/1)

      :mark ->
        get_and_transform(data, "p", &interp_as_float/1)

      nil ->
        nil
    end
  end

  defp get_type(data) do
    data
    |> Map.get("dataType", "")
    |> extract_type()
  end

  defp extract_type(""), do: nil

  defp extract_type(x) when is_binary(x) do
    size = byte_size(x)

    x
    |> String.slice((size - 9)..(size - 6))
    |> case do
      "last" -> :last
      "mark" -> :mark
      _ -> nil
    end
  end

  defp extract_type(_x), do: nil
end
