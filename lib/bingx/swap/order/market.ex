defmodule BingX.Swap.Order.Market do
  @moduledoc """
  This module provides functions to struct a triggered market order model using `BingX.Swap.Order`.
  """

  @type reason :: term

  alias BingX.Swap.Order
  alias __MODULE__

  @type t() :: %Order{
          :order_id => Order.order_id(),
          :side => any(),
          :position_side => Order.position_side(),
          :quantity => float(),
          :symbol => Order.symbol()
        }

  @spec new(%{
          :side => any(),
          :position_side => any(),
          :quantity => any(),
          :symbol => any()
        }) :: {:ok, Market.t()} | {:error, reason}
  def new(params) do
    params
    |> prepare()
    |> Order.new()
  end

  @spec new!(%{
          :side => any(),
          :position_side => any(),
          :quantity => any(),
          :symbol => any()
        }) :: Market.t()
  def new!(params) do
    params
    |> prepare()
    |> Order.new!()
  end

  defp prepare(%{
        side: side,
        position_side: position_side,
        quantity: quantity,
        symbol: symbol
      }) do
    %{
      side: side,
      position_side: position_side,
      quantity: quantity,
      symbol: symbol,
      type: :market
    }
  end
end
