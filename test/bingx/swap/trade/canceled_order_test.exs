defmodule BingX.Swap.Trade.CanceledOrderTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

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

  defmodule Dummy do
    defstruct [:order_id, :type]
  end

  describe "BingX.Swap.Trade.CanceledOrder cast/2" do
    test "should return empty struct without params" do
      assert %CanceledOrder{} = CanceledOrder.cast(%{}, as: CanceledOrder)
    end

    test "should cast params to other module structs" do
      data = %{"orderId" => 2, "type" => "MARKET"}
      assert %Dummy{order_id: "2", type: :market} = CanceledOrder.cast(data, as: Dummy)
    end

    test_module_struct(CanceledOrder, @fields)

    test "should be tolerant to wrong data contract" do
      assert %CanceledOrder{} = CanceledOrder.new(%{"x" => "x"})
    end

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :interp_as_non_empty_binary,
      "orderId",
      :order_id
    )

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :interp_as_non_empty_binary,
      "symbol",
      :symbol
    )

    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], :to_internal_order_side, "side", :side)

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :to_internal_position_side,
      "positionSide",
      :position_side
    )

    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], :to_internal_order_status, "status", :status)
    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], :interp_as_float, "stopPrice", :stop_price)
    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], :interp_as_float, "price", :price)
    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], :to_internal_order_type, "type", :type)

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :to_internal_working_type,
      "workingType",
      :working_type
    )

    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], :interp_as_float, "leverage", :leverage)
    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], :interp_as_float, "commission", :fee)

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :interp_as_float,
      "cumQuote",
      :transaction_amount
    )

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :interp_as_float,
      "executedQty",
      :executed_quantity
    )

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :interp_as_boolean,
      "onlyOnePosition",
      :only_one_position?
    )

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :interp_as_non_empty_binary,
      "orderType",
      :order_type
    )

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :interp_as_float,
      "origQty",
      :original_quantity
    )

    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], :interp_as_float, "avgPrice", :average_price)
    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], :interp_as_binary, "positionID", :position_id)
    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], :interp_as_float, "profit", :profit)

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :interp_as_boolean,
      "reduceOnly",
      :reduce_only?
    )

    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], "stopLoss", :stop_loss)

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :interp_as_float,
      "stopLossEntrustPrice",
      :stop_loss_entrust_price
    )

    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], "takeProfit", :take_profit)

    test_response_key_interp(
      CanceledOrder,
      :cast,
      [[as: CanceledOrder]],
      :interp_as_float,
      "takeProfitEntrustPrice",
      :take_profit_entrust_price
    )

    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], "time", :timestamp)
    test_response_key_interp(CanceledOrder, :cast, [[as: CanceledOrder]], "updateTime", :update_time)
  end

  describe "BingX.Swap.Trade.CanceledOrder new/1" do
    test "should struct via local cast/2 function" do
      data = %{"k" => "X"}
      n_data = %{"k" => "Y"}

      patch(CanceledOrder, :cast, n_data)
      assert ^n_data = CanceledOrder.new(data)

      assert_called_once(CanceledOrder.cast(^data, as: CanceledOrder))
    end
  end
end
