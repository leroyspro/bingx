defmodule BingX.Swap.Trade.PlaceOrderResponseTest do
  use ExUnit.Case
  use Patch

  alias BingX.Swap.Trade.PlaceOrderResponse
  alias BingX.Swap.Interpretators

  describe "BingX.API.Trade.PlaceOrderResponse new/1" do
    test "should return empty struct without params" do
      assert %PlaceOrderResponse{} = PlaceOrderResponse.new(%{})
    end
  end

  describe "BingX.API.Trade.PlaceOrderResponse new/1 (transforming)" do
    test "should retrieve and transform order id into binary",
      do: build_transform_assert(:binary, :order_id, "orderId")

    test "should retrieve and transform client order id into binary",
      do: build_transform_assert(:binary, :client_order_id, "clientOrderID")

    test "should retrieve and transform price into float",
      do: build_transform_assert(:float, :price, "price")

    test "should retrieve and transform stop price into float",
      do: build_transform_assert(:float, :stop_price, "stopPrice")

    test "should retrieve and transform quantity into float",
      do: build_transform_assert(:float, :quantity, "quantity")

    test "should retrieve and transform price rate to float",
      do: build_transform_assert(:float, :price_rate, "priceRate")

    test "should retrieve and transform type" do
      patch(Interpretators, :to_internal_order_type, :market)
      assert %PlaceOrderResponse{type: :market} = PlaceOrderResponse.new(%{"type" => "MARKET"})
      assert_called_once(Interpretators.to_internal_order_type("MARKET"))
    end

    test "should retrieve symbol" do
      assert %PlaceOrderResponse{symbol: "BTC-USDT"} =
               PlaceOrderResponse.new(%{"symbol" => "BTC-USDT"})
    end

    test "should retrieve and transform side" do
      patch(Interpretators, :to_internal_order_side, :buy)
      assert %PlaceOrderResponse{side: :buy} = PlaceOrderResponse.new(%{"side" => "BUY"})
      assert_called_once(Interpretators.to_internal_order_side("BUY"))
    end

    test "should retrieve and transform position side" do
      patch(Interpretators, :to_internal_position_side, :both)

      assert %PlaceOrderResponse{position_side: :both} =
               PlaceOrderResponse.new(%{"positionSide" => "BOTH"})

      assert_called_once(Interpretators.to_internal_position_side("BOTH"))
    end

    test "should retrieve and transform working type" do
      patch(Interpretators, :to_internal_working_type, :mark_price)

      assert %PlaceOrderResponse{working_type: :mark_price} =
               PlaceOrderResponse.new(%{"workingType" => "MARK_PRICE"})

      assert_called_once(Interpretators.to_internal_working_type("MARK_PRICE"))
    end

    test "should retrieve stop loss" do
      stop_loss = %{"k" => "v"}

      assert %PlaceOrderResponse{stop_loss: ^stop_loss} =
               PlaceOrderResponse.new(%{"stopLoss" => stop_loss})
    end

    test "should retrieve take profit" do
      take_profit = %{"k" => "v"}

      assert %PlaceOrderResponse{take_profit: ^take_profit} =
               PlaceOrderResponse.new(%{"takeProfit" => take_profit})
    end

    test "should retrieve time in force" do
      assert %PlaceOrderResponse{time_in_force: "GTC"} =
               PlaceOrderResponse.new(%{"timeInForce" => "GTC"})
    end

    test "should retrieve reduce only" do
      assert %PlaceOrderResponse{reduce_only?: false} =
               PlaceOrderResponse.new(%{"reduceOnly" => false})
    end
  end

  describe "BingX.API.Trade.PlaceOrderResponse new/1 (omitting)" do
    test "should omit unexpected price value",
      do: build_omit_assert(:float, :price, "price")

    test "should omit unexpected stop price value",
      do: build_omit_assert(:float, :stop_price, "stopPrice")

    test "should omit unexpected quantity value",
      do: build_omit_assert(:float, :quantity, "quantity")

    test "should omit unexpected price rate value",
      do: build_omit_assert(:float, :price_rate, "priceRate")
  end

  # order_id: get_and_transform(data, "orderId", &interp_order_id/1),
  # client_order_id: get_and_transform(data, "clientOrderID", &to_string/1),
  # type: get_and_transform(data, "type", &interp_order_type/1),
  # symbol: Map.get(data, "symbol"),
  # side: get_and_transform(data, "side", &interp_order_side/1),
  # position_side: get_and_transform(data, "positionSide", &interp_position_side/1),
  # price: get_and_transform(data, "price", &interp_as_float/1),
  # stop_price: get_and_transform(data, "stopPrice", &interp_as_float/1),
  # working_type: Map.get(data, "workingType"),
  # quantity: get_and_transform(data, "quantity", &interp_as_float/1),
  # stop_loss: Map.get(data, "stopLoss"),
  # take_profit: Map.get(data, "takeProfit"),
  # time_in_force: Map.get(data, "timeInForce"),
  # reduce_only?: Map.get(data, "reduceOnly"),
  # price_rate: Map.get(data, "priceRate")

  defp build_transform_assert(:float, exp_key, orig_key) do
    assert %PlaceOrderResponse{} =
             %{^exp_key => 24.00001} = PlaceOrderResponse.new(%{orig_key => "24.00001"})

    assert %PlaceOrderResponse{} =
             %{^exp_key => +0.0} = PlaceOrderResponse.new(%{orig_key => "0.00000"})

    assert %PlaceOrderResponse{} =
             %{^exp_key => 15.0} = PlaceOrderResponse.new(%{orig_key => "15"})
  end

  defp build_transform_assert(:binary, exp_key, orig_key) do
    assert %PlaceOrderResponse{} =
             %{^exp_key => "24000"} = PlaceOrderResponse.new(%{orig_key => "24000"})

    assert %PlaceOrderResponse{} =
             %{^exp_key => "uuid"} = PlaceOrderResponse.new(%{orig_key => "uuid"})

    assert %PlaceOrderResponse{} =
             %{^exp_key => "24.0"} = PlaceOrderResponse.new(%{orig_key => 24.0})

    assert %PlaceOrderResponse{} =
             %{^exp_key => "2121"} = PlaceOrderResponse.new(%{orig_key => 2121})
  end

  defp build_omit_assert(:float, exp_key, orig_key) do
    assert %PlaceOrderResponse{} = %{^exp_key => 1.0} = PlaceOrderResponse.new(%{orig_key => 1.0})

    assert %PlaceOrderResponse{} =
             %{^exp_key => nil} = PlaceOrderResponse.new(%{orig_key => "null"})

    assert %PlaceOrderResponse{} = %{^exp_key => nil} = PlaceOrderResponse.new(%{orig_key => ""})
    assert %PlaceOrderResponse{} = %{^exp_key => nil} = PlaceOrderResponse.new(%{orig_key => nil})
  end
end
