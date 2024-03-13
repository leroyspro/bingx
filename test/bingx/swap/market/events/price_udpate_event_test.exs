defmodule BingX.Swap.Market.PriceUpdateEventTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.Market.PriceUpdateEvent

  @fields [
    :type,
    :value,
    :symbol,
    :timestamp
  ]

  describe "BingX.Swap.Market.PriceUpdateEvent new/1" do
    test "should return empty struct without params" do
      assert %PriceUpdateEvent{} = PriceUpdateEvent.new(%{})
    end

    test_module_struct(PriceUpdateEvent, @fields)

    test "should be tolerant to wrong data contract" do
      assert %PriceUpdateEvent{} = PriceUpdateEvent.new(%{"x" => "x"})
    end

    test "should transform event type properly" do
      assert %PriceUpdateEvent{type: :last} = PriceUpdateEvent.new(%{"dataType" => "BTC-USDT@lastPrice"})
      assert %PriceUpdateEvent{type: :mark} = PriceUpdateEvent.new(%{"dataType" => "MATIC-USDT@markPrice"})
      assert %PriceUpdateEvent{type: nil} = PriceUpdateEvent.new(%{"dataType" => "KOK-USDT@lasPrice"})
    end

    test_response_key_interp(PriceUpdateEvent, :new, [], :interp_as_float, ["data", "p"], :value)
    test_response_key_interp(PriceUpdateEvent, :new, [], :interp_as_non_empty_binary, ["data", "s"], :symbol)
    test_response_key_interp(PriceUpdateEvent, :new, [], ["data", "E"], :timestamp)
  end
end
