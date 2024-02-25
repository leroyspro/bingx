defmodule BingX.API.OrderTest do
  use ExUnit.Case
  use Patch

  alias BingX.Order

  describe "BingX.Order new/1" do
    test "should create struct without params" do
      assert %Order{} = Order.new(%{})
    end

    test "should create struct with all params" do
      assert %Order{
        :type => :market,
        :order_id => "123214124312",
        :symbol => "BTC-USDT",
        :side => :sell,
        :position_side => :short,
        :price => 324.11,
        :stop_price => 321,
        :quantity => 0.1,
        :client_order_id => "supra",
        :working_type => :contract_price
      } = Order.new(%{
        :type => :market,
        :order_id => "123214124312",
        :symbol => "BTC-USDT",
        :side => :sell,
        :position_side => :short,
        :price => 324.11,
        :stop_price => 321,
        :quantity => 0.1,
        :client_order_id => "supra",
        :working_type => :contract_price
      })
    end

    test "should validate :working_type key" do
      assert %Order{working_type: :mark_price} = Order.new(%{working_type: :mark_price})
      assert %Order{working_type: :index_price} = Order.new(%{working_type: :index_price})
      assert %Order{working_type: :contract_price} = Order.new(%{working_type: :contract_price})

      assert_raise ArgumentError,
                   "expected :working_type to be one of [:index_price, :mark_price, :contract_price], got: :unknown",
                   fn -> Order.new(%{working_type: :unknown}) end
    end

    test "should validate :type key" do
      assert %Order{type: :trigger_market} = Order.new(%{type: :trigger_market})

      assert_raise ArgumentError,
                   "expected :type to be one of [:market, :trigger_market], got: :unknown",
                   fn -> Order.new(%{type: :unknown}) end
    end

    test "should validate :side key" do
      assert %Order{side: :buy} = Order.new(%{side: :buy})
      assert %Order{side: :sell} = Order.new(%{side: :sell})

      assert_raise ArgumentError,
                   "expected :side to be one of [:buy, :sell], got: :unknown",
                   fn -> Order.new(%{side: :unknown}) end
    end

    test "should validate :position_side key" do
      assert %Order{position_side: :long} = Order.new(%{position_side: :long})
      assert %Order{position_side: :short} = Order.new(%{position_side: :short})
      assert %Order{position_side: :both} = Order.new(%{position_side: :both})

      assert_raise ArgumentError,
                   "expected :position_side to be one of [:short, :long, :both], got: :unknown",
                   fn -> Order.new(%{position_side: :unknown}) end
    end

    test "should validate :order_id key", do: build_assert(:order_id, :binary)

    test "should validate :client_order_id key", do: build_assert(:client_order_id, :binary)

    test "should validate :symbol key", do: build_assert(:symbol, :binary)

    test "should validate :price key", do: build_assert(:price, :number)

    test "should validate :stop_price key", do: build_assert(:stop_price, :number)

    test "should validate :quantity key", do: build_assert(:quantity, :number)

    def build_assert(key, :number) do
      struct = Order.new(%{key => 3_423_432})

      assert %Order{} = struct
      assert Map.has_key?(struct, key)

      assert_raise ArgumentError,
                   "expected #{inspect(key)} to be type of number, got: :unknown",
                   fn -> Order.new(%{key => :unknown}) end
    end

    def build_assert(key, :binary) do
      struct = Order.new(%{key => "uiow"})

      assert %Order{} = struct
      assert Map.has_key?(struct, key)

      assert_raise ArgumentError,
                   "expected #{inspect(key)} to be type of binary, got: :unknown",
                   fn -> Order.new(%{key => :unknown}) end
    end
  end
end
