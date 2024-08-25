defmodule BingX.Swap.Account.ConfigUpdateEvent do
  import BingX.Helpers
  import BingX.Interpretators

  defstruct [
    :symbol,
    :timestamp,
    :margin_mode,
    :short_leverage,
    :long_leverage
  ]

  @type t :: %__MODULE__{
          symbol: binary() | nil,
          timestamp: integer(),
          margin_mode: :crossed,
          short_leverage: float() | nil,
          long_leverage: float() | nil
        }

  def new(data) do
    timestamp = Map.get(data, "E")
    config = Map.get(data, "ac", %{})

    %__MODULE__{
      timestamp: timestamp,
      symbol: get_and_transform(config, "s", &interp_as_non_empty_binary/1),
      margin_mode: get_and_transform(config, "mt", &to_internal_margin_mode/1),
      short_leverage: get_and_transform(config, "S", &interp_as_float/1),
      long_leverage: get_and_transform(config, "l", &interp_as_float/1)
    }
  end
end
