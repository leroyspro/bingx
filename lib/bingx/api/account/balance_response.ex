defmodule BingX.API.Account.BalanceResponse do
  import BingX.Helpers, only: [get_and_transform: 3]
  import BingX.API.Interpretators

  alias __MODULE__

  defstruct [
    :asset,
    :available_margin,
    :balance,
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

  @spec new(map()) :: BalanceResponse.t()
  def new(data) do
    %__MODULE__{
      asset: Map.get(data, "asset"),
      available_margin: get_and_transform(data, "availableMargin", &interp_as_float/1),
      balance: get_and_transform(data, "balance", &interp_as_float/1),
      equity: get_and_transform(data, "equity", &interp_as_float/1),
      freezed_margin: get_and_transform(data, "freezedMargin", &interp_as_float/1),
      realized_profit: get_and_transform(data, "realisedProfit", &interp_as_float/1),
      unrealized_profit: get_and_transform(data, "unrealizedProfit", &interp_as_float/1),
      used_margin: get_and_transform(data, "usedMargin", &interp_as_float/1),
      user_id: get_and_transform(data, "userId", &to_string/1)
    }
  end
end
