defmodule BingX.Swap.CancelOrdersResponseTest do
  use ExUnit.Case
  use Patch

  alias BingX.Swap.CancelOrdersResponse
  alias BingX.Swap.Trade.CanceledOrder

  @fields [:failed, :succeeded]

  describe "BingX.Swap.CancelOrdersResponse new/1" do
    test "should return empty struct without params" do
      assert %CancelOrdersResponse{} = CancelOrdersResponse.new(%{})
    end

    test "should have sufficient number of fields" do
      assert (
        %CancelOrdersResponse{} 
        |> Map.from_struct()
        |> Map.keys()
        |> length() === length(@fields)
      )
    end

    test "should have specific fields" do
      assert (
        %CancelOrdersResponse{}
        |> Map.from_struct()
        |> Map.keys()
        |> Enum.map(fn k -> assert k in @fields end)
      )
    end
  end

  describe "BingX.Swap.CancelOrdersResponse new/1 (transforming)" do
    test "should be tolerant to wrong interface" do
      assert %CancelOrdersResponse{} = CancelOrdersResponse.new(%{"x" => "x"})
    end

    test "should retrieve and transform succeeded orders into CanceledOrder struct" do
      order_a = %{a: "a"} 
      order_b = %{b: "b"}
      orders = [order_a, order_b]

      patch(CanceledOrder, :new, %{c: "c"})

      assert %CancelOrdersResponse{
        succeeded: [%{c: "c"}, %{c: "c"}]
      } = CancelOrdersResponse.new(%{"success" => orders})

      assert_called_once(CanceledOrder.new(^order_a))
      assert_called_once(CanceledOrder.new(^order_b))
    end
  end
end