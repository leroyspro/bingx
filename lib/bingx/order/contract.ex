defmodule BingX.Order.Contract do
  alias BingX.Order

  def from_order(%Order{} = order) do
    order
    |> Enum.reduce(fn
      {:order_id, x}, acc -> Map.merge(acc, %{"orderId" => x})
      {:type, x}, acc -> Map.merge(acc, %{"type" => x})
      {:symbol, x}, acc -> Map.merge(acc, %{"symbol" => x})
      {:side, x}, acc -> Map.merge(acc, %{"side" => x})
      {:position_side, x}, acc -> Map.merge(acc, %{"positionSide" => x})
      {:stop_price, x}, acc -> Map.merge(acc, %{"stopPrice" => x})
      {:price, x}, acc -> Map.merge(acc, %{"price" => x})
      {:quantity, x}, acc -> Map.merge(acc, %{"quantity" => x})
      {_key, _value}, acc -> acc
    end)
  end
end
