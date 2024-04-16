defmodule BingX.Swap.Account.PositionUpdate do
  import BingX.Helpers
  import BingX.Swap.Interpretators

  @type t :: %{
          symbol: binary() | nil,
          side: BingX.Swap.Order.position_side() | nil,
          value: float() | nil,
          margin: float() | nil,
          average_price: float() | nil,
          unrealized_pnl: float() | nil,
          margin_mode: :cross | :isolated | nil
        }

  defstruct [
    :symbol,
    :side,
    :value,
    :margin,
    :average_price,
    :unrealized_pnl,
    :margin_mode
  ]

  def new(data) do
    %__MODULE__{
      symbol: get_and_transform(data, "s", &interp_as_non_empty_binary/1),
      side: get_and_transform(data, "ps", &to_internal_position_side/1),
      value: get_and_transform(data, "iw", &interp_as_float/1),
      margin: get_and_transform(data, "pa", &interp_as_float/1),
      average_price: get_and_transform(data, "ep", &interp_as_float/1),
      unrealized_pnl: get_and_transform(data, "up", &interp_as_float/1),
      margin_mode: get_and_transform(data, "mt", &to_internal_margin_mode/1)
    }
  end
end
