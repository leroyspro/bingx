defmodule BingX.Swap.CancelAllOrdersResponseTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.CancelAllOrdersResponse
  alias BingX.Swap.Trade.DetailedOrderInfo

  @fields [:failed, :succeeded]

  describe "BingX.Swap.CancelAllOrdersResponse new/1" do
    test "should return empty struct without params" do
      assert %CancelAllOrdersResponse{} = CancelAllOrdersResponse.new(%{})
    end

    test_module_struct(CancelAllOrdersResponse, @fields)

    test "should be tolerant to wrong interface" do
      assert %CancelAllOrdersResponse{} = CancelAllOrdersResponse.new(%{"x" => "x"})
    end

    test "should retrieve and transform succeeded orders into DetailedOrderInfo struct" do
      order_a = %{a: "a"}
      order_b = %{b: "b"}
      orders = [order_a, order_b]

      patch(DetailedOrderInfo, :new, %{c: "c"})

      assert %CancelAllOrdersResponse{
               succeeded: [%{c: "c"}, %{c: "c"}]
             } = CancelAllOrdersResponse.new(%{"success" => orders})

      assert_called_once(DetailedOrderInfo.new(^order_a))
      assert_called_once(DetailedOrderInfo.new(^order_b))
    end
  end
end
