defmodule BingX.Swap.Account.WalletUpdate do
  import BingX.Helpers
  import BingX.Interpretators

  @type t :: %{
          asset: binary() | nil,
          balance_change: float() | nil,
          available_balance: float() | nil,
          balance: float() | nil
        }

  defstruct [
    :asset,
    :balance_change,
    :available_balance,
    :balance
  ]

  def new(data) do
    %__MODULE__{
      asset: get_and_transform(data, "a", &interp_as_non_empty_binary/1),
      balance_change: get_and_transform(data, "bc", &interp_as_float/1),
      available_balance: get_and_transform(data, "wb", &interp_as_float/1),
      balance: get_and_transform(data, "cw", &interp_as_float/1)
    }
  end
end
