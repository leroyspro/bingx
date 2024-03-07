defmodule BingX.Swap.Account.WalletUpdateTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.Account.WalletUpdate

  @fields [
    :asset,
    :balance_change,
    :available_balance,
    :balance
  ]

  describe "BingX.Swap.Account.WalletUpdate new/1" do
    test "should return empty struct without params" do
      assert %WalletUpdate{} = WalletUpdate.new(%{})
    end

    test_module_struct(WalletUpdate, @fields)

    test "should be tolerant to wrong data contract" do
      assert %WalletUpdate{} = WalletUpdate.new(%{"x" => "x"})
    end

    test_response_key_interp(WalletUpdate, :new, [], :interp_as_non_empty_binary, "a", :asset)
    test_response_key_interp(WalletUpdate, :new, [], :interp_as_float, "bc", :balance_change)
    test_response_key_interp(WalletUpdate, :new, [], :interp_as_float, "wb", :available_balance)
    test_response_key_interp(WalletUpdate, :new, [], :interp_as_float, "cw", :balance)
  end
end
