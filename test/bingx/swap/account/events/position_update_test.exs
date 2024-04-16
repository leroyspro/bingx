defmodule BingX.Swap.Account.PositionUpdateTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.Account.PositionUpdate

  @fields [
    :symbol,
    :side,
    :value,
    :margin,
    :average_price,
    :unrealized_pnl,
    :margin_mode
  ]

  describe "BingX.Swap.Account.PositionUpdate new/1" do
    test "should return empty struct without params" do
      assert %PositionUpdate{} = PositionUpdate.new(%{})
    end

    test_module_struct(PositionUpdate, @fields)

    test "should be tolerant to wrong data contract" do
      assert %PositionUpdate{} = PositionUpdate.new(%{"x" => "x"})
    end

    test_response_key_interp(PositionUpdate, :new, [], :interp_as_non_empty_binary, "s", :symbol)
    test_response_key_interp(PositionUpdate, :new, [], :to_internal_position_side, "ps", :side)
    test_response_key_interp(PositionUpdate, :new, [], :interp_as_float, "iw", :value)
    test_response_key_interp(PositionUpdate, :new, [], :interp_as_float, "pa", :margin)
    test_response_key_interp(PositionUpdate, :new, [], :interp_as_float, "ep", :average_price)
    test_response_key_interp(PositionUpdate, :new, [], :interp_as_float, "up", :unrealized_pnl)
    test_response_key_interp(PositionUpdate, :new, [], :to_internal_margin_mode, "mt", :margin_mode)
  end
end
