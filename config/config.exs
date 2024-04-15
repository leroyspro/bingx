import Config

config :bingx,
  origin: "https://open-api.bingx.com",
  swap_origin: "wss://open-api-swap.bingx.com/swap-market"

import_config "#{config_env()}.exs"
