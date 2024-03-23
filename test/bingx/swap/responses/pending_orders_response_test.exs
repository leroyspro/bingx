defmodule BingX.Swap.PendingOrdersResponseTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.PendingOrdersResponse
  alias BingX.Swap.Trade.DetailedOrderInfo

  @fields [:orders]

  describe "BingX.Swap.PendingOrdersResponse new/1" do
    test "should return empty struct without params" do
      assert %PendingOrdersResponse{} = PendingOrdersResponse.new(%{})
    end

    test_module_struct(PendingOrdersResponse, @fields)

    test "should be tolerant to wrong interface" do
      assert %PendingOrdersResponse{} = PendingOrdersResponse.new(%{"x" => "x"})
    end

    test "should retrieve and transform succeeded orders into DetailedOrderInfo struct" do
      order_a = %{a: "a"}
      order_b = %{b: "b"}
      orders = [order_a, order_b]

      patch(DetailedOrderInfo, :new, %{c: "c"})

      assert %PendingOrdersResponse{
               orders: [%{c: "c"}, %{c: "c"}]
             } = PendingOrdersResponse.new(%{"orders" => orders})

      assert_called_once(DetailedOrderInfo.new(^order_a))
      assert_called_once(DetailedOrderInfo.new(^order_b))
    end
  end
end
