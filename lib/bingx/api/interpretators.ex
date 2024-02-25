defmodule BingX.API.Interpretators do
  alias BingX.Helpers

  def to_internal_order_id(x) when is_number(x), do: to_string(x)
  def to_internal_order_id(_), do: nil

  def to_internal_order_type(x) when is_binary(x) do
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

  def to_internal_order_type(_), do: nil

  def to_external_order_type(:market), do: "MARKET"
  def to_external_order_type(:trigger_market), do: "TRIGGER_MARKET"
  def to_external_order_type(:stop_loss), do: "STOP"
  def to_external_order_type(:take_profit), do: "TAKE_PROFIT"
  def to_external_order_type(:limit), do: "LIMIT"
  def to_external_order_type(:stop_loss_market), do: "STOP_MARKET"
  def to_external_order_type(:take_profit_market), do: "TAKE_PROFIT_MARKET"

  def to_internal_order_status(x) when is_binary(x) do
    case Helpers.upcase(x) do
      "NEW" -> :placed
      "TRIGGERED" -> :triggered
      _ -> nil
    end
  end

  def to_internal_order_status(_), do: nil

  def to_external_order_status(:placed), do: "NEW"
  def to_external_order_status(:triggered), do: "TRIGGERED"

  def to_internal_position_side(x) when is_binary(x) do
    case Helpers.upcase(x) do
      "LONG" -> :long
      "SHORT" -> :short
      "BOTH" -> :both
      _ -> nil
    end
  end

  def to_internal_position_side(_), do: nil

  def to_external_position_side(:long), do: "LONG"
  def to_external_position_side(:short), do: "SHORT"
  def to_external_position_side(:both), do: "BOTH"

  def inter_order_side(x) when is_binary(x) do
    case Helpers.upcase(x) do
      "BUY" -> :buy
      "SELL" -> :sell
      _ -> nil
    end
  end

  def to_internal_order_side(_), do: nil

  def to_external_order_side(:buy), do: "BUY"
  def to_external_order_side(:sell), do: "SELL"

  def to_internal_working_type(x) when is_binary(x) do
    case Helpers.upcase(x) do
      "INDEX_PRICE" -> :index_price
      "MARK_PRICE" -> :mark_price
      "CONTRACT_PRICE" -> :contract_price
      _ -> nil
    end
  end

  def to_external_working_type(:index_price), do: "INDEX_PRICE"
  def to_external_working_type(:mark_price), do: "MARK_PRICE"
  def to_external_working_type(:contract_price), do: "CONTRACT_PRICE"

  def interp_as_float(x) when is_binary(x) do
    case Float.parse(x) do
      :error -> nil
      {x, _} -> x
    end
  end

  def interp_as_float(_), do: nil
end
