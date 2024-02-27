import Config

config :bingx, origin: "https://open-api.bingx.com"

import_config "#{config_env()}.exs"
