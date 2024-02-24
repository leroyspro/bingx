import Config

config :bingx, hostname: "open-api.bingx.com"

import_config "#{config_env()}.exs"
