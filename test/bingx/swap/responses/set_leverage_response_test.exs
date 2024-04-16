defmodule Bingx.Swap.SetLeverageResponseTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.Swap.SetLeverageResponse

  @fields [
    :symbol,
    :available_long_margin,
    :available_long_usdt_margin,
    :max_long_usdt_margin,
    :available_short_margin,
    :available_short_usdt_margin,
    :max_short_usdt_margin
  ]

  # symbol: get_and_transform(data, "symbol", &interp_as_non_empty_binary/1),
  # available_long_margin: get_and_transform(data, "availableLongVol", &interp_as_float/1),
  # available_long_usdt_margin: get_and_transform(data, "availableLongVal", &interp_as_float/1),
  # available_short_margin: get_and_transform(data, "availableShortVol", &interp_as_float/1),
  # available_short_usdt_margin: get_and_transform(data, "availableShortVal", &interp_as_float/1),
  # max_long_usdt_margin: get_and_transform(data, "maxPositionLongVal", &interp_as_float/1),
  # max_short_usdt_margin: get_and_transform(data, "maxPositionShortVal", &interp_as_float/1)

  describe "BingX.Swap.SetLeverageResponseTest new/1" do
    test "should return empty struct without params" do
      assert %SetLeverageResponse{} = SetLeverageResponse.new(%{})
    end

    test_module_struct(SetLeverageResponse, @fields)

    test "should be tolerant to wrong data contract" do
      assert %SetLeverageResponse{} = SetLeverageResponse.new(%{"x" => "x"})
    end

    test_response_key_interp(SetLeverageResponse, :new, [], :interp_as_non_empty_binary, "symbol", :symbol)
    test_response_key_interp(SetLeverageResponse, :new, [], :interp_as_float, "availableLongVol", :available_long_margin)
    test_response_key_interp(SetLeverageResponse, :new, [], :interp_as_float, "availableLongVal", :available_long_usdt_margin)
    test_response_key_interp(SetLeverageResponse, :new, [], :interp_as_float, "availableShortVol", :available_short_margin)
    test_response_key_interp(SetLeverageResponse, :new, [], :interp_as_float, "availableShortVal", :available_short_usdt_margin)
    test_response_key_interp(SetLeverageResponse, :new, [], :interp_as_float, "maxPositionLongVal", :max_long_usdt_margin)
    test_response_key_interp(SetLeverageResponse, :new, [], :interp_as_float, "maxPositionShortVal", :max_short_usdt_margin)
  end
end
