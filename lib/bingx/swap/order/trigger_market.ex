defmodule BingX.Swap.Order.TriggerMarket do
  @moduledoc """
  This module provides functions to struct a triggered market order model using `BingX.Swap.Order`.
  """

  alias BingX.Swap.Order
  alias __MODULE__

  @type reason :: term

  @type t() :: %Order{
          :order_id => Order.order_id(),
          :side => any(),
          :position_side => Order.position_side(),
          :price => float(),
          :quantity => float(),
          :symbol => Order.symbol(),
          :stop_price => float(),
          :working_type => Order.working_type()
        }

  @spec new(%{
          :side => any(),
          :position_side => any(),
          :price => any(),
          :quantity => any(),
          :symbol => any(),
          :stop_price => any(),
          optional(:working_type) => any()
        }) :: {:ok, TriggerMarket.t()} | {:error, reason}
  def new(params) do
    params
    |> prepare()
    |> Order.new()
  end

  @spec new!(%{
          :side => any(),
          :position_side => any(),
          :price => any(),
          :quantity => any(),
          :symbol => any(),
          :stop_price => any(),
          optional(:working_type) => any()
        }) :: TriggerMarket.t()
  def new!(params) do
    params
    |> prepare()
    |> Order.new!()
  end

  defp prepare(
         %{
           side: side,
           position_side: position_side,
           price: price,
           quantity: quantity,
           symbol: symbol
         } = params
       ) do
    %{
      side: side,
      position_side: position_side,
      price: price,
      quantity: quantity,
      symbol: symbol,
      stop_price: Map.get(params, :stop_price, price),
      working_type: Map.get(params, :working_type, :mark_price),
      type: :trigger_market
    }
  end
end
