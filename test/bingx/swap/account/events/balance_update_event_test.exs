defmodule BingX.Swap.Account.BalanceUpdateEventTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.Account.{BalanceUpdateEvent, PositionUpdate, WalletUpdate}

  @fields [
    :type,
    :symbol,
    :timestamp,
    :wallet_updates,
    :position_updates
  ]

  describe "BingX.Swap.Market.BalanceUpdateEvent new/1" do
    test "should return empty struct without params" do
      assert %BalanceUpdateEvent{} = BalanceUpdateEvent.new(%{})
    end

    test_module_struct(BalanceUpdateEvent, @fields)

    test "should be tolerant to wrong data contract" do
      assert %BalanceUpdateEvent{} = BalanceUpdateEvent.new(%{"x" => "x"})
    end

    test "should transform event type properly" do
      assert %BalanceUpdateEvent{type: :order} = BalanceUpdateEvent.new(%{"a" => %{"m" => "ORDER"}})
      assert %BalanceUpdateEvent{type: :funding_fee} = BalanceUpdateEvent.new(%{"a" => %{"m" => "FUNDING_FEE"}})
      assert %BalanceUpdateEvent{type: :deposit} = BalanceUpdateEvent.new(%{"a" => %{"m" => "DEPOSIT"}})
      assert %BalanceUpdateEvent{type: :withdraw} = BalanceUpdateEvent.new(%{"a" => %{"m" => "WITHDRAW"}})
      assert %BalanceUpdateEvent{type: nil} = BalanceUpdateEvent.new(%{"a" => %{"m" => "SS"}})
      assert %BalanceUpdateEvent{type: nil} = BalanceUpdateEvent.new(%{"a" => %{}})
    end

    test_response_key_interp(BalanceUpdateEvent, :new, [], "E", :timestamp)

    test "should transform position updates into PositionUpdate structs" do
      orig_update = %{"k" => "V"} 
      next_update = %{"X" => "B"}
     
      patch(PositionUpdate, :new, next_update)
  
      data = %{"a" => %{"P" => [orig_update]}}
      BalanceUpdateEvent.new(data)
  
      assert_called_once(PositionUpdate.new(^orig_update))
    end
  
    test "should provide position updates in PositionUpdate structs" do
      orig_update = %{"k" => "V"} 
      next_update = %{"X" => "B"}
     
      patch(PositionUpdate, :new, next_update)
  
      data = %{"a" => %{"P" => [orig_update]}}
  
      assert %BalanceUpdateEvent{position_updates: [^next_update]} = BalanceUpdateEvent.new(data)
    end
  
    test "should be tolerant for incorrect position update data contract" do
      data = %{"a" => %{"P" => nil}}
      BalanceUpdateEvent.new(data)
    end

    test "should transform wallet updates into WalletUpdate structs" do
      orig_update = %{"k" => "V"} 
      next_update = %{"X" => "B"}
     
      patch(WalletUpdate, :new, next_update)
  
      data = %{"a" => %{"B" => [orig_update]}}
      BalanceUpdateEvent.new(data)
  
      assert_called_once(WalletUpdate.new(^orig_update))
    end
  
    test "should provide wallet updates in WalletUpdate structs" do
      orig_update = %{"k" => "V"} 
      next_update = %{"X" => "B"}
     
      patch(WalletUpdate, :new, next_update)
  
      data = %{"a" => %{"B" => [orig_update]}}
  
      assert %BalanceUpdateEvent{wallet_updates: [^next_update]} = BalanceUpdateEvent.new(data)
    end

    test "should be tolerant for incorrect wallet update data contract" do
      data = %{"a" => %{"B" => nil}}
      BalanceUpdateEvent.new(data)
    end
  end
end
