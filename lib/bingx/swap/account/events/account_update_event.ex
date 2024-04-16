defmodule BingX.Swap.Account.AccountUpdateEvent do
  import BingX.Helpers
  import BingX.Swap.Interpretators

  alias BingX.Swap.Account.{WalletUpdate, PositionUpdate}

  @type update_type :: :order | :funding_fee | :deposit | :withdraw

  @type t :: %__MODULE__{
          type: update_type,
          symbol: binary(),
          timestamp: integer(),
          wallet_updates: list(WalletUpdate.t()),
          position_updates: list(PositionUpdate.t())
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
      symbol: get_and_transform(data, "s", &interp_as_non_empty_binary/1),
      timestamp: Map.get(data, "E"),
      wallet_updates: get_wallet_updates(data),
      position_updates: get_position_updates(data)
    }
  end

  defp get_event_type(%{"a" => %{"m" => type}}) do
    case type do
      "ORDER" -> :order
      "FUNDING_FEE" -> :funding_fee
      "DEPOSIT" -> :deposit
      "WITHDRAW" -> :withdraw
      _ -> nil
    end
  end

  defp get_event_type(_), do: nil

  defp get_position_updates(%{"a" => %{"P" => updates}}) when is_list(updates) do
    Enum.map(updates, &PositionUpdate.new/1)
  end

  defp get_position_updates(_), do: []

  defp get_wallet_updates(%{"a" => %{"B" => updates}}) when is_list(updates) do
    Enum.map(updates, &WalletUpdate.new/1)
  end

  defp get_wallet_updates(_), do: []
end
