defmodule BingX.Helpers do
  @spec timestamp() :: integer()
  def timestamp, do: :os.system_time(:millisecond)

  @spec to_float!(any()) :: float()
  def to_float!(x) when is_binary(x) do
    case Float.parse(x) do
      {float, _} -> float
      :error -> raise("Got invalid value to parse to float: #{inspect(x)}")
    end
  end

  def to_float!(x) when is_number(x), do: x + 0.0

  @spec parse_float!(any()) :: float() | nil
  def parse_float!(x) when is_number(x), do: to_float!(x)
  def parse_float!(x) when is_binary(x) and byte_size(x) > 0, do: to_float!(x)
  def parse_float!(_), do: nil

  def get_and_transform(data, key, default \\ nil, transformer)
      when is_function(transformer, 1) do
    case Map.get(data, key, :default) do
      :default -> default
      x -> transformer.(x)
    end
  end
end
