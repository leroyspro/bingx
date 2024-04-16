defmodule BingX.Swap.Order.Market do
  alias BingX.Swap.Order
  alias __MODULE__

  @type t() :: %Order{
          :order_id => Order.order_id(),
          :side => any(),
          :position_side => Order.position_side(),
          :quantity => float(),
          :symbol => Order.symbol()
        }

  @type params() :: %{
          :side => any(),
          :position_side => any(),
          :quantity => any(),
          :symbol => any()
        }

  @spec new(params()) :: {:ok, Market.t()} | {:error, any()}
  def new(%{
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
    |> Order.new()
  end

  @spec new(params()) :: t() | no_return()
  def new!(params) do
    case new(params) do
      {:ok, order} -> order
      {:error, reason} -> raise ArgumentError, reason
    end
  end
end
