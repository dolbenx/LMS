# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config


config :loan_system,
  ecto_repos: [LoanSystem.Repo]

# Endon library cinfigured
config :endon,
      repo: LoanSystem.Repo

# Email Config
config :loan_system, LoanSystem.Emails.Mailer,
  # adapter: Bamboo.SMTPAdapter,
  # server: "smtp.gmail.com", #smtp.office365.com
  # port: 587,
  # # or {:system, "SMTP_USERNAME"}
  # username: "mfulajohn360@gmail.com",
  # # or {:system, "SMTP_PASSWORD"}
  # password: "mfula@360",
  # # can be `:always` or `:never`
  # tls: :if_available,
  # allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  # # can be `true`
  # ssl: false,
  # retries: 2

  adapter: Bamboo.SMTPAdapter,
  # smtp.office365.com
  server: "smtp.gmail.com",
  port: 587,
  # or {:system, "SMTP_USERNAME"}
  username: "reports@probasegroup.com",
  # or {:system, "SMTP_PASSWORD"}
  password: "Password123$",

    # username: "mfulajohn360@gmail.com",
    # # or {:system, "SMTP_PASSWORD"}
    # password: "mfula@360",
  # can be `:always` or `:never`
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  # can be `true`
  ssl: false,
  retries: 2

# config :loan_system, LoanSystem.Mailer,
#   adapter: Bamboo.LocalAdapter

# Configures the endpoint
config :loan_system, LoanSystemWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "n96MEHlkf2lK4yxDuodcYSQO4/KyHTfCt3g1WrJSahCCb2Wy+BHVHGxkBc2dPGUp",
  render_errors: [view: LoanSystemWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: [name: LoanSystem.PubSub, adapter: Phoenix.PubSub.PG2]

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
#  config :loan_system, LoanSystem.Scheduler,
#  overlap: false,
#  timeout: 30_000,
#  jobs: [
#    send_sms: [
#      schedule: "* * * * *",
#      schedule: {:extended, "*/5"},
#      task: {LoanSystem.Workers.Sms, :send, []}
#    ],
  #  check_transa_status: [
  #   # schedule: "* * * * *",
  #   schedule: {:extended, "*/7"},
  #   task: {LoanSystem.Workers.TransactionStatus, :check_transaction, []}
  # ],
  # disb_check_transaction: [
  #   # schedule: "* * * * *",
  #   schedule: {:extended, "*/10"},
  #   task: {LoanSystem.Workers.TransactionStatus, :disb_check_transaction, []}
  # ],
  # disb_check_transaction: [
  #   # schedule: "* * * * *",
  #   schedule: {:extended, "*/20"},
  #   task: {LoanSystem.Workers.SendEod, :send_eod_trans, []}
  # ]

#  ]

 config :mtn_momo,
      mtn_disbursement: %{
      host: "https://proxy.momoapi.mtn.com/disbursement",
      token_path: "/token/",
      ocp_apim_sub_key: "97f17a7e6a434bd19b6a8d8f65032516",
      x_target_env: "mtnzambia",
      username: "a021f306-455c-4b79-a2ae-5bfea5a3c0b0",
      password: "72f72f6e10d541f1bfcfa5541dc652d7",
      transfer_path: "/v1_0/transfer",
      transaction_status_path: "/v1_0/transfer/",
      balance_path: "/v1_0/account/balance",
      x_callback_url: "https://160.153.244.179:5000/mmoney/confirmation"
    },
      mtn_collections: %{
      host: "https://proxy.momoapi.mtn.com/collection",
      token_path: "/token/",
      ocp_apim_sub_key: "95f71be601c04cc9b240f1e4f621f8fe",
      x_target_env: "mtnzambia",
      username: "1fc2183a-a442-4e3e-97e1-3c7c5828a2c5",
      password: "90067526f16f4f07bb698f3a237cda09",
      pay_path: "/v1_0/requesttopay",
      transaction_status_path: "/v1_0/requesttopay/"
    }

    #AIRTEL MOMO INTERGRATION
    config :airtel_momo,
    client: %{
      client_id: "4d45b631-6036-4a35-9e2e-1d3c7cd91c05",
      client_secret: "70193f7a-062e-4321-ae83-e266e5a2d08c",
      grant_type: "client_credentials",
    },
    commons: %{
      country: "ZM",
      currency: "ZMW",
      host: "https://openapi.airtel.africa",
      token_path: "/auth/oauth2/token",
      balance: "/standard/v1/users/balance",
      kyc: "/standard/v1/users/"
    },
    collections: %{
      ussd_push: "/merchant/v1/payments/",
      refund: "/standard/v1/payments/refund",
      transaction_enquiry: "/standard/v1/payments/",
      callback_path: "/path"
    },
    disbursements: %{
      payments: "/standard/v1/disbursements/",
      transaction_enquiry: "/standard/v1/disbursements/"
    }




    # config :loan_system, LoanSystem.Scheduler,
    # overlap: false,
    # timeout: 3_620_000,
    # timezone: "Africa/Cairo",
    # jobs: [


    #   daily_loan_report: [
    #     schedule: "50 23 * * *",
    #     task: {LoanSystem.Workers.SendEod, :daily_loan_report, []}

    #   ],
    #   # monthly_loan_report: [
    #   #   # schedule: {:extended, "*/20"},
    #   #   schedule: "0 0 1 * *",
    #   #   # schedule: "@weekly",
    #   #   task: {LoanSystem.Workers.SendEod, :monthly_loan_report, []}
    #   # ],
    #   loan_cleared_notification: [
    #         schedule: "* * * * *",
    #         schedule: {:extended, "*/5"},
    #         task: {LoanSystem.Loan, :loans_cleared_notification_timex, []}
    #       ],
    #       monthly_loan_summary_report: [
    #           # schedule: {:extended, "*/20"},
    #           schedule: "00 00 * * *",
    #           # schedule: "@monthly",
    #           task: {LoanSystem.Workers.SendEod, :monthly_loan_summary_report, []}
    #         ]

    # ]
