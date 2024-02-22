defmodule BingX.Order.Helpers do
  alias BingX.Order

  @sides [:buy, :sell]
  @position_sides [:short, :long, :both]
  @types [:trigger_market]
  @working_types [:index_price, :mark_price, :contract_price]

  def validate!(key, value) do
    case validate(key, value) do
      {:ok, value} -> value
      {:error, reason} -> raise ArgumentError, reason
    end
  end

  @spec validate(:order_id, any()) :: {:ok, Order.order_id()} | {:error, binary()}
  def validate(:order_id, x) when is_binary(x), do: {:ok, x}

  def validate(:order_id, x) do
    reason = "expected :order_id to be given and be binary type, got: #{inspect(x)}"
    {:error, reason}
  end

  @spec validate(:symbol, any()) :: {:ok, Order.symbol()} | {:error, binary()}
  def validate(:symbol, x) when is_binary(x), do: {:ok, x}

  def validate(:symbol, x) do
    reason = "expected :symbol to be given and be binary type, got: #{inspect(x)}"
    {:error, reason}
  end

  @spec validate(:side, any()) :: {:ok, Order.side()} | {:error, binary()}
  def validate(:side, x) when x in @sides, do: {:ok, x}

  def validate(:side, x) do
    reason = "expected :side to be given and be one of #{inspect(@sides)}, got: #{inspect(x)}"
    {:error, reason}
  end

  @spec validate(:position_side, any()) :: {:ok, Order.position_side()} | {:error, binary()}
  def validate(:position_side, x) when x in @position_sides, do: {:ok, x}

  def validate(:position_side, x) do
    reason =
      "expected :position_side to be given and be one of #{inspect(@position_sides)}, got: #{inspect(x)}"

    {:error, reason}
  end

  @spec validate(:type, any()) :: {:ok, Order.type()} | {:error, binary()}
  def validate(:type, x) when x in @types, do: {:ok, x}

  def validate(:type, x) do
    reason = "expected :type to be given and be one of #{inspect(@types)}, got: #{inspect(x)}"

    {:error, reason}
  end

  @spec validate(:price, any()) :: {:ok, Order.price()} | {:error, binary()}
  def validate(:price, x) when is_number(x), do: {:ok, x}

  def validate(:price, x) do
    reason = "expected :price to be given and be number type, got: #{inspect(x)}"

    {:error, reason}
  end

  @spec validate(:stop_price, any()) :: {:ok, Order.stop_price()} | {:error, binary()}
  def validate(:stop_price, x) when is_number(x), do: {:ok, x}

  def validate(:stop_price, x) do
    reason = "expected :stop_price to be given and be number type, got: #{inspect(x)}"

    {:error, reason}
  end

  @spec validate(:quantity, any()) :: {:ok, Order.quantity()} | {:error, binary()}
  def validate(:quantity, x) when is_number(x), do: {:ok, x}

  def validate(:quantity, x) do
    reason = "expected :quantity to be given and be number type, got: #{inspect(x)}"

    {:error, reason}
  end

  @spec validate(:working_type, any()) :: {:ok, Order.working_type()} | {:error, binary()}
  def validate(:working_type, x) when x in @working_types, do: {:ok, x}

  def validate(:working_type, x) do
    reason =
      "expected :working_type to be given and be one of #{inspect(@working_types)}, got: #{inspect(x)}"

    {:error, reason}
  end

  @spec validate(:client_order_id, any()) :: {:ok, Order.client_order_id()} | {:error, binary()}
  def validate(:client_order_id, x) when is_binary(x), do: {:ok, x}

  def validate(:client_order_id, x) do
    reason = "expected :client_order_id to be given and be binary type, got: #{inspect(x)}"

    {:error, reason}
  end
end
