import Config

IO.puts "Configuring instance in #{config_env()} mode"

config :bingx,
  api_key: System.get_env("API_KEY") || raise("Missing API_KEY environment variable"),
  secret_key: System.get_env("SECRET_KEY") || raise("Missing SECRET_KEY environment variable")
