defmodule BingX.Trade.Order do
  alias __MODULE__.TriggerMarket

  @callback to_json(params :: map()) :: binary()

  def symbol(:btc_usdt), do: "BTC-USDT"

  def side(:buy), do: "BUY"
  def side(:sell), do: "SELL"

  def position_side(:long), do: "LONG"
  def position_side(:short), do: "SHORT"

  def to_api_interface(%TriggerMarket{} = order) do
    {:ok, TriggerMarket.to_api_interface(order)}
  end

  def to_api_interface(_order) do
    {:error, "unsupported order structure"}
  end
end
