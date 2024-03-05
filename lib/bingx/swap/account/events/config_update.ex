defmodule BingX.Swap.Account.Events.ConfigUpdate do
  import BingX.Helpers
  import BingX.Swap.Interpretators

  defstruct [
    :symbol,
    :timestamp,
    :margin_mode,
    :short_leverage,
    :long_leverage
  ]

  def new(%{"E" => timestamp, "ac" => data}) do
    %__MODULE__{
      timestamp: timestamp,
      symbol: Map.get(data, "s"),
      margin_mode: get_and_transform(data, "mt", &to_internal_margin_mode/1),
      short_leverage: get_and_transform(data, "S", &interp_as_float/1),
      long_leverage: get_and_transform(data, "l", &interp_as_float/1)
    }
  end
end
