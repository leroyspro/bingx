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

  @doc """
  Alternative implementation of Kernel.put_in/3 which can put keys in depth.

  BingX.Helpers.put_in(%{}, [:a, :b, :c], 1)
  %{a: %{b: %{c: 1}}}
  """
  def put_in(data, keys, value) do
    elem(kernel_get_and_update_in(data, keys, fn _ -> {nil, value} end), 1)
  end

  defp kernel_get_and_update_in(data, [head], fun) when is_function(head, 3),
    do: head.(:get_and_update, data, fun)

  defp kernel_get_and_update_in(data, [head | tail], fun) when is_function(head, 3),
    do: head.(:get_and_update, data, &kernel_get_and_update_in(&1, tail, fun))

  defp kernel_get_and_update_in(data, [head], fun) when is_function(fun, 1),
    do: access_get_and_update(data, head, fun)

  defp kernel_get_and_update_in(data, [head | tail], fun) when is_function(fun, 1),
    do: access_get_and_update(data, head, &kernel_get_and_update_in(&1, tail, fun))

  defp access_get_and_update(map, key, fun) when is_map(map) do
    Map.get_and_update(map, key, fun)
  end

  defp access_get_and_update(nil, key, fun) do
    m = __MODULE__.put_in(%{}, [key], elem(fun.(nil), 1))
    {nil, m}
  end
end
