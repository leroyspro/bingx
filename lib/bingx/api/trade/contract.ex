defmodule BingX.API.Trade.Contract do
  alias BingX.Order

  def from_order(%Order{} = order) do
    order
    |> Map.from_struct()
    |> filter_empty()
    |> transform_values()
    |> transform_keys()
    |> Map.new()
  end

  defp filter_empty(stream) do
    Stream.reject(stream, fn {_k, v} -> is_nil(v) end)
  end

  defp transform_keys(stream) do
    Stream.map(stream, fn
      {:position_side, v} -> {"positionSide", v}
      {:client_order_id, v} -> {"clientOrderID", v}
      {:stop_price, v} -> {"stopPrice", v}
      {:working_type, v} -> {"workingType", v}
      {k, v} -> {Atom.to_string(k), v}
    end)
  end

  defp transform_values(stream) do
    Stream.map(stream, fn
      {k, v}
      when k in [:side, :type, :working_type, :position_side] ->
        {k, v |> Atom.to_string() |> String.upcase()}

      x ->
        x
    end)
  end
end
