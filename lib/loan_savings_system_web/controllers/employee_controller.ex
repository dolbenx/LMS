defmodule LoanSavingsSystemWeb.EmployeeController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.Repo
  alias LoanSavingsSystem.Accounts
  alias LoanSavingsSystem.Accounts.User
  alias LoanSavingsSystem.Accounts.Account
  alias LoanSavingsSystem.Customers
 # alias LoanSavingsSystem.Savings
  alias LoanSavingsSystem.Transactions
  alias LoanSavingsSystem.Charges
  alias LoanSavingsSystem.Products.Product
  alias LoanSavingsSystem.Accounts.UserRole
  alias LoanSavingsSystem.Client.UserBioData
  alias LoanSavingsSystem.ConfirmationNotification.ConfirmationLoanNotification
  alias LoanSavingsSystem.Companies.Company
  alias LoanSavingsSystem.Companies.Branch
  alias LoanSavingsSystem.Loan.Loans
  alias LoanSavingsSystem.Logs.UserLogs
  alias LoanSavingsSystem.LoanApplications.LoanApplicationsEmployee


  alias LoanSavingsSystem.Employees.Services.{Branches, LoanProducts, LoanOps}
  alias LoanSavingsSystem.Employees.Services.Loan, as: EmployeeLoans
  alias LoanSavingsSystem.Employees.Services.User, as: UserService
  alias LoanSavingsSystem.Employees.Services.WorkFlows, as: WFsService



  require Logger
  require Record

    plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password, :loan_details]
    )



    def apply(conn, _params) do
      loans = Intergrator.Intergrations.pbl_product_list
        IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        # IO.inspect loans

      render(conn, "apply.html", loans: loans)
    end

    def employee_apply_loan(conn, params) do
      IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<initiiiiiiiiiiiiiiiiiiiii<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      params = Map.put(params, "titleid", String.to_integer(params["titleid"]))
      params = Map.put(params, "genderid", String.to_integer(params["genderid"]))
      params = Map.put(params, "maritalstatusid", String.to_integer(params["maritalstatusid"]))
      params = Map.put(params, "districtid1", String.to_integer(params["districtid1"]))
      params = Map.put(params, "provinceid1", String.to_integer(params["provinceid1"]))
      params = Map.put(params, "countryid1", String.to_integer(params["countryid1"]))
      params = Map.put(params, "districtid2", String.to_integer(params["districtid2"]))
      params = Map.put(params, "provinceid2", String.to_integer(params["provinceid2"]))
      params = Map.put(params, "countryid2", String.to_integer(params["countryid2"]))
      params = Map.put(params, "nationalityid", String.to_integer(params["nationalityid"]))
      params = Map.put(params, "employmenttypeid", String.to_integer(params["employmenttypeid"]))
      params = Map.put(params, "loanamount", String.to_float(params["loanamount"]))
      params = Map.put(params, "loantypeid", String.to_integer(params["loantypeid"]))
      params = Map.put(params, "loanpurposeid", String.to_integer(params["loanpurposeid"]))
      params = Map.put(params, "payoffamount", String.to_float(params["payoffamount"]))
      params = Map.put(params, "kintitleid", String.to_integer(params["kintitleid"]))
      params = Map.put(params, "kinmaritalstatusid", String.to_integer(params["kinmaritalstatusid"]))
      params = Map.put(params, "kingenderid", String.to_integer(params["kingenderid"]))
      params = Map.put(params, "kinrelationshipid", String.to_integer(params["kinrelationshipid"]))
      params = Map.put(params, "amount", String.to_float(params["amount"]))
      params = Map.put(params, "salarycomponenttypeid", String.to_integer(params["salarycomponenttypeid"]))
      params = Map.put(params, "doctypeid", String.to_integer(params["doctypeid"]))
      IO.inspect params
      loans = Intergrator.Intergrations.pbl_loan_initiation(conn, params)
      # IO.inspect loans["rstmsg"]
      case loans do
        :ok ->
          Ecto.Multi.new()
            |> Ecto.Multi.insert(:loanApplicationsEmployee, LoanApplicationsEmployee.changeset(%LoanApplicationsEmployee{}, params))
            |> Ecto.Multi.run(:user_log, fn _repo, %{loanApplicationsEmployee: loanApplicationsEmployee} ->
            activity = "Loan Application Submitted with LoanId #{loanApplicationsEmployee.id} and user ID #{conn.assigns.user.id}"
            user_log = %{
                  user_id: conn.assigns.user.id,
                  activity: activity
            }
            UserLogs.changeset(%UserLogs{}, user_log)
            |> Repo.insert()
            end)

            |> Repo.transaction()
            |> case do
              {:ok, %{loanApplicationsEmployee: _loanApplicationsEmployee, user_log: _user_log}} ->
                conn
                |> put_flash(:info, "Your Loan Application Has Been Submitted Successfully.")
                |> redirect(to: Routes.employee_path(conn, :apply))

              {:error, _failed_operation, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors) |> List.first()

                conn
                |> put_flash(:error, "timeout data")
                |> redirect(to: Routes.employee_path(conn, :apply))
              end
        [] ->

            conn
            |> put_flash(:error, "There was a problem while processing your loan application. Please try again.")
            |> redirect(to: Routes.employee_path(conn, :apply))

        :timeout ->

          conn
            |> put_flash(:error, "There was a problem while processing your loan application. Please try again.")
            |> redirect(to: Routes.employee_path(conn, :apply))

        nil ->
          IO.inspect params
          conn
            |> put_flash(:error, "There was a problem while processing your loan application. Please try again.")
            |> redirect(to: Routes.employee_path(conn, :apply))

        _->
          IO.inspect params
          conn
            |> put_flash(:error, loans)
            |> redirect(to: Routes.employee_path(conn, :apply))


        end
    end



    def repay(conn, params) do
      loans = Intergrator.Intergrations.pbl_payment_inititation(conn, params)
      IO.inspect loans
      render(conn, "repay.html")
    end

    def employee_loan_repayment(conn, params) do
      loans = Intergrator.Intergrations.pbl_payment_inititation(conn, params)
      IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LOAN REPAYMENT INITITATION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      IO.inspect loans
      case loans do
        :ok ->
          Ecto.Multi.new()
            |> Ecto.Multi.insert(:loanApplicationsEmployee, LoanApplicationsEmployee.changeset(%LoanApplicationsEmployee{}, params))
            |> Ecto.Multi.run(:user_log, fn _repo, %{loanApplicationsEmployee: loanApplicationsEmployee} ->
            activity = "Loan Application Submitted with LoanId #{loanApplicationsEmployee.id} and user ID #{conn.assigns.user.id}"
            user_log = %{
                  user_id: conn.assigns.user.id,
                  activity: activity
            }
            UserLogs.changeset(%UserLogs{}, user_log)
            |> Repo.insert()
            end)

            |> Repo.transaction()
            |> case do
              {:ok, %{loanApplicationsEmployee: _loanApplicationsEmployee, user_log: _user_log}} ->
                conn
                |> put_flash(:info, "Your Loan Repayment Request Has Been Submitted Successfully.")
                |> redirect(to: Routes.employee_path(conn, :repay))

              {:error, _failed_operation, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors) |> List.first()

                conn
                |> put_flash(:error, reason)
                |> redirect(to: Routes.employee_path(conn, :repay))
              end
        [] ->

            conn
            |> put_flash(:error, "There was a problem while processing your loan repayment request. Please try again.")
            |> redirect(to: Routes.employee_path(conn, :repay))

        :timeout ->

          conn
            |> put_flash(:error, "There was a problem while processing your loan repayment request. Please try again.")
            |> redirect(to: Routes.employee_path(conn, :repay))

        _->

          conn
            |> put_flash(:error, loans)
            |> redirect(to: Routes.employee_path(conn, :repay))

        end
    end

    def refund_loan(conn, _request) do
      render(conn, "refund_loan.html")
    end

    def employee_refund_request(conn, params) do
      loans = Intergrator.Intergrations.pbl_loan_refund(conn, params)
      IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< REFUND REQUEST<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      IO.inspect loans
      case loans do
        :ok ->
          Ecto.Multi.new()
            |> Ecto.Multi.insert(:loanApplicationsEmployee, LoanApplicationsEmployee.changeset(%LoanApplicationsEmployee{}, params))
            |> Ecto.Multi.run(:user_log, fn _repo, %{loanApplicationsEmployee: loanApplicationsEmployee} ->
            activity = "Loan Application Submitted with LoanId #{loanApplicationsEmployee.id} and user ID #{conn.assigns.user.id}"
            user_log = %{
                  user_id: conn.assigns.user.id,
                  activity: activity
            }
            UserLogs.changeset(%UserLogs{}, user_log)
            |> Repo.insert()
            end)

            |> Repo.transaction()
            |> case do
              {:ok, %{loanApplicationsEmployee: _loanApplicationsEmployee, user_log: _user_log}} ->
                conn
                |> put_flash(:info, "Your Loan Refund Request Has Been Submitted Successfully.")
                |> redirect(to: Routes.employee_path(conn, :refund_loan))

              {:error, _failed_operation, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors) |> List.first()

                conn
                |> put_flash(:error, reason)
                |> redirect(to: Routes.employee_path(conn, :refund_loan))
              end
        [] ->

            conn
            |> put_flash(:error, "There was a problem while processing your loan refund request. Please try again.")
            |> redirect(to: Routes.employee_path(conn, :refund_loan))

        :timeout ->

          conn
            |> put_flash(:error, "There was a problem while processing your loan refund request. Please try again.")
            |> redirect(to: Routes.employee_path(conn, :refund_loan))

        _->

          conn
            |> put_flash(:error, loans)
            |> redirect(to: Routes.employee_path(conn, :refund_loan))

        end
    end

    def employee_loan_trucking(conn, _params) do
      render(conn, "loan_tracking.html")
    end

    def get_employee_loan_trucking(conn, params) do

      data = Intergrator.Intergrations.pbl_loan_tracking(conn, params)

      IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      IO.inspect data

      json(conn, Poison.encode!(%{resp: data}))
    end


    def get_employee_affordable_amoutn(conn, params) do

        data = Intergrator.Intergrations.pbl_affordable_amount(conn, params)
        IO.inspect data

        IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

      json(conn, Poison.encode!(%{resp: data}))
    end

    def all_view(conn, _params) do
      render(conn, "360_view.html")
    end




  #   ====================================== START OF REPORTS =========================================


    def generate_mini_report(conn, _params) do
      render(conn, "mini_reports.html")
    end

    def employee_mini_report(conn, params) do
      data = Intergrator.Intergrations.pbl_mini_statement(conn, params)

      IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      IO.inspect data

      json(conn, Poison.encode!(%{resp: data}))
    end

    def generate_historical_report(conn, _params) do
      render(conn, "historical_reports.html")
    end

    def employee_historical_report(conn, params) do
      data = Intergrator.Intergrations.pbl_loan_statement(conn, params)

      IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      IO.inspect data

      json(conn, Poison.encode!(%{resp: data}))
    end

    def traverse_errors(errors) do
      for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
    end
end
