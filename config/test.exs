use Mix.Config

# Configure your database
config :loan_savings_system, LoanSavingsSystem.Repo,
  username: "postgres",
  password: "postgres",
  database: "loan_savings_system_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :loan_savings_system, LoanSavingsSystemWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
