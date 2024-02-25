defmodule BingX.API.Interpretators do
  alias BingX.Helpers

  def interp_order_id(x) when is_number(x), do: to_string(x)
  def interp_order_id(_), do: nil

  def interp_order_type(x) when is_binary(x) do
    case Helpers.upcase(x) do
      "MARKET" -> :market
      "TRIGGER_MARKET" -> :trigger_market
      "STOP" -> :stop_loss
      "TAKE_PROFIT" -> :take_profit
      "LIMIT" -> :limit
      "STOP_MARKET" -> :stop_loss_market
      "TAKE_PROFIT_MARKET" -> :take_profit_market
      _ -> nil
    end
  end
  def interp_order_type(_), do: nil

  def interp_order_status(x) when is_binary(x) do
    case Helpers.upcase(x) do
      "NEW" -> :placed
      "TRIGGERED" -> :triggered
      _ -> nil
    end
  end
  def interp_order_status(_), do: nil

  def interp_position_side(x) when is_binary(x) do
    case Helpers.upcase(x) do
      "LONG" -> :long
      "SHORT" -> :short
      "BOTH" -> :both
      _ -> nil
    end
  end
  def interp_position_side(_), do: nil

  def interp_order_side(x) when is_binary(x) do
    case Helpers.upcase(x) do
      "BUY" -> :buy
      "SELL" -> :sell
      _ -> nil
    end
  end
  def interp_order_side(_), do: nil

  def interp_as_float(x) when is_binary(x) do
    case Float.parse(x) do
      :error -> nil
      {x, _} -> x
    end
  end
  def interp_as_float(_), do: nil
end
