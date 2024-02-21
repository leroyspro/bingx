defmodule BingX.Helpers do
  @spec timestamp() :: integer()
  def timestamp, do: :os.system_time(:millisecond)

  @spec to_float!(any()) :: float()
  def to_float!(x) do
    case Float.parse(x) do
      {float, _} -> float
      :error -> raise("Got invalid value to parse to float: #{inspect(x)}")
    end
  end
end
