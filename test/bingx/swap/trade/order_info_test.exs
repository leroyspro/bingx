defmodule BingX.Swap.Trade.OrderInfoTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.Trade.OrderInfo

  @fields [
    :symbol,
    :side,
    :position_side,
    :price,
    :stop_price,
    :working_type,
    :quantity,
    :type,
    :order_id,
    :client_order_id,
    :stop_loss,
    :take_profit,
    :time_in_force,
    :reduce_only?,
    :price_rate,
    :activation_price,
    :close_position?,
    :stop_guaranteed?
  ]

  defmodule Dummy do
    defstruct [:order_id, :type]
  end

  describe "BingX.Swap.Trade.OrderInfo cast/2" do
    test "should return empty struct without params" do
      assert %OrderInfo{} = OrderInfo.cast(%{}, as: OrderInfo)
    end

    test "should cast params to other module structs" do
      data = %{"orderId" => 2, "type" => "MARKET"}
      assert %Dummy{order_id: "2", type: :market} = OrderInfo.cast(data, as: Dummy)
    end

    test_module_struct(OrderInfo, @fields)

    test "should be tolerant to wrong data contract" do
      assert %OrderInfo{} = OrderInfo.new(%{"x" => "x"})
    end

    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_non_empty_binary, "orderId", :order_id)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_non_empty_binary, "clientOrderID", :client_order_id)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_float, "quantity", :quantity)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :to_internal_order_type, "type", :type)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_non_empty_binary, "symbol", :symbol)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :to_internal_order_side, "side", :side)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :to_internal_position_side, "positionSide", :position_side)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_float, "stopPrice", :stop_price)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_float, "price", :price)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :to_internal_working_type, "workingType", :working_type)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_boolean, "reduceOnly", :reduce_only?)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], "stopLoss", :stop_loss)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], "takeProfit", :take_profit)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], "timeInForce", :time_in_force)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_float, "priceRate", :price_rate)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_float, "activationPrice", :activation_price)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_boolean, "closePosition", :close_position?)
    test_response_key_interp(OrderInfo, :cast, [[as: OrderInfo]], :interp_as_boolean, "stopGuaranteed", :stop_guaranteed?)
  end

  describe "BingX.Swap.Trade.OrderInfo new/1" do
    test "should struct via local cast/2 function" do
      data = %{"k" => "X"}
      n_data = %{"k" => "Y"}

      patch(OrderInfo, :cast, n_data)
      assert ^n_data = OrderInfo.new(data)

      assert_called_once(OrderInfo.cast(^data, as: OrderInfo))
    end
  end
end
