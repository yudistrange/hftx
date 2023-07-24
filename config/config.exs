# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :hftx,
  ecto_repos: [Hftx.Repo]

# Configures the endpoint
config :hftx, HftxWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: HftxWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Hftx.PubSub,
  live_view: [signing_salt: "a8XfPal7"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures the zerodha endpoints, api keys, api secrets and urls
config :hftx, :zerodha,
  api_url: System.get_env("KITE_API_URL") || "http://localhost:3000",
  api_key: System.get_env("KITE_CLIENT_ID") || "api_key",
  api_secret: System.get_env("GITHUB_CLIENT_ID") || "api_secret",
  web_socket_url: System.get_env("KITE_WSS_URL") || "wss://localhost:3000"

# Example instrument configuration
# config :hftx, :instruments,
#   tsla: [
#     decision_maker_strategy: Hftx.Strategies.DecisionMaker.Naive,
#     data_transformer_strategy: Hftx.Strategies.DataTransformer.CandleStick,
#     trader_strategies: [Hftx.Strategies.Trader.AlwaysLong]
# ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
