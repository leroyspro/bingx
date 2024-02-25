defmodule BingX.API.Account.BalanceResponse do
  import BingX.Helpers

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
      asset: Map.get(data, :asset),
      available_margin: get_and_transform(data, "availableMargin", &to_float!/1),
      balance: get_and_transform(data, "balance", &to_float!/1),
      equity: get_and_transform(data, "equity", &to_float!/1),
      freezed_margin: get_and_transform(data, "freezedMargin", &to_float!/1),
      realized_profit: get_and_transform(data, "realisedProfit", &to_float!/1),
      unrealized_profit: get_and_transform(data, "unrealisedProfit", &to_float!/1),
      used_margin: get_and_transform(data, "usedMargin", &to_float!/1),
      user_id: get_and_transform(data, "userId", &to_string/1)
    }
  end
end
