# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :loan_savings_system, LoanSavingsSystem.Repo,
    username: "probase",
    password: "Password123$$",
    database: "mfz_savings_live_3",
    hostname: "localhost",
    show_sensitive_data_on_connection_error: true,
    pool_size: 10,
    port: 1433

config :loan_savings_system, LoanSavingsSystem.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "5000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: "srZWag+JaNLykB8MQoQb5NGTovTYmQLttihCGbjEgKRhrGmbvwhy4Uhmsa2cELsN"

  # Email Config
    config :loan_savings_system, LoanSavingsSystem.Emails.Mailer,
    adapter: Bamboo.SMTPAdapter,
    server: "smtp.gmail.com", #smtp.office365.com
    port: 587,
    # or {:system, "SMTP_USERNAME"}
    username: "johnmfula360@gmail.com",
    # or {:system, "SMTP_PASSWORD"}
    password: "john@360d",
    # can be `:always` or `:never`
    tls: :if_available,
    allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
    # can be `true`
    ssl: false,
    retries: 2

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :loan_savings_system, LoanSavingsSystem.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
