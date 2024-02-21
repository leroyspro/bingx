defmodule BingX.Order do
  alias __MODULE__

  defstruct [
    :symbol,
    :side,
    :position_side,
    :price,
    :quantity,
    :type,
    :stop_price,
    :order_id,
    :client_order_id,
    :stop_loss,
    :take_profit,
    :working_type
  ]

  @spec new(map()) :: %Order{}
  def new(params) when is_map(params), do: struct(Order, params)

  @spec symbol(:btc_usdt) :: binary()
  def symbol(:btc_usdt), do: "BTC-USDT"

  @spec side(:buy | :sell) :: binary()
  def side(:buy), do: "BUY"
  def side(:sell), do: "SELL"

  @spec position_side(:both | :long | :short) :: binary()
  def position_side(:long), do: "LONG"
  def position_side(:short), do: "SHORT"
  def position_side(:both), do: "BOTH"

  @spec type(:trigger_market) :: binary()
  def type(:trigger_market), do: "TRIGGER_MARKET"
end
