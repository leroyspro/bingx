defmodule BingX.Helpers do
  @moduledoc """
  This module provides global scope helper functions used in the library.
  """
  
  @spec timestamp() :: integer()
  def timestamp, do: :os.system_time(:millisecond)

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

  def to_string(x) when is_list(x) do
    content =
      x
      |> Enum.map(&__MODULE__.to_string/1)
      |> Enum.join(",")

    "[" <> content <> "]"
  end

  def to_string(x) when is_map(x), do: Jason.encode!(x)

  defdelegate to_string(x), to: Kernel, as: :to_string
end
