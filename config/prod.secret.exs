# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :loan_system, LoanSystem.Repo,
    #username: "sa",
    #password: "Qwerty12",
    #database: "loansystem_dev",
    #hostname: "ops.probasegroup.com",
    #show_sensitive_data_on_connection_error: true,
    #pool_size: 10,
    #port: 1433
	
	  username: "probase",
	  password: "u6XwZQjDm#!",
	  database: "chikwama_live",
	  hostname: "160.153.244.179",
	  show_sensitive_data_on_connection_error: true,
	  pool_size: 90,
	  port: 1433


# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :loan_system, LoanSystemWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
