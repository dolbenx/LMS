# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :loanmanagementsystem,
  ecto_repos: [Loanmanagementsystem.Repo]

config :endon,
  repo: Loanmanagementsystem.Repo

# Telegram Chatbot
config :nadia,
  token: "5327164656:AAGVnev1jyhLCbgd2B5n7YFmJK-hrTdItu0",
  recv_timeout: 10

# proxy: "http://localhost:4000", # or {:socks5, 'proxy_host', proxy_port}
# proxy_auth: {"user", "password"},
# ssl: [versions: [:'tlsv1.2']]

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"],
  "application/xml" => ["xml"],
  "application/pdf" => ["pdf"]
}

# Configures the endpoint
config :loanmanagementsystem, LoanmanagementsystemWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9E6cWB4b+q1Zg2yYU9HjK6wtksGbCoHH+zI7dQoCcOeayiB30CYCtHAXFjebi8N7",
  render_errors: [view: LoanmanagementsystemWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Loanmanagementsystem.PubSub,
  live_view: [signing_salt: "H/IK8lxp"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Email Config
config :loanmanagementsystem, Loanmanagementsystem.Emails.Mailer,
  adapter: Bamboo.SMTPAdapter,
  # smtp.office365.com
  server: "smtp.gmail.com",
  port: 587,
  # or {:system, "SMTP_USERNAME"}
  # username:  System.get_env("email_sender"),# "mfulajohn360@gmail.com",
  username: "mfulajohn360@gmail.com",
  # or {:system, "SMTP_PASSWORD"}
  password: "mfula@360",
  # can be `:always` or `:never`
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  # can be `true`
  ssl: false,
  retries: 2

config :pdf_generator,
  raise_on_missing_wkhtmltopdf_binary: false

# Configure Cron Jobs
config :loanmanagementsystem, Loanmanagementsystem.Scheduler,
  overlap: false,
  timeout: :timer.hours(12),
  timezone: "Africa/Cairo",
  jobs: [
    # loan_disbursement_via_airtel: [
    # schedule: "* * * * *",
    # task: {LoanSavingsSystem.Jobs.DisbursementPosting, :perform_disbursement_via_airtel, []}
    # ],

    # loan_repyament_via_airtel: [
    # schedule: "* * * * *",
    # task: {LoanSavingsSystem.Jobs.LoanRepayment, :perform_loanrepayment_via_airtel, []}
    # ],

    #   send_sms: [
    #     #  schedule: "    *",
    #     schedule: {:extended, "*/3"},
    #       # schedule: "@monthly",
    #       task: {Loanmanagementsystem.Workers.Sms, :send, []}
    #     ],

    #  update_loan_balance: [
    #     #  schedule: "    *",
    #     schedule: {:extended, "*/3"},
    #       # schedule: "@monthly",
    #       task: {LoanSavingsSystem.Jobs.UpdateSuccessfulRepaymentLoanBal, :update_all_successful_loan_repayment_bal, []}
    #     ],
  ]
