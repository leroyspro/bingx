defmodule BingX.Swap.PlaceOrdersResponseTest do
  use ExUnit.Case
  use Patch

  alias BingX.Swap.PlaceOrdersResponse
  alias BingX.Swap.Trade.PlacedOrder

  @fields [:orders]

  describe "BingX.Swap.PlaceOrdersResponse new/1" do
    test "should return empty struct without params" do
      assert %PlaceOrdersResponse{} = PlaceOrdersResponse.new(%{})
    end

    test "should have sufficient number of fields" do
      assert (
        %PlaceOrdersResponse{} 
        |> Map.from_struct()
        |> Map.keys()
        |> length() === length(@fields)
      )
    end

    test "should have specific fields" do
      assert (
        %PlaceOrdersResponse{}
        |> Map.from_struct()
        |> Map.keys()
        |> Enum.map(fn k -> assert k in @fields end)
      )
    end
    
    test "should be tolerant to wrong interface" do
      assert %PlaceOrdersResponse{} = PlaceOrdersResponse.new(%{"x" => "x"})
    end

    test "should retrieve and transform succeeded orders into PlacedOrder struct" do
      order_a = %{a: "a"} 
      order_b = %{b: "b"}
      orders = [order_a, order_b]

      patch(PlacedOrder, :new, %{c: "c"})

      assert %PlaceOrdersResponse{
        orders: [%{c: "c"}, %{c: "c"}]
      } = PlaceOrdersResponse.new(%{"orders" => orders})

      assert_called_once(PlacedOrder.new(^order_a))
      assert_called_once(PlacedOrder.new(^order_b))
    end
  end
end
