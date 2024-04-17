defmodule BingX.Swap.Account.OrderTradeEventTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.Account.OrderTradeEvent

  @fields [
    :symbol,
    :status,
    :order_id,
    :client_order_id,
    :trigger_order_id,
    :side,
    :position_side,
    :type,
    :execution_type,
    :quantity,
    :price,
    :trigger_price,
    :actual_price,
    :fee,
    :fee_asset,
    # :guaranteed_sl_tp,
    :working_type,
    :accumulated_quantity,
    :timestamp
  ]

  describe "BingX.Swap.Account.OrderTradeEvent new/1" do
    test "should return empty struct without params" do
      assert %OrderTradeEvent{} = OrderTradeEvent.new(%{})
    end

    test_module_struct(OrderTradeEvent, @fields)

    test "should be tolerant to wrong data contract" do
      assert %OrderTradeEvent{} = OrderTradeEvent.new(%{"x" => "x"})
    end

    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_non_empty_binary, ["o", "s"], :symbol)
    test_response_key_interp(OrderTradeEvent, :new, [], :to_internal_order_status, ["o", "X"], :status)
    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_non_empty_binary, ["o", "i"], :order_id)
    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_non_empty_binary, ["o", "c"], :client_order_id)
    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_non_empty_binary, ["o", "ti"], :trigger_order_id)
    test_response_key_interp(OrderTradeEvent, :new, [], :to_internal_order_side, ["o", "S"], :side)
    test_response_key_interp(OrderTradeEvent, :new, [], :to_internal_position_side, ["o", "ps"], :position_side)
    test_response_key_interp(OrderTradeEvent, :new, [], :to_internal_order_type, ["o", "o"], :type)
    test_response_key_interp(OrderTradeEvent, :new, [], :to_internal_order_execution_type, ["o", "x"], :execution_type)
    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_float, ["o", "q"], :quantity)
    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_float, ["o", "p"], :price)
    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_float, ["o", "sp"], :trigger_price)
    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_float, ["o", "ap"], :actual_price)
    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_float, ["o", "n"], :fee)
    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_non_empty_binary, ["o", "N"], :fee_asset)
    # test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_boolean, ["o", "sg"], :guaranteed_sl_tp)
    test_response_key_interp(OrderTradeEvent, :new, [], :to_internal_working_type, ["o", "wt"], :working_type)
    test_response_key_interp(OrderTradeEvent, :new, [], :interp_as_float, ["o", "z"], :accumulated_quantity)
    test_response_key_interp(OrderTradeEvent, :new, [], "E", :timestamp)
  end
end
