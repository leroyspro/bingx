import Config

config :bingx,
  debug: true,
  origin: "https://open-api.bingx.com",
  swap_origin: "wss://open-api-swap.bingx.com/swap-market"

if config_env() === :test do
  import_config "#{config_env()}.exs"
end
