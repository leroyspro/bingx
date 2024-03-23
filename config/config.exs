import Config

config :bingx, origin: "https://open-api.bingx.com"

if Code.ensure_loaded?(HTTPoison) do
  config :bingx, http_adapter: BingX.HTTP.Adapter.HTTPoison
end

import_config "#{config_env()}.exs"
