import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :loanmanagementsystem, Loanmanagementsystem.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "loanmanagementsystem_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :loanmanagementsystem, LoanmanagementsystemWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "LyM9f8yaZ+stw1TLTxX4WNe9RsGe9N7ChbOO7olQHGl8E3BSJ7RLsaoSjHLD5ASD",
  server: false

# In test we don't send emails.
config :loanmanagementsystem, Loanmanagementsystem.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
