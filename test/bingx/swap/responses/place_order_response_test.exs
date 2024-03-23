defmodule BingX.Swap.PlaceOrderResponseTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.PlaceOrderResponse
  alias BingX.Swap.Trade.PlacedOrder

  @fields [
    :symbol,
    :side,
    :position_side,
    :price,
    :stop_price,
    :working_type,
    :quantity,
    :type,
    :order_id,
    :client_order_id,
    :stop_loss,
    :take_profit,
    :time_in_force,
    :reduce_only?,
    :price_rate,
    :activation_price,
    :close_position?
  ]

  describe "BingX.Swap.PlaceOrderResponse new/1" do
    test "should return empty struct without params" do
      assert %PlaceOrderResponse{} = PlaceOrderResponse.new(%{})
    end

    test_module_struct(PlaceOrderResponse, @fields)

    test "should be tolerant to wrong interface" do
      assert %PlaceOrderResponse{} = PlaceOrderResponse.new(%{"x" => "x"})
    end

    test "should retrieve data and cast it into PlacedOrder struct" do
      order = %{a: "a"}

      struct = %{c: "c"}
      patch(PlacedOrder, :cast, struct)

      assert ^struct = PlaceOrderResponse.new(%{"order" => order})

      assert_called_once(PlacedOrder.cast(^order, as: PlaceOrderResponse))
    end
  end
end
