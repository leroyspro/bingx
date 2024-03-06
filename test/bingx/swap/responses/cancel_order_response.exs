defmodule BingX.Swap.CancelOrderResponseTest do
  use ExUnit.Case
  use Patch

  alias BingX.Swap.CancelOrderResponse
  alias BingX.Swap.Trade.CanceledOrder

  @fields [
    :order_id,
    :symbol,
    :side,
    :position_side,
    :status,
    :stop_price,
    :price,
    :type,
    :working_type,
    :leverage,
    :fee,
    :transaction_amount,
    :executed_quantity,
    :only_one_position?,
    :order_type,
    :original_quantity,
    :average_price,
    :position_id,
    :profit,
    :reduce_only?,
    :stop_loss,
    :stop_loss_entrust_price,
    :take_profit,
    :take_profit_entrust_price,
    :timestamp,
    :update_time
  ]

  describe "BingX.Swap.CancelAllOrdersResponse new/1" do
    test "should return empty struct without params" do
      assert %CancelOrderResponse{} = CancelOrderResponse.new(%{})
    end

    test "should have sufficient number of fields" do
      assert (
        %CancelOrderResponse{} 
        |> Map.from_struct()
        |> Map.keys()
        |> length() === length(@fields)
      )
    end

    test "should have specific fields" do
      assert (
        %CancelOrderResponse{}
        |> Map.from_struct()
        |> Map.keys()
        |> Enum.map(fn k -> assert k in @fields end)
      )
    end
  end

  describe "BingX.Swap.CancelAllOrdersResponse new/1 (transforming)" do
    test "should be tolerant to wrong interface" do
      assert %CancelOrderResponse{} = CancelOrderResponse.new(%{"x" => "x"})
    end

    test "should retrieve data and cast it into CanceledOrder struct" do
      order = %{a: "a"} 

      struct = %{c: "c"}
      patch(CanceledOrder, :cast, struct)

      assert ^struct = CancelOrderResponse.new(%{"order" => order})

      assert_called_once(CanceledOrder.cast(^order, as: CancelOrderResponse))
    end
  end
end
