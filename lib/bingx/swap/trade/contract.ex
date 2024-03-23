defmodule BingX.Swap.Trade.Contract do
  @moduledoc """
  This module is used to transform internal order structs into external order contracts.
  """

  alias BingX.Swap.Order
  alias BingX.Swap.Interpretators

  def from_order(%Order{} = order) do
    order
    |> Map.from_struct()
    |> omit_empty_values()
    |> transform_values()
    |> transform_keys()
    |> Map.new()
  end

  defp omit_empty_values(stream) do
    Stream.reject(stream, fn {_k, v} -> is_nil(v) end)
  end

  defp transform_values(stream) do
    Stream.map(stream, fn
      {:side, v} -> {:side, Interpretators.to_external_order_side(v)}
      {:type, v} -> {:type, Interpretators.to_external_order_type(v)}
      {:position_side, v} -> {:position_side, Interpretators.to_external_position_side(v)}
      {:working_type, v} -> {:working_type, Interpretators.to_external_working_type(v)}
      x -> x
    end)
  end

  defp transform_keys(stream) do
    Stream.map(stream, fn
      {:position_side, v} -> {"positionSide", v}
      {:client_order_id, v} -> {"clientOrderID", v}
      {:order_id, v} -> {"orderId", v}
      {:stop_price, v} -> {"stopPrice", v}
      {:working_type, v} -> {"workingType", v}
      {k, v} -> {Atom.to_string(k), v}
    end)
  end
end
