defmodule BingX.Order do
  alias __MODULE__

  @enforce_keys [
    :symbol,
    :side,
    :position_side,
    :price,
    :quantity,
    :type
  ]

  @type t() :: %__MODULE__{
          :order_id => any(),
          :client_order_id => any(),
          :symbol => any(),
          :side => any(),
          :position_side => any(),
          :price => any(),
          :quantity => any(),
          :stop_price => any(),
          :type => any()
        }

  defstruct [
    :symbol,
    :side,
    :position_side,
    :price,
    :quantity,
    :type,
    stop_price: nil,
    order_id: nil,
    client_order_id: nil
  ]

  @spec new(%{
          :order_id => any(),
          :symbol => any(),
          :side => any(),
          :position_side => any(),
          :price => any(),
          :quantity => any(),
          :type => any()
        }) :: __MODULE__.t()
  def new(params) when is_map(params), do: struct(Order, params)

  def symbol(:btc_usdt), do: "BTC-USDT"

  def side(:buy), do: "BUY"
  def side(:sell), do: "SELL"

  def position_side(:long), do: "LONG"
  def position_side(:short), do: "SHORT"
  def position_side(:both), do: "BOTH"
end
