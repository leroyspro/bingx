defmodule BingX.Swap.SetLeverageResponse do
  import BingX.Helpers, only: [get_and_transform: 3]
  import BingX.Interpretators

  defstruct [
    :symbol,
    :available_long_margin,
    :available_long_usdt_margin,
    :max_long_usdt_margin,
    :available_short_margin,
    :available_short_usdt_margin,
    :max_short_usdt_margin
  ]

  @type t() :: %__MODULE__{
          symbol: binary(),
          available_long_margin: float() | nil,
          available_long_usdt_margin: float() | nil,
          available_short_margin: float() | nil,
          available_short_usdt_margin: float() | nil,
          max_long_usdt_margin: float() | nil,
          max_short_usdt_margin: float() | nil
        }

  @spec new(map()) :: SetLeverageResponse.t()
  def new(data) do
    %__MODULE__{
      symbol: get_and_transform(data, "symbol", &interp_as_non_empty_binary/1),
      available_long_margin: get_and_transform(data, "availableLongVol", &interp_as_float/1),
      available_long_usdt_margin: get_and_transform(data, "availableLongVal", &interp_as_float/1),
      available_short_margin: get_and_transform(data, "availableShortVol", &interp_as_float/1),
      available_short_usdt_margin: get_and_transform(data, "availableShortVal", &interp_as_float/1),
      max_long_usdt_margin: get_and_transform(data, "maxPositionLongVal", &interp_as_float/1),
      max_short_usdt_margin: get_and_transform(data, "maxPositionShortVal", &interp_as_float/1)
    }
  end
end
