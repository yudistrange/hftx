import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :hftx, Hftx.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  database: "hftx_test",
  port: System.get_env("POSTGRES_PORT") || 25432,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hftx, HftxWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4003],
  secret_key_base: "fAmPINZJN69e1+RWwkL8v4rhSyxnSTL7V5hGZkMEc/BXGqJK9dzAa3ZpHdwdlrKh",
  server: true

# Print only warnings and errors during test
config :logger, level: :info

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :hftx, :backtest,
  enabled: true,
  data_file: "priv/backtest_data.csv"

config :hftx, :zerodha,
  api_url: System.get_env("KITE_API_URL") || "http://localhost:4002",
  api_key: System.get_env("KITE_CLIENT_ID") || "api_key",
  api_secret: System.get_env("GITHUB_CLIENT_ID") || "api_secret",
  web_socket_url: System.get_env("KITE_WSS_URL") || "wss://localhost:4002"

config :hftx, :instruments,
  bajfinance: [
    decision_maker_strategy: Hftx.Strategies.DecisionMaker.Naive,
    data_transformer_strategy: Hftx.Strategies.DataTransformer.CandleStick,
    trader_strategies: [Hftx.Strategies.Trader.AlwaysLong]
  ]
