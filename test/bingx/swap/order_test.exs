defmodule BingX.Swap.OrderTest do
  use ExUnit.Case, async: true

  alias BingX.Swap.Order

  describe "BingX.Order new/1" do
    test "should create a struct without params" do
      assert {:ok, %Order{}} = Order.new(%{})
    end

    test "should create a struct with all params" do
      assert {:ok,
              %Order{
                :type => :market,
                :order_id => "123214124312",
                :client_order_id => "supra",
                :symbol => "BTC-USDT",
                :side => :sell,
                :position_side => :short,
                :quantity => 0.1,
                :price => 324.11,
                :stop_price => 321,
                :working_type => :contract_price
              }} =
               Order.new(%{
                 :type => :market,
                 :order_id => "123214124312",
                 :client_order_id => "supra",
                 :symbol => "BTC-USDT",
                 :side => :sell,
                 :position_side => :short,
                 :quantity => 0.1,
                 :price => 324.11,
                 :stop_price => 321,
                 :working_type => :contract_price
               })
    end

    test "should validate :type key to be one of :market or :trigger_market if provided",
      do: build_error_assert(:type, :oneof, [:market, :trigger_market])

    test "should validate :order_id key to be binary() if provided",
      do: build_error_assert(:order_id, :binary)

    test "should validate :client_order_id key to be binary() if provided",
      do: build_error_assert(:client_order_id, :binary)

    test "should validate :symbol key to be binary() if provided",
      do: build_error_assert(:symbol, :binary)

    test "should validate :side key to be one of :sell or :buy if provided",
      do: build_error_assert(:side, :oneof, [:buy, :sell])

    test "should validate :position_side key to be one of :short, :long or :both if provided",
      do: build_error_assert(:position_side, :oneof, [:short, :long, :both])

    test "should validate :quantity key to be number() if provided",
      do: build_error_assert(:quantity, :number)

    test "should validate :price key to be number() if provided",
      do: build_error_assert(:price, :number)

    test "should validate :stop_price key to be number() if provided",
      do: build_error_assert(:stop_price, :number)

    test "should validate :working_type key to be one of :index_price, :mark_price or :contract_price if provided",
      do: build_error_assert(:working_type, :oneof, [:index_price, :mark_price, :contract_price])

    # Asserts
    # =======

    def build_error_assert(key, :binary) do
      {:ok, struct} = Order.new(%{key => "hellow"})
      do_key_presence_assert(struct, key)

      message = make_error_message(key, :binary, :unknown)
      assert {:error, ^message} = Order.new(%{key => :unknown})
    end

    def build_error_assert(key, :number) do
      {:ok, struct} = Order.new(%{key => 120_480_000})
      do_key_presence_assert(struct, key)

      message = make_error_message(key, :number, :unknown)
      assert {:error, ^message} = Order.new(%{key => :unknown})
    end

    def build_error_assert(key, :oneof, valid_values) do
      Enum.map(valid_values, fn val ->
        assert %Order{} = %{^key => ^val} = Order.new!(%{key => val})
      end)

      message = make_error_message(key, :oneof, valid_values, :unknown)
      assert {:error, ^message} = Order.new(%{key => :unknown})
    end
  end

  describe "BingX.Order new!/1" do
    test "should create a struct without params" do
      assert %Order{} = Order.new!(%{})
    end

    test "should create a struct with all params" do
      assert %Order{
               :type => :market,
               :order_id => "123214124312",
               :client_order_id => "supra",
               :symbol => "BTC-USDT",
               :side => :sell,
               :position_side => :short,
               :quantity => 0.1,
               :price => 324.11,
               :stop_price => 321,
               :working_type => :contract_price
             } =
               Order.new!(%{
                 :type => :market,
                 :order_id => "123214124312",
                 :client_order_id => "supra",
                 :symbol => "BTC-USDT",
                 :side => :sell,
                 :position_side => :short,
                 :quantity => 0.1,
                 :price => 324.11,
                 :stop_price => 321,
                 :working_type => :contract_price
               })
    end

    test "should validate :type key to be one of :market or :trigger_market if provided",
      do: build_raised_error_assert(:type, :oneof, [:market, :trigger_market])

    test "should validate :order_id key to be binary() if provided",
      do: build_raised_error_assert(:order_id, :binary)

    test "should validate :client_order_id key to be binary() if provided",
      do: build_raised_error_assert(:client_order_id, :binary)

    test "should validate :symbol key to be binary() if provided",
      do: build_raised_error_assert(:symbol, :binary)

    test "should validate :side key to be one of :sell or :buy if provided",
      do: build_raised_error_assert(:side, :oneof, [:buy, :sell])

    test "should validate :position_side key to be one of :short, :long or :both if provided",
      do: build_raised_error_assert(:position_side, :oneof, [:short, :long, :both])

    test "should validate :quantity key to be number() if provided",
      do: build_raised_error_assert(:quantity, :number)

    test "should validate :price key to be number() if provided",
      do: build_raised_error_assert(:price, :number)

    test "should validate :stop_price key to be number() if provided",
      do: build_raised_error_assert(:stop_price, :number)

    test "should validate :working_type key to be one of :index_price, :mark_price or :contract_price if provided",
      do: build_raised_error_assert(:working_type, :oneof, [:index_price, :mark_price, :contract_price])

    # Asserts
    # =======

    def build_raised_error_assert(key, :binary) do
      struct = Order.new!(%{key => "wazuuuuup"})
      do_key_presence_assert(struct, key)

      message = make_error_message(key, :binary, :unknown)
      assert_raise ArgumentError, message, fn -> Order.new!(%{key => :unknown}) end
    end

    def build_raised_error_assert(key, :number) do
      struct = Order.new!(%{key => 120_540_000})
      do_key_presence_assert(struct, key)

      message = make_error_message(key, :number, :unknown)
      assert_raise ArgumentError, message, fn -> Order.new!(%{key => :unknown}) end
    end

    def build_raised_error_assert(key, :oneof, valid_values) do
      Enum.map(valid_values, fn val ->
        assert %Order{} = %{^key => ^val} = Order.new!(%{key => val})
      end)

      message = make_error_message(key, :oneof, valid_values, :unknown)
      assert_raise ArgumentError, message, fn -> Order.new!(%{key => :unknown}) end
    end
  end

  def do_key_presence_assert(struct, key) do
    assert %Order{} = struct
    assert Map.has_key?(struct, key)
  end

  def make_error_message(key, :binary, value) do
    "expected #{inspect(key)} to be type of binary, got: #{inspect(value)}"
  end

  def make_error_message(key, :number, value) do
    "expected #{inspect(key)} to be type of number, got: #{inspect(value)}"
  end

  def make_error_message(key, :oneof, valid_values, value) do
    "expected #{inspect(key)} to be one of #{inspect(valid_values)}, got: #{inspect(value)}"
  end
end
