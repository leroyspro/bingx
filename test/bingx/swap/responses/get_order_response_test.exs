defmodule BingX.Swap.GetOrderResponseTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.GetOrderResponse
  alias BingX.Swap.Trade.DetailedOrderInfo

  @fields [
    :order_id,
    :symbol,
    :side,
    :position_side,
    :status,
    :stop_price,
    :price,
    :type,
    :client_order_id,
    :trigger_order_id,
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
    :stop_guaranteed?,
    :timestamp,
    :update_time
  ]

  describe "BingX.Swap.GetOrderResponse new/1" do
    test "should return empty struct without params" do
      assert %GetOrderResponse{} = GetOrderResponse.new(%{})
    end

    test_module_struct(GetOrderResponse, @fields)

    test "should be tolerant to wrong interface" do
      assert %GetOrderResponse{} = GetOrderResponse.new(%{"x" => "x"})
    end

    test "should retrieve data and cast it into OrderInfo struct" do
      order = %{a: "a"}

      struct = %{c: "c"}
      patch(DetailedOrderInfo, :cast, struct)

      assert ^struct = GetOrderResponse.new(%{"order" => order})

      assert_called_once(DetailedOrderInfo.cast(^order, as: GetOrderResponse))
    end
  end
end
