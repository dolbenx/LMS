defmodule LoanSavingsSystem.Repo do
  use Ecto.Repo,
    otp_app: :loan_savings_system,
    # -------------------- Postgres
      adapter: Ecto.Adapters.Postgres
 # -------------------- MYSQL
  #  adapter: Ecto.Adapters.Tds
   use Scrivener

end
