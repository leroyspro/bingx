defmodule BingX.Swap.PlaceOrdersResponseTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.PlaceOrdersResponse
  alias BingX.Swap.Trade.OrderInfo

  @fields [:orders]

  describe "BingX.Swap.PlaceOrdersResponse new/1" do
    test "should return empty struct without params" do
      assert %PlaceOrdersResponse{} = PlaceOrdersResponse.new(%{})
    end

    test_module_struct(PlaceOrdersResponse, @fields)

    test "should be tolerant to wrong interface" do
      assert %PlaceOrdersResponse{} = PlaceOrdersResponse.new(%{"x" => "x"})
    end

    test "should retrieve and transform succeeded orders into OrderInfo struct" do
      order_a = %{a: "a"}
      order_b = %{b: "b"}
      orders = [order_a, order_b]

      patch(OrderInfo, :new, %{c: "c"})

      assert %PlaceOrdersResponse{
               orders: [%{c: "c"}, %{c: "c"}]
             } = PlaceOrdersResponse.new(%{"orders" => orders})

      assert_called_once(OrderInfo.new(^order_a))
      assert_called_once(OrderInfo.new(^order_b))
    end
  end
end
