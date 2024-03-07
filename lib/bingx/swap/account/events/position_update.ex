defmodule BingX.Swap.Account.PositionUpdate do
  import BingX.Helpers
  import BingX.Swap.Interpretators

  @type t :: %{
    pair: binary() | nil,
    position_side: BingX.Swap.Order.position_side() | nil,
    position_amount: float() | nil,
    position_margin: float() | nil,
    entry_price: float() | nil,
    unrealized_pnl: float() | nil,
    margin_mode: :cross | :isolated | nil
  }

  defstruct [
    :pair,
    :position_side,
    :position_amount,
    :position_margin,
    :entry_price,
    :unrealized_pnl,
    :margin_mode
  ]

  def new(data) do
    %__MODULE__{
      pair: get_and_transform(data, "s", &interp_as_non_empty_binary/1),
      position_side: get_and_transform(data, "ps", &to_internal_position_side/1),
      position_amount: get_and_transform(data, "iw", &interp_as_float/1),
      position_margin: get_and_transform(data, "pa", &interp_as_float/1),
      entry_price: get_and_transform(data, "ep", &interp_as_float/1),
      unrealized_pnl: get_and_transform(data, "up", &interp_as_float/1),
      margin_mode: get_and_transform(data, "mt", &to_internal_margin_mode/1)
    }
  end
end
