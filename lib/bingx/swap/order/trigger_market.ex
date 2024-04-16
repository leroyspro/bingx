defmodule BingX.Swap.Order.TriggerMarket do
  alias BingX.Swap.Order

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

  @type params() :: %{
          :side => any(),
          :position_side => any(),
          :price => any(),
          :quantity => any(),
          :symbol => any(),
          optional(:stop_price) => any(),
          optional(:working_type) => any()
        }

  @spec new(params()) :: {:ok, t()} | {:error, any()}
  def new(
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
