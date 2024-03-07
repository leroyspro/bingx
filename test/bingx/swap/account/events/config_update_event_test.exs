defmodule BingX.Swap.Account.ConfigUpdateEventTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.Account.ConfigUpdateEvent

  @fields [
    :symbol,
    :timestamp,
    :margin_mode,
    :short_leverage,
    :long_leverage
  ]

  describe "BingX.Swap.Account.ConfigUpdateEvent new/1" do
    test "should return empty struct without params" do
      assert %ConfigUpdateEvent{} = ConfigUpdateEvent.new(%{})
    end

    test_module_struct(ConfigUpdateEvent, @fields)

    test "should be tolerant to wrong data contract" do
      assert %ConfigUpdateEvent{} = ConfigUpdateEvent.new(%{"sks" => "//"})
    end

    test_response_key_interp(ConfigUpdateEvent, :new, [], :interp_as_non_empty_binary, ["ac", "s"], :symbol)
    test_response_key_interp(ConfigUpdateEvent, :new, [], :to_internal_margin_mode, ["ac", "mt"], :margin_mode)
    test_response_key_interp(ConfigUpdateEvent, :new, [], :interp_as_float, ["ac", "S"], :short_leverage)
    test_response_key_interp(ConfigUpdateEvent, :new, [], :interp_as_float, ["ac", "l"], :long_leverage)
    test_response_key_interp(ConfigUpdateEvent, :new, [], ["E"], :timestamp)
  end
end
