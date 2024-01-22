defmodule LoanSavingsSystemWeb.WorkflowController do
    use LoanSavingsSystemWeb, :controller

    alias LoanSavingsSystem.Repo
    alias LoanSavingsSystem.Logs.UserLogs
    alias LoanSavingsSystem.Charges
    alias LoanSavingsSystem.Charges.AccountCharge
    alias LoanSavingsSystem.Companies
    alias LoanSavingsSystem.Companies.Branch
    alias LoanSavingsSystem.SystemSetting
    alias LoanSavingsSystem.SystemSetting.Country
    alias LoanSavingsSystem.SystemSetting.Currency
    alias LoanSavingsSystem.SystemDirectories
    alias LoanSavingsSystem.Charges.Charge
    alias LoanSavingsSystem.Documents.Document_Type

    require Logger
    # alias LoanSavingsSystem.Accounts
    # alias MfzUssd.{Auth, Logs}

    alias LoanSavingsSystem.Repo
    require Record
    import Ecto.Query, only: [from: 2]

    @headers ~w/ name /a






    def create_new_workflow(conn, params) do
        render(conn, "bank_staff_workflow_creation.html")
    end



    def traverse_errors(errors) do
      for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
    end

end
