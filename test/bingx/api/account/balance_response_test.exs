defmodule BingX.API.Account.BalanceResponseTest do
  use ExUnit.Case

  alias BingX.API.Account.BalanceResponse

  describe "BingX.API.Account.BalanceResponse new/1" do
    test "should return empty struct without params" do
      assert %BalanceResponse{} = BalanceResponse.new(%{})
    end
  end

  describe "BingX.API.Account.BalanceResponse new/1 (transforming)" do
    test "should retrieve asset" do
      assert %BalanceResponse{asset: "BTC-USDT"} = BalanceResponse.new(%{"asset" => "BTC-USDT"})
    end

    test "should retrieve and transform balance into float",
      do: build_transform_assert(:float, :balance, "balance")

    test "should retrieve and transform equity into float",
      do: build_transform_assert(:float, :equity, "equity")

    test "should retrieve and transform available margin into flaot",
      do: build_transform_assert(:float, :available_margin, "availableMargin")

    test "should retrieve and transform freezed margin into float",
      do: build_transform_assert(:float, :freezed_margin, "freezedMargin")

    test "should retrieve and transform realised profit into float",
      do: build_transform_assert(:float, :realized_profit, "realisedProfit")

    test "should retrieve and transform unrealized profit into float",
      do: build_transform_assert(:float, :unrealized_profit, "unrealizedProfit")

    test "should retrieve and transform used margin into float",
      do: build_transform_assert(:float, :used_margin, "usedMargin")

    test "should retrieve and transform user id into binary",
      do: build_transform_assert(:binary, :user_id, "userId")
  end

  describe "BingX.API.Account.BalanceResponse new/1 (omitting)" do
    test "should omit unexpected balance value",
      do: build_omit_assert(:float, :balance, "balance")

    test "should omit unexpected equity value",
      do: build_omit_assert(:float, :equity, "equity")

    test "should omit unexpected available margin value",
      do: build_omit_assert(:float, :available_margin, "availableMargin")

    test "should omit unexpected freezed margin value",
      do: build_omit_assert(:float, :freezed_margin, "freezedMargin")

    test "should omit unexpected realized profit value",
      do: build_omit_assert(:float, :realized_profit, "realisedProfit")

    test "should omit unexpected unrealized profit value",
      do: build_omit_assert(:float, :unrealized_profit, "unrealizedProfit")

    test "should omit unexpected used margin value",
      do: build_omit_assert(:float, :used_margin, "usedMargin")
  end

  defp build_transform_assert(:float, exp_key, orig_key) do
    assert %BalanceResponse{} = %{^exp_key => 24.00001} = BalanceResponse.new(%{orig_key => "24.00001"})
    assert %BalanceResponse{} = %{^exp_key => +0.0} = BalanceResponse.new(%{orig_key => "0.00000"})
    assert %BalanceResponse{} = %{^exp_key => 15.0} = BalanceResponse.new(%{orig_key => "15"})
    assert %BalanceResponse{} = %{^exp_key => 1.0} = BalanceResponse.new(%{orig_key => 1.0})
  end

  defp build_transform_assert(:binary, exp_key, orig_key) do
    assert %BalanceResponse{} = %{^exp_key => "24000"} = BalanceResponse.new(%{orig_key => "24000"})
    assert %BalanceResponse{} = %{^exp_key => "uuid"} = BalanceResponse.new(%{orig_key => "uuid"})
    assert %BalanceResponse{} = %{^exp_key => "24.0"} = BalanceResponse.new(%{orig_key => 24.0})
    assert %BalanceResponse{} = %{^exp_key => "2121"} = BalanceResponse.new(%{orig_key => 2121})
  end

  defp build_omit_assert(:float, exp_key, orig_key) do
    assert %BalanceResponse{} = %{^exp_key => 1.0} = BalanceResponse.new(%{orig_key => 1.0})
    assert %BalanceResponse{} = %{^exp_key => nil} = BalanceResponse.new(%{orig_key => "null"})
    assert %BalanceResponse{} = %{^exp_key => nil} = BalanceResponse.new(%{orig_key => ""})
    assert %BalanceResponse{} = %{^exp_key => nil} = BalanceResponse.new(%{orig_key => nil})
  end
end
