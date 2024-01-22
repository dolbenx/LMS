# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :loan_savings_system,
  ecto_repos: [LoanSavingsSystem.Repo]

# Endon library cinfigured
config :endon,
      repo: LoanSavingsSystem.Repo

# Email Config
config :loan_savings_system, LoanSavingsSystem.Emails.Mailer,
adapter: Bamboo.SMTPAdapter,
server: "smtp.gmail.com", #smtp.office365.com
port: 587,
# or {:system, "SMTP_USERNAME"}
username: "mfulajohn360@gmail.com",
# or {:system, "SMTP_PASSWORD"}
password: "mfula@360",
# can be `:always` or `:never`
tls: :if_available,
allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
# can be `true`
ssl: false,
retries: 2


# Configures the endpoint
config :loan_savings_system, LoanSavingsSystemWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NI9LxtF3DqHVEDemR5gIFJj2tqT1S8548VptRd1bN9ErTU+iAMdnauX+2/PmzrE6",
  # render_errors: [view: LoanSavingsSystemWeb.ErrorView, accepts: ~w(html json)],
  # pubsub_server: [name: LoanSavingsSystem.PubSub, adapter: Phoenix.PubSub.PG2]

  render_errors: [view: LoanSavingsSystemWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LoanSavingsSystem.PubSub, adapter: Phoenix.PubSub.PG2]

#Configures Elixir's Logger

config :email_checker,
  default_dns: {8, 8, 8, 8},
  smtp_retries: 1,
  timeout_milliseconds: 6000


config :pdf_generator,
  raise_on_missing_wkhtmltopdf_binary: false,
  wkhtml_path: "/usr/local/bin/wkhtmltopdf"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Configure Cron Jobs
# config :loan_savings_system, LoanSavingsSystem.Scheduler,
#  overlap: false,
#  timeout: 30_000,
#  jobs: [
#    send_sms: [
#      schedule: "* * * * *",
#      # schedule: "@monthly",
#      task: {LoanSavingsSystem.Workers.Sms, :send, []}
#    ],
#     transaction_inquiry: [
#       # schedule: "*/5 * * * *",
#         schedule: {:extended, "*/5"},
#       	task: {LoanSavingsSystem.Workers.TransactionInquiry, :inquire_pending_transaction_status, []}
#     ],

#  ]
