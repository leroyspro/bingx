defmodule BingX.Swap.GetBalanceResponseTest do
  use ExUnit.Case, async: true

  import BingX.Support.Struct

  alias BingX.Swap.GetBalanceResponse

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
  end

  describe "BingX.Swap.GetBalanceResponse new/1 (transforming)" do
    test "should retrieve asset" do
      assert %GetBalanceResponse{asset: "BTC-USDT"} = GetBalanceResponse.new(wrap_data(%{"asset" => "BTC-USDT"}))
    end

    test "should be tolerant to wrong interface" do
      assert %GetBalanceResponse{} = GetBalanceResponse.new(%{"x" => "x"})
    end

    test "should retrieve and transform balance into float if not empty",
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

  describe "BingX.API.Account.GetBalanceResponse new/1 (omitting)" do
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
    assert %GetBalanceResponse{} = %{^exp_key => 24.00001} = GetBalanceResponse.new(wrap_data(%{orig_key => "24.00001"}))
    assert %GetBalanceResponse{} = %{^exp_key => +0.0} = GetBalanceResponse.new(wrap_data(%{orig_key => "0.00000"}))
    assert %GetBalanceResponse{} = %{^exp_key => 15.0} = GetBalanceResponse.new(wrap_data(%{orig_key => "15"}))
    assert %GetBalanceResponse{} = %{^exp_key => 1.0} = GetBalanceResponse.new(wrap_data(%{orig_key => 1.0}))
  end

  defp build_transform_assert(:binary, exp_key, orig_key) do
    assert %GetBalanceResponse{} = %{^exp_key => "24000"} = GetBalanceResponse.new(wrap_data(%{orig_key => "24000"}))
    assert %GetBalanceResponse{} = %{^exp_key => "uuid"} = GetBalanceResponse.new(wrap_data(%{orig_key => "uuid"}))
    assert %GetBalanceResponse{} = %{^exp_key => "24.0"} = GetBalanceResponse.new(wrap_data(%{orig_key => 24.0}))
    assert %GetBalanceResponse{} = %{^exp_key => "2121"} = GetBalanceResponse.new(wrap_data(%{orig_key => 2121}))
  end

  defp build_omit_assert(:float, exp_key, orig_key) do
    assert %GetBalanceResponse{} = %{^exp_key => 1.0} = GetBalanceResponse.new(wrap_data(%{orig_key => 1.0}))
    assert %GetBalanceResponse{} = %{^exp_key => nil} = GetBalanceResponse.new(wrap_data(%{orig_key => "null"}))
    assert %GetBalanceResponse{} = %{^exp_key => nil} = GetBalanceResponse.new(wrap_data(%{orig_key => ""}))
    assert %GetBalanceResponse{} = %{^exp_key => nil} = GetBalanceResponse.new(wrap_data(%{orig_key => nil}))
  end

  defp wrap_data(data), do: %{"balance" => data}
end
