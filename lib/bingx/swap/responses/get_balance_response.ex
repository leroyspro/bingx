defmodule BingX.Swap.GetBalanceResponse do
  import BingX.Helpers, only: [get_and_transform: 3]
  import BingX.Interpretators

  defstruct [
    :asset,
    :balance,
    :available_margin,
    :equity,
    :freezed_margin,
    :realized_profit,
    :unrealized_profit,
    :used_margin,
    :user_id,
    :uid
  ]

  @type t() :: %__MODULE__{
          :asset => binary(),
          :available_margin => float(),
          :balance => float(),
          :equity => float(),
          :freezed_margin => float(),
          :realized_profit => float(),
          :unrealized_profit => float(),
          :used_margin => float(),
          :user_id => binary(),
          :uid => binary()
        }

  @spec new(map()) :: t()
  def new(data) do
    data = get_balance(data)

    %__MODULE__{
      asset: get_and_transform(data, "asset", &interp_as_non_empty_binary/1),
      available_margin: get_and_transform(data, "availableMargin", &interp_as_float/1),
      balance: get_and_transform(data, "balance", &interp_as_float/1),
      equity: get_and_transform(data, "equity", &interp_as_float/1),
      freezed_margin: get_and_transform(data, "freezedMargin", &interp_as_float/1),
      realized_profit: get_and_transform(data, "realisedProfit", &interp_as_float/1),
      unrealized_profit: get_and_transform(data, "unrealizedProfit", &interp_as_float/1),
      used_margin: get_and_transform(data, "usedMargin", &interp_as_float/1),
      user_id: get_and_transform(data, "userId", &interp_as_non_empty_binary/1),
      uid: get_and_transform(data, "shortUid", &interp_as_non_empty_binary/1)
    }
  end

  defp get_balance(data) when is_list(data) do
    Enum.find(data, %{}, fn 
      %{"asset" => "USDT"} -> true
      _balance -> false
    end)
  end

  defp get_balance(_data) do
    %{}
  end
end
