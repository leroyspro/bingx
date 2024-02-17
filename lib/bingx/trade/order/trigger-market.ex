defmodule BingX.Trade.Order.TriggerMarket do
  import BingX.Trade.Order.Helpers

  @order_type "TRIGGER_MARKET"

  @enforce_keys [:symbol, :side, :position_side, :price, :stop_price, :quantity]

  defstruct [
    :order_id,
    :symbol,
    :side,
    :position_side,
    :price,
    :stop_price,
    :quantity,
    type: @order_type
  ]

  def new(params) do
    with(
      {:ok, order_id} <- validate_param(params, :order_id),
      {:ok, symbol} <- validate_param(params, :symbol),
      {:ok, side} <- validate_param(params, :side),
      {:ok, position_side} <- validate_param(params, :position_side),
      {:ok, price} <- validate_param(params, :price),
      {:ok, stop_price} <- validate_param(params, :stop_price),
      {:ok, quantity} <- validate_param(params, :quantity)
    ) do
      %__MODULE__{
        order_id: order_id,
        symbol: symbol,
        side: side,
        position_side: position_side,
        price: price,
        stop_price: stop_price,
        quantity: quantity
      }
    end
  end

  def to_api_interface(%{
        order_id: order_id,
        symbol: symbol,
        side: side,
        position_side: position_side,
        stop_price: stop_price,
        price: price,
        quantity: quantity
      }) do
    %{
      "orderId" => order_id,
      "symbol" => symbol,
      "side" => side,
      "positionSide" => position_side,
      "stopPrice" => stop_price,
      "price" => price,
      "quantity" => quantity,
      "type" => @order_type
    }
  end

  def from_api_interface(%{
        "orderId" => order_id,
        "symbol" => symbol,
        "side" => side,
        "positionSide" => position_side,
        "stopPrice" => stop_price,
        "price" => price,
        "quantity" => quantity
      }) do
    new(%{
      order_id: order_id,
      symbol: symbol,
      side: side,
      position_side: position_side,
      stop_price: stop_price,
      price: price,
      quantity: quantity
    })
  end
end
