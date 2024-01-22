defmodule LoanSavingsSystemWeb.IndividualController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.Repo
  alias LoanSavingsSystem.Logs.UserLogs
  alias LoanSavingsSystem.LoanApplications.LoanApplicationsEmployee

  import Ecto.Query, only: [from: 2]

  plug(
  LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
    when action not in [:new_password, :change_password]
  )

  plug(

    LoanSavingsSystemWeb.Plugs.RequireIndividual
      when action in [
        :customer_view,
        :individual_loan_product,
        :individual_dashboard,
        :individual_loans_tracking,
        :loans_repayments_for_individual,
        :individual_refund_loans,
        :individual_reports

      ]
    )


  def individual_dashboard(conn, _params) do
    loans = Intergrator.Intergrations.pbl_product_list
    render(conn, "individual_dashboard.html", loans: loans)
  end

  def individual_loan_product(conn, _params) do
    loans = Intergrator.Intergrations.pbl_product_list
    IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    render(conn, "individual_loan_product.html",loans: loans)
  end


  def individual_loan_application(conn, params) do
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
              |> redirect(to: Routes.individual_path(conn, :individual_loan_product))

            {:error, _failed_operation, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
              |> put_flash(:error, "timeout data")
              |> redirect(to: Routes.individual_path(conn, :individual_loan_product))
            end
      [] ->

          conn
          |> put_flash(:error, "There was a problem while processing your loan application. Please try again.")
          |> redirect(to: Routes.individual_path(conn, :individual_loan_product))

      :timeout ->

        conn
          |> put_flash(:error, "There was a problem while processing your loan application. Please try again.")
          |> redirect(to: Routes.individual_path(conn, :individual_loan_product))

      nil ->
        IO.inspect params
        conn
          |> put_flash(:error, "There was a problem while processing your loan application. Please try again.")
          |> redirect(to: Routes.individual_path(conn, :individual_loan_product))

      _->
        IO.inspect params
        conn
          |> put_flash(:error, loans)
          |> redirect(to: Routes.individual_path(conn, :individual_loan_product))


      end
  end

  def loans_repayments_for_individual(conn, params) do
    loans = Intergrator.Intergrations.pbl_payment_inititation(conn, params)
      IO.inspect loans
    render(conn, "individual_loan_repayments.html")
  end

  def individual_loan_repayment(conn, params) do
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
              |> redirect(to: Routes.individual_path(conn, :loans_repayments_for_individual))

            {:error, _failed_operation, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.individual_path(conn, :loans_repayments_for_individual))
            end
      [] ->

          conn
          |> put_flash(:error, "There was a problem while processing your loan repayment request. Please try again.")
          |> redirect(to: Routes.individual_path(conn, :loans_repayments_for_individual))

      :timeout ->

        conn
          |> put_flash(:error, "There was a problem while processing your loan repayment request. Please try again.")
          |> redirect(to: Routes.individual_path(conn, :loans_repayments_for_individual))

      _->

        conn
          |> put_flash(:error, loans)
          |> redirect(to: Routes.individual_path(conn, :loans_repayments_for_individual))

      end
  end

  def individual_refund_loans(conn, _params) do
    render(conn, "individual_refund_loans.html")
  end

  def individual_refund_request(conn, params) do
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
              |> redirect(to: Routes.individual_path(conn, :individual_refund_loans))

            {:error, _failed_operation, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.individual_path(conn, :individual_refund_loans))
            end
      [] ->

          conn
          |> put_flash(:error, "There was a problem while processing your loan refund request. Please try again.")
          |> redirect(to: Routes.individual_path(conn, :individual_refund_loans))

      :timeout ->

        conn
          |> put_flash(:error, "There was a problem while processing your loan refund request. Please try again.")
          |> redirect(to: Routes.individual_path(conn, :individual_refund_loans))

      _->

        conn
          |> put_flash(:error, loans)
          |> redirect(to: Routes.individual_path(conn, :individual_refund_loans))
      end
  end


  def individual_loans_tracking(conn, _params) do
    render(conn, "individual_loan_tracking.html")
  end

  def get_individual_loan_trucking(conn, params) do
    data = Intergrator.Intergrations.pbl_loan_tracking(conn, params)

    IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    IO.inspect data

  json(conn, Poison.encode!(%{resp: data}))
end

  def customer_view(conn, _params) do
    render(conn, "360_view.html")
  end

  def get_individual_affordable_amoutn(conn, params) do

    data = Intergrator.Intergrations.pbl_affordable_amount(conn, params)

    IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    IO.inspect data

    json(conn, Poison.encode!(%{resp: data}))
  end

  # Report Generattion
  def generate_individual_mini_report(conn, _params) do
    render(conn, "individual_reports.html")
  end


  def individual_mini_report(conn, params) do
    data = Intergrator.Intergrations.pbl_mini_statement(conn, params)

    IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    IO.inspect data

    json(conn, Poison.encode!(%{resp: data}))
  end


  def generate_individual_historical_report(conn, _params) do
    render(conn, "individual_historical_reports.html")
  end

  def individual_loan_statement_report(conn, params) do
    data = Intergrator.Intergrations.pbl_loan_statement(conn, params)

    IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    IO.inspect data

    json(conn, Poison.encode!(%{resp: data}))
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end

end
