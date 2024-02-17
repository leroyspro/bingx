defmodule BingX.Trade.Order.Helpers do
  def validate_param(params, :order_id) do
    {:ok, Map.get(params, :order_id)}
  end

  def validate_param(params, :symbol) do
    case Map.get(params, :symbol) do
      x when is_binary(x) -> {:ok, x}
      _ -> {:error, "invalid :symbol param"}
    end
  end

  def validate_param(params, :side) do
    case Map.get(params, :side) do
      x when is_binary(x) -> {:ok, x}
      _ -> {:error, "invalid :side param"}
    end
  end

  def validate_param(params, :position_side) do
    case Map.get(params, :position_side) do
      x when is_binary(x) -> {:ok, x}
      _ -> {:error, "invalid :position_side param"}
    end
  end

  def validate_param(params, :type) do
    case Map.get(params, :type) do
      x when is_binary(x) -> {:ok, x}
      _ -> {:error, "invalid :type param"}
    end
  end

  def validate_param(params, :price) do
    case Map.get(params, :price) do
      x when is_number(x) -> {:ok, x}
      _ -> {:error, "invalid :price param"}
    end
  end

  def validate_param(params, :stop_price) do
    case Map.get(params, :stop_price) do
      x when is_number(x) -> {:ok, x}
      _ -> {:error, "invalid :stop_price param"}
    end
  end

  def validate_param(params, :quantity) do
    case Map.get(params, :quantity) do
      x when is_number(x) -> {:ok, x}
      _ -> {:error, "invalid :quantity param"}
    end
  end
end
