defmodule BingX.Swap.Trade.DetailedOrderInfoTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

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

  defmodule Dummy do
    defstruct [:order_id, :type]
  end

  describe "BingX.Swap.Trade.DetailedOrderInfo cast/2" do
    test "should return empty struct without params" do
      assert %DetailedOrderInfo{} = DetailedOrderInfo.cast(%{}, as: DetailedOrderInfo)
    end

    test "should cast params to other module structs" do
      data = %{"orderId" => 2, "type" => "MARKET"}
      assert %Dummy{order_id: "2", type: :market} = DetailedOrderInfo.cast(data, as: Dummy)
    end

    test_module_struct(DetailedOrderInfo, @fields)

    test "should be tolerant to wrong data contract" do
      assert %DetailedOrderInfo{} = DetailedOrderInfo.new(%{"x" => "x"})
    end

    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_non_empty_binary, "orderId", :order_id)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_non_empty_binary, "symbol", :symbol)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :to_internal_order_side, "side", :side)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :to_internal_position_side, "positionSide", :position_side)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :to_internal_order_status, "status", :status)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "stopPrice", :stop_price)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "price", :price)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :to_internal_order_type, "type", :type)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_non_empty_binary, "clientOrderId", :client_order_id)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_non_empty_binary, "triggerOrderId", :trigger_order_id)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :to_internal_working_type, "workingType", :working_type)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "leverage", :leverage)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "commission", :fee)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "cumQuote", :transaction_amount)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "executedQty", :executed_quantity)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_boolean, "onlyOnePosition", :only_one_position?)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], "orderType", :order_type)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "origQty", :original_quantity)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "avgPrice", :average_price)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_binary, "positionID", :position_id)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "profit", :profit)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_boolean, "reduceOnly", :reduce_only?)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], "stopLoss", :stop_loss)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "stopLossEntrustPrice", :stop_loss_entrust_price)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], "takeProfit", :take_profit)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_float, "takeProfitEntrustPrice", :take_profit_entrust_price)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], :interp_as_boolean, "stopGuaranteed", :stop_guaranteed?)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], "time", :timestamp)
    test_response_key_interp(DetailedOrderInfo, :cast, [[as: DetailedOrderInfo]], "updateTime", :update_time)
  end

  describe "BingX.Swap.Trade.DetailedOrderInfo new/1" do
    test "should struct via local cast/2 function" do
      data = %{"k" => "X"}
      n_data = %{"k" => "Y"}

      patch(DetailedOrderInfo, :cast, n_data)
      assert ^n_data = DetailedOrderInfo.new(data)

      assert_called_once(DetailedOrderInfo.cast(^data, as: DetailedOrderInfo))
    end
  end
end
