# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :savings,
  ecto_repos: [Savings.Repo]

# Endon library cinfigured
config :endon,
  repo: Savings.Repo

# Configures the endpoint
config :savings, SavingsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: SavingsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Savings.PubSub,
  live_view: [signing_salt: "1H5mYR0+"]

config :pdf_generator,
  raise_on_missing_wkhtmltopdf_binary: false,
  # wkhtml_path: "/usr/local/bin/wkhtmltopdf"
  wkhtml_path: "C:/Program Files/wkhtmltopdf/bin/wkhtmltopdf.exe"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :savings, Savings.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

  # Application logs
config :logger, :console,
  format: "[$level] $message\n",
  colors: [enabled: true]



config :logger,
  backends: [:console, {LoggerFileBackend, :info}, {LoggerFileBackend, :error}],
  format: "[$level] $message\n"

log_file_path =
  # "D:/Elixir/Logs/#{Calendar.strftime(Date.utc_today(), "%Y/%b/%x")}"
  File.cwd!<>"/Logs/#{Calendar.strftime(Date.utc_today(), "%Y/%b/%x")}"

config :logger, :info,
  path: "#{log_file_path}/info.log",
  level: :info

config :logger, :error,
  path: "#{log_file_path}/error.log",
  level: :error

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :savings, Savings.Emails.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "b18b44a232efe203364b1b59fbd00b2f-2de3d545-e2705a80", # or {:system, "MAILGUN_API_KEY"},
  domain: "report.probasegroup.com",  # or {:system, "MAILGUN_DOMAIN"},
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
]


# Configure Cron Jobs
# config :savings, Savings.Scheduler,
#  overlap: false,
#  timeout: 30_000,
#  jobs: [
#   #  send_sms: [
#   #   #  schedule: "* * * * *",
#   #    schedule: {:extended, "*/10"},
#   #    # schedule: "@monthly",
#   #    task: {Savings.Workers.Sms, :send, []}
#   #  ],
#     transaction_inquiry: [
#       # schedule: "*/5 * * * *",
#         schedule: {:extended, "*/5"},
#       	task: {Savings.Workers.TransactionInquiry, :inquire_pending_transaction_status, []}
#     ],

#  ]
