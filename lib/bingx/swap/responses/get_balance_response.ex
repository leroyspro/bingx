defmodule BingX.Swap.GetBalanceResponse do
  import BingX.Helpers, only: [get_and_transform: 3]
  import BingX.Swap.Interpretators

  defstruct [
    :asset,
    :balance,
    :available_margin,
    :equity,
    :freezed_margin,
    :realized_profit,
    :unrealized_profit,
    :used_margin,
    :user_id
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
          :user_id => binary()
        }

  @spec new(map()) :: Balance.t()
  def new(data) do
    data = Map.get(data, "balance", %{})

    %__MODULE__{
      asset: get_and_transform(data, "asset", &interp_as_binary(&1, empty?: false)),
      available_margin: get_and_transform(data, "availableMargin", &interp_as_float/1),
      balance: get_and_transform(data, "balance", &interp_as_float/1),
      equity: get_and_transform(data, "equity", &interp_as_float/1),
      freezed_margin: get_and_transform(data, "freezedMargin", &interp_as_float/1),
      realized_profit: get_and_transform(data, "realisedProfit", &interp_as_float/1),
      unrealized_profit: get_and_transform(data, "unrealizedProfit", &interp_as_float/1),
      used_margin: get_and_transform(data, "usedMargin", &interp_as_float/1),
      user_id: get_and_transform(data, "userId", &interp_as_binary(&1, empty?: false))
    }
  end
end
