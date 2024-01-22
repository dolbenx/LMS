# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """

# config :loanmanagementsystem, Loanmanagementsystem.Repo,
#   # ssl: true,
#   url: database_url,
#   pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")


config :loanmanagementsystem, Loanmanagementsystem.Repo,
  database: "paykesho_uat_demo",
  hostname: "localhost",
  username: "postgres",
  password: "Password123$$",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10


secret_key_base = "2rUNYi16Hx2dITGiE99r4ZQg0DhXkQtDuLrFPd9T396nTF7llX9AN1v/4FCtrf14"

config :loanmanagementsystem, LoanmanagementsystemWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "5051"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :loanmanagementsystem, LoanmanagementsystemWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
