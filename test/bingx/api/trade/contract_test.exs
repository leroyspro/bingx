defmodule BingX.API.ContractTest do
  use ExUnit.Case
  use Patch

  alias BingX.Order
  alias BingX.API.Trade.Contract
  alias BingX.API.Interpretators

  describe "BingX.API.Contract from_order/2" do
    test "should return map struct" do
      assert %{} = Contract.from_order(%Order{})
    end

    test "should transform type properly" do
      patch(Interpretators, :to_external_order_type, "ORDER_TYPE")
      assert %{"type" => "ORDER_TYPE"} = Contract.from_order(%Order{type: :order_type})
      assert_called_once(Interpretators.to_external_order_type(:order_type))
    end

    test "should transform order id properly" do
      order_id = "12312321"
      assert %{"orderId" => ^order_id} = Contract.from_order(%Order{order_id: order_id})
    end

    test "should transform symbol properly" do
      symbol = "BTC-USDT"
      assert %{"symbol" => ^symbol} = Contract.from_order(%Order{symbol: symbol})
    end

    test "should transform side properly" do
      patch(Interpretators, :to_external_order_side, "ORDER_SIDE")
      assert %{"side" => "ORDER_SIDE"} = Contract.from_order(%Order{side: :order_side})
      assert_called_once(Interpretators.to_external_order_side(:order_side))
    end

    test "should transform position side properly" do
      patch(Interpretators, :to_external_position_side, "POSITION_SIDE")
      assert %{"positionSide" => "POSITION_SIDE"} = Contract.from_order(%Order{position_side: :position_side})
      assert_called_once(Interpretators.to_external_position_side(:position_side))
    end

    test "should transform price properly" do
      price = 12312.2131
      assert %{"price" => ^price} = Contract.from_order(%Order{price: price})
    end

    test "should transform stop price properly" do
      stop_price = 12312.2131
      assert %{"stopPrice" => ^stop_price} = Contract.from_order(%Order{stop_price: stop_price})
    end

    test "should transform quantity properly" do
      quantity = 12312.2131
      assert %{"quantity" => ^quantity} = Contract.from_order(%Order{quantity: quantity})
    end

    test "should transform client order id properly" do
      client_order_id = 12_312_321
      assert %{"clientOrderID" => ^client_order_id} = Contract.from_order(%Order{client_order_id: client_order_id})
    end

    test "should transform working type properly" do
      patch(Interpretators, :to_external_working_type, "WORKING_TYPE")
      assert %{"workingType" => "WORKING_TYPE"} = Contract.from_order(%Order{working_type: :working_type})
      assert_called_once(Interpretators.to_external_working_type(:working_type))
    end

    test "should transform all params properly" do
      patch(Interpretators, :to_external_working_type, "WORKING_TYPE")
      patch(Interpretators, :to_external_position_side, "POSITION_SIDE")
      patch(Interpretators, :to_external_order_side, "ORDER_SIDE")
      patch(Interpretators, :to_external_order_type, "ORDER_TYPE")

      assert %{
               "type" => "ORDER_TYPE",
               "orderId" => "ORDER_ID",
               "symbol" => "SYMBOL",
               "side" => "ORDER_SIDE",
               "positionSide" => "POSITION_SIDE",
               "price" => "PRICE",
               "stopPrice" => "STOP_PRICE",
               "quantity" => "QUANTITY",
               "clientOrderID" => "CLIENT_ORDER_ID",
               "workingType" => "WORKING_TYPE"
             } =
               Contract.from_order(%Order{
                 type: :order_type,
                 side: :order_side,
                 position_side: :position_side,
                 working_type: :working_type,
                 order_id: "ORDER_ID",
                 symbol: "SYMBOL",
                 price: "PRICE",
                 stop_price: "STOP_PRICE",
                 quantity: "QUANTITY",
                 client_order_id: "CLIENT_ORDER_ID"
               })

      assert_called_once(Interpretators.to_external_working_type(:working_type))
      assert_called_once(Interpretators.to_external_position_side(:position_side))
      assert_called_once(Interpretators.to_external_order_side(:order_side))
      assert_called_once(Interpretators.to_external_order_type(:order_type))
    end
  end
end
