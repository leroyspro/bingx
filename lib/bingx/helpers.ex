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

  def get_and_transform(data, key, default \\ nil, transformer)
      when is_function(transformer, 1) do
    case Map.get(data, key, :default) do
      :default -> default
      x -> transformer.(x)
    end
  end

  def downcase(nil), do: ""
  def downcase(x), do: String.downcase(x)

  def upcase(nil), do: ""
  def upcase(x), do: String.upcase(x)
end
