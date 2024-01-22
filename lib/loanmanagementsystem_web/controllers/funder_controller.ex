defmodule LoanmanagementsystemWeb.FunderController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Loan.{Loans, Loan_recommendation_and_assessment, Loan_funder}
  alias Loanmanagementsystem.Repo
  import Ecto.Query, warn: false

  def funder_dashboard(conn, _params) do
      funder_id = conn.assigns.user.id
      funds_count = Loanmanagementsystem.Loan.count_funders_funds(funder_id)
      count_loans_by_funder = Loanmanagementsystem.Loan.count_loans_by_funders(funder_id)
      render(conn, "funder_dashboard.html", funds_count: funds_count, count_loans_by_funder: count_loans_by_funder)
  end

  def all_loans(conn, _params) do
    funder_id = conn.assigns.user.id
    consumser_loans = Loanmanagementsystem.Loan.get_corparate_loan_by_funder_id(funder_id)
    render(conn, "all_loans.html", consumser_loans: consumser_loans)
  end

  def invoice_discounting_loans(conn, _params) do
    funder_id = conn.assigns.user.id
    invoice_discounting_loans = Loanmanagementsystem.Loan.get_corparate_loan_by_funder_id(funder_id) |> Enum.reject(&(&1.productType != "INVOICE DISCOUNTING"))
    render(conn, "invoice_discounting_loans.html", invoice_discounting_loans: invoice_discounting_loans)
  end

  def order_finance_loans(conn, _params) do
    funder_id = conn.assigns.user.id
    consumser_loans = Loanmanagementsystem.Loan.get_corparate_loan_by_funder_id(funder_id) |> Enum.reject(&(&1.productType != "ORDER FINANCE"))
    render(conn, "order_finance_loans.html", consumser_loans: consumser_loans)
  end

  def consumer_loans(conn, _params) do
    funder_id = conn.assigns.user.id
    consumser_loans = Loanmanagementsystem.Loan.get_corparate_loan_by_funder_id(funder_id) |> Enum.reject(&(&1.productType != "CONSUMER LOAN"))
    render(conn, "consumer_loans.html", consumser_loans: consumser_loans)
  end

  def sme_loans(conn, _params) do
    funder_id = conn.assigns.user.id
    consumser_loans = Loanmanagementsystem.Loan.get_corparate_loan_by_funder_id(funder_id) |> Enum.reject(&(&1.productType != "SME LOAN"))
    render(conn, "sme_loans.html", consumser_loans: consumser_loans)
  end

  def funders_funds(conn, _params) do
      funder_id = conn.assigns.user.id
      funders_funds = Loanmanagementsystem.Loan.get_funder_balance_details(funder_id)
    render(conn, "funders_funds.html", funders_funds: funders_funds)
  end


  def pending_loans(conn, _params) do
    render(conn, "pending_loans.html")
  end

  def loan_repayments(conn, _params) do
    render(conn, "loan_repayments.html")
  end

  def loan_tracker(conn, _params) do
    render(conn, "loan_tracker.html")
  end

  def loan_product(conn, _params) do
    products = Loanmanagementsystem.Products.list_tbl_products() |> Enum.reject(&(&1.status != "ACTIVE"))
    render(conn, "loan_product.html", products: products)
  end

  def funder_360(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    user_details = Loanmanagementsystem.Accounts.get_details(currentUserRole.userId)
    render(conn, "funder360.html", user_details: user_details, currentUserRole: currentUserRole)
  end

  def approve_funder_invoice_discounting(conn, %{"loan_id" => loan_id}) do

    loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(loan_id)

    loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)

    credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

    funder_amounts = Loanmanagementsystem.Loan.get_funder_calculations(loan_id)

    render(conn, "approve_invoice_discounting_loan.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, funder_amounts: funder_amounts)
  end

  def view_funder_invoice_discounting(conn, %{"loan_id" => loan_id}) do

    loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(loan_id)
    loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)

    render(conn, "invoice_discounting_funder_view.html", loan_details: loan_details, loanDocs: loanDocs)
  end

  def approve_invoice_discounting_application(conn, params) do

    if  String.to_integer(params["disbursement_amount"]) <=  String.to_integer(params["totalbalance"]) do

      total_funder_amount = String.to_integer(params["totalbalance"])

      requested_amount = String.to_integer(params["amount"])

      total_loan_recieved = String.to_integer(params["disbursement_amount"])

      total_balance = total_funder_amount - total_loan_recieved

      reference_no = generate_momo_random_string(10)

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

      get_funds_id = Loanmanagementsystem.Loan.Loan_funder.find_by(funderID: loans.funderID)

      get_funder = Loanmanagementsystem.Loan.get_loan_funder!(get_funds_id.id)

      case total_loan_recieved do

        total_loan_recieved when total_loan_recieved <= requested_amount ->

        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :add_loan,
          Loans.changeset(loans, %{

            loan_status: "DISBURSED",
            status: "DISBURSED",
            disbursedon_date: Date.utc_today(),
            disbursedon_userid: conn.assigns.user.id,
            disbursement_method: params["disbursement_method"],
            disbursement_status: params["disbursement_status"],
            principal_disbursed_derived: params["disbursement_amount"],

          })
        )

        |> Ecto.Multi.run(:recomendation, fn _repo, %{add_loan: _add_loan} ->
          Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
            comments: params["comment"],
            customer_id: params["customer_id"],
            date: "#{Date.utc_today()}",
            date_received: Date.to_string(loans.application_date),
            name: params["feedback_name"],
            position: "FUNDER",
            recommended: params["feedback"],
            time_received: "#{Timex.now()}",
            user_type: "FUNDER",
            loan_id: loans.id,
            reference_no: reference_no
          })
          |> Repo.insert()
        end)

        |> Ecto.Multi.run(:update_funder, fn _repo, %{add_loan: _add_loan} ->
          Loan_funder.changeset(get_funder, %{
            totalbalance: total_balance,
            totalinterest_accumulated: loans.interest_amount,
          })
          |> Repo.update()
        end)

        |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan, update_funder: _update_funder} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Loan Application Successfully Disbursed By The Funding Patner",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)

        |> Ecto.Multi.run(:document, fn _repo, %{add_loan: add_loan, user_logs: _user_logs} ->
          Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads.invoice_loan_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id}, params)
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{add_loan: _add_loan, user_logs: _user_logs, document: _document}} ->
            conn
            |> put_flash(:info, "Loan Application Approved Successfully By Funder")
            |> redirect(to: Routes.funder_path(conn, :invoice_discounting_loans))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.funder_path(conn, :invoice_discounting_loans))
        end
        _ ->
        conn
        |> put_flash(:error, "Disbursed amount can not be more than the requested amount, please check and try again.")
        |> redirect(to: Routes.funder_path(conn, :invoice_discounting_loans))
      end
      else
      conn
        |> put_flash(:error, "You have insufficient funds, please fund your account and try again.")
        |> redirect(to: Routes.funder_path(conn, :invoice_discounting_loans))
    end
  end

  def generate_momo_random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.encode64
    |> binary_part(0, length)
  end

  def funder_all_documents_for_loans(conn, params) do
    documents = Loanmanagementsystem.Operations.get_loan_client_docs(params["userId"], params["loan_id"])
    render(conn, "funder_all_documents_for_loans.html", documents: documents)
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end

end
