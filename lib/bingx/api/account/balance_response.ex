defmodule BingX.API.Account.BalanceResponse do
  import BingX.Helpers, only: [to_float!: 1]

  alias __MODULE__

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

  @spec new(map()) :: BalanceResponse.t()
  def new(%{
        "asset" => asset,
        "availableMargin" => available_margin,
        "balance" => balance,
        "equity" => equity,
        "freezedMargin" => freezed_margin,
        "realisedProfit" => realized_profit,
        "unrealizedProfit" => unrealized_profit,
        "usedMargin" => used_margin,
        "userId" => user_id
      }) do
    %__MODULE__{
      asset: asset,
      available_margin: to_float!(available_margin),
      balance: to_float!(balance),
      equity: to_float!(equity),
      freezed_margin: to_float!(freezed_margin),
      realized_profit: to_float!(realized_profit),
      unrealized_profit: to_float!(unrealized_profit),
      used_margin: to_float!(used_margin),
      user_id: user_id
    }
  end
end
