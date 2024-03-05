defmodule BingX.Swap.Account.BalanceUpdateEvent do
  import BingX.Helpers
  import BingX.Swap.Interpretators

  @type update_type :: :order | :funding_fee | :deposit | :withdraw

  @type wallet_update :: %{
    asset: binary() | nil,
    balance_change: float() | nil,
    available_balance: float() | nil,
    balance: float() | nil
  }

  @type position_update :: %{
    pair: binary() | nil,
    position_side: BingX.Swap.Order.position_side() | nil,
    position_amount: float() | nil,
    position_margin: float() | nil,
    entry_price: float() | nil,
    unrealized_pnl: float() | nil,
    margin_mode: :cross | :isolated | nil
  }

  @type t :: %__MODULE__{
    type: update_type,
    symbol: binary(),
    timestamp: integer(),
    wallet_updates: list(wallet_update),
    position_updates: list(position_update) 
  }

  defstruct [
    :type,
    :symbol,
    :timestamp,
    :wallet_updates,
    :position_updates
  ]

  @spec new(map()) :: t()
  def new(data) do
    %__MODULE__{
      type: get_event_type(data),
      symbol: Map.get(data, "s"),
      timestamp: Map.get(data, "E"),
      wallet_updates: get_wallet_updates(data),
      position_updates: get_position_updates(data),
    }
  end

  defp get_event_type(%{"a" => %{"m" => type}}) do
    case type do
      "ORDER" -> :order
      "FUNDING_FEE" -> :funding_fee
      "DEPOSIT" -> :deposit
      "WITHDRAW" -> :withdraw
    end
  end

  defp get_event_type(_), do: nil

  defp get_position_updates(%{"a" => %{"P" => updates}}) do
    Enum.map(updates, &transform_position_update/1)
  end

  defp transform_position_update(data) do
    %{
      pair: Map.get(data, "s"),
      position_side: get_and_transform(data, "ps", &to_internal_position_side/1),
      position_amount: get_and_transform(data, "iw", &interp_as_float/1),
      position_margin: get_and_transform(data, "pa", &interp_as_float/1),
      entry_price: get_and_transform(data, "ep", &interp_as_float/1),
      unrealized_pnl: get_and_transform(data, "up", &interp_as_float/1),
      margin_mode: get_and_transform(data, "mt", &to_internal_margin_mode/1)
    }
  end

  defp get_wallet_updates(%{"a" => %{"B" => updates}}) do
    Enum.map(updates, &transform_wallet_update/1)
  end

  defp transform_wallet_update(data) do
    %{
      asset: Map.get(data, "a"),
      balance_change: get_and_transform(data, "bc", &interp_as_float/1),
      balance: get_and_transform(data, "cw", &interp_as_float/1),
      total_balance: get_and_transform(data, "wb", &interp_as_float/1)
    }
  end
end
