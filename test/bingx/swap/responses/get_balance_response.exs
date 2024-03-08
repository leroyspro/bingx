defmodule BingX.Swap.GetBalanceResponseTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.{GetBalanceResponse, Interpretators}

  @fields [
    :asset,
    :balance,
    :available_margin,
    :equity,
    :freezed_margin,
    :realized_profit,
    :unrealized_profit,
    :used_margin,
    :user_id
  ]

  describe "BingX.Swap.GetBalanceResponse new/1" do
    test "should return empty struct without params" do
      assert %GetBalanceResponse{} = GetBalanceResponse.new(%{})
    end

    test_module_struct(GetBalanceResponse, @fields)

    test "should be tolerant to wrong data contract" do
      assert %GetBalanceResponse{} = GetBalanceResponse.new(%{"x" => "x"})
    end

    test_response_key_interp(GetBalanceResponse, :new, [], :interp_as_non_empty_binary, ["balance", "asset"], :asset)
    test_response_key_interp(GetBalanceResponse, :new, [], :interp_as_float, ["balance", "balance"], :balance)
    test_response_key_interp(GetBalanceResponse, :new, [], :interp_as_float, ["balance", "equity"], :equity)
    test_response_key_interp(GetBalanceResponse, :new, [], :interp_as_float, ["balance", "availableMargin"], :available_margin)
    test_response_key_interp(GetBalanceResponse, :new, [], :interp_as_float, ["balance", "freezedMargin"], :freezed_margin)
    test_response_key_interp(GetBalanceResponse, :new, [], :interp_as_float, ["balance", "realisedProfit"], :realized_profit)
    test_response_key_interp(GetBalanceResponse, :new, [], :interp_as_float, ["balance", "unrealizedProfit"], :unrealized_profit)
    test_response_key_interp(GetBalanceResponse, :new, [], :interp_as_float, ["balance", "usedMargin"], :used_margin)
    test_response_key_interp(GetBalanceResponse, :new, [], :interp_as_non_empty_binary, ["balance", "userId"], :user_id)
  end
end
