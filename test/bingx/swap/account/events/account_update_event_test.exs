defmodule BingX.Swap.Account.AccountUpdateEventTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.Account.{AccountUpdateEvent, PositionUpdate, WalletUpdate}

  @fields [
    :type,
    :symbol,
    :timestamp,
    :wallet_updates,
    :position_updates
  ]

  describe "BingX.Swap.Market.AccountUpdateEvent new/1" do
    test "should return empty struct without params" do
      assert %AccountUpdateEvent{} = AccountUpdateEvent.new(%{})
    end

    test_module_struct(AccountUpdateEvent, @fields)

    test "should be tolerant to wrong data contract" do
      assert %AccountUpdateEvent{} = AccountUpdateEvent.new(%{"x" => "x"})
    end

    test "should transform event type properly" do
      assert %AccountUpdateEvent{type: :order} = AccountUpdateEvent.new(%{"a" => %{"m" => "ORDER"}})
      assert %AccountUpdateEvent{type: :funding_fee} = AccountUpdateEvent.new(%{"a" => %{"m" => "FUNDING_FEE"}})
      assert %AccountUpdateEvent{type: :deposit} = AccountUpdateEvent.new(%{"a" => %{"m" => "DEPOSIT"}})
      assert %AccountUpdateEvent{type: :withdraw} = AccountUpdateEvent.new(%{"a" => %{"m" => "WITHDRAW"}})
      assert %AccountUpdateEvent{type: nil} = AccountUpdateEvent.new(%{"a" => %{"m" => "SS"}})
      assert %AccountUpdateEvent{type: nil} = AccountUpdateEvent.new(%{"a" => %{}})
    end

    test_response_key_interp(AccountUpdateEvent, :new, [], "E", :timestamp)

    test "should transform position updates into PositionUpdate structs" do
      orig_update = %{"k" => "V"}
      next_update = %{"X" => "B"}

      patch(PositionUpdate, :new, next_update)

      data = %{"a" => %{"P" => [orig_update]}}
      AccountUpdateEvent.new(data)

      assert_called_once(PositionUpdate.new(^orig_update))
    end

    test "should provide position updates in PositionUpdate structs" do
      orig_update = %{"k" => "V"}
      next_update = %{"X" => "B"}

      patch(PositionUpdate, :new, next_update)

      data = %{"a" => %{"P" => [orig_update]}}

      assert %AccountUpdateEvent{position_updates: [^next_update]} = AccountUpdateEvent.new(data)
    end

    test "should be tolerant for incorrect position update data contract" do
      data = %{"a" => %{"P" => nil}}
      AccountUpdateEvent.new(data)
    end

    test "should transform wallet updates into WalletUpdate structs" do
      orig_update = %{"k" => "V"}
      next_update = %{"X" => "B"}

      patch(WalletUpdate, :new, next_update)

      data = %{"a" => %{"B" => [orig_update]}}
      AccountUpdateEvent.new(data)

      assert_called_once(WalletUpdate.new(^orig_update))
    end

    test "should provide wallet updates in WalletUpdate structs" do
      orig_update = %{"k" => "V"}
      next_update = %{"X" => "B"}

      patch(WalletUpdate, :new, next_update)

      data = %{"a" => %{"B" => [orig_update]}}

      assert %AccountUpdateEvent{wallet_updates: [^next_update]} = AccountUpdateEvent.new(data)
    end

    test "should be tolerant for incorrect wallet update data contract" do
      data = %{"a" => %{"B" => nil}}
      AccountUpdateEvent.new(data)
    end
  end
end
