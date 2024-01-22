# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config
# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """

# config :loanmanagementsystem, Smartsmspull.Repo,
#   # ssl: true,
#   url: database_url,
#   pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# secret_key_base =
#   System.get_env("SECRET_KEY_BASE") ||
#     raise """
#     environment variable SECRET_KEY_BASE is missing.
#     You can generate one by calling: mix phx.gen.secret
#     """

# config :loanmanagementsystem, LoanmanagementsystemWeb.Endpoint,
#   http: [
#     port: String.to_integer(System.get_env("PORT") || "4000"),
#     transport_options: [socket_opts: [:inet6]]
#   ],
#   secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :loanmanagementsystem, LoanmanagementsystemWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

  config :loanmanagementsystem, LoanmanagementsystemWeb.Endpoint,
  http: [
    port: String.to_integer(System.fetch_env!("HTTP_PORT")),
    protocol_options: [
      idle_timeout: String.to_integer(System.fetch_env!("IDLE_TIMEOUT"))
    ]
  ],
  server: true,
  url: [
    host: System.fetch_env!("HOST"),
    port: String.to_integer(System.fetch_env!("HTTPS_PORT"))
  ],
  # force_ssl: [hsts: true],
  https: [
    # :inet6,
    port: String.to_integer(System.fetch_env!("HTTPS_PORT")),
    protocol_options: [
      idle_timeout: String.to_integer(System.fetch_env!("IDLE_TIMEOUT"))
    ],
    cipher_suite: :strong,
    certfile: System.fetch_env!("SSL_CERT"),
    keyfile: System.fetch_env!("SSL_KEY")
  ]

config :loanmanagementsystem, LoanmanagementsystemWeb.Endpoint,
  secret_key_base: "2rUNYi16Hx2dITGiE99r4ZQg0DhXkQtDuLrFPd9T396nTF7llX9AN1v/4FCtrf14"

# MSSQL Server database Configuration
config :loanmanagementsystem, Loanmanagementsystem.Repo,
  # Tds.Ecto,
  adapter: Ecto.Adapters.Tds,
  database: System.fetch_env!("MSSQL_DB"),
  username: System.fetch_env!("MSSQL_USER"),
  password: System.fetch_env!("MSSQL_PWD"),
  hostname: System.fetch_env!("MSSQL_HOST"),
  port: String.to_integer(System.fetch_env!("MSSQL_PORT")),
  pool_size: String.to_integer(System.fetch_env!("POOL_SIZE")),
  timeout: String.to_integer(System.fetch_env!("MSSQL_TIMEOUT")),
  pool_timeout: String.to_integer(System.fetch_env!("MSSQL_POOL_TIMEOUT"))
