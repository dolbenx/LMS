defmodule LoanmanagementsystemWeb.IndividualController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false

  alias Loanmanagementsystem.{Repo, Logs.UserLogs}
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Products
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Loan.LoanRepayment


  plug LoanmanagementsystemWeb.Plugs.Authenticate,
        [module_callback: &LoanmanagementsystemWeb.IndividualController.authorize_role/1]
          when action not in [
            :apply_for_loans,
            :calculate_interest_and_repaymnent_amt,
            :create_loan_application,
            :create_loan_repayment,
            :create_loan_repayment_view,
            :customer_360_view,
            :generate_reference_no,
            :historic_statements,
            :loan_products,
            :loan_products_capturing,
            :loan_repayment_datatable,
            :loan_tracking,
            :mini_statements,
            :pending_loans,
            :rejected_loans,
            :repayment_loan,
            :select_loan_to_apply,
            :traverse_errors,
            :update_profile,
            :individual_maintainence

       ]

use PipeTo.Override



  def apply_for_loans(conn, _params),
    do:
      render(conn, "apply_for_loans.html",
        loan_details: Loan.get_loan_by_userId_individualview_pending_loan(conn.assigns.user.id)
      )

  def pending_loans(conn, _params),
    do:
      render(conn, "pending_loans.html",
        loan_details: Loan.get_loan_by_userId_individualview_pending_loan(conn.assigns.user.id)
      )

  def rejected_loans(conn, _params),
    do:
      render(conn, "rejected_loan.html",
        loan_details: Loan.get_loan_by_userId_individualview_reject(conn.assigns.user.id)
      )

  def loan_tracking(conn, _params),
    do:
      render(conn, "loan_tracking.html",
        loan_details: Loan.get_loan_by_userId_individualview_loan_tracking(conn.assigns.user.id)
      )

  def repayment_loan(conn, _params),
    do:
      render(conn, "repayment_loan.html",
        products:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "ACTIVE"))
      )

  def customer_360_view(conn, _params) do
      loans = Loanmanagementsystem.Accounts.get_customer_account(conn.assigns.user.id)
      current_user_details = Loanmanagementsystem.Accounts.get_details(conn.assigns.user.id)
      loan_details= Loan.get_loan_by_userId_individualview_loan_tracking(conn.assigns.user.id)
    render(conn, "customer_360_view.html", loans: loans, current_user_details: current_user_details, loan_details: loan_details)
  end

  def mini_statements(conn, _params),
    do:
      render(conn, "mini_statements.html",
        loan_details: Loan.get_loan_by_userId_individualview_loan_tracking(conn.assigns.user.id)
      )

  def historic_statements(conn, _params),
    do:
      render(conn, "historic_statements.html",
        loan_details: Loan.get_loan_by_userId_individualview_loan_tracking(conn.assigns.user.id)
      )

  def loan_products(conn, _params),
    do:
      render(conn, "loan_products.html",
        products:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "ACTIVE"))
      )

  def select_loan_to_apply(conn, _params),
    do:
      render(conn, "select_loan_product.html",
        products:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "ACTIVE"))
      )

  def loan_products_capturing(conn, %{"product_id" => product_id}),
    do:
      render(conn, "apply_for_loans_registration.html",
        product_details: Products.otc_product_details_lookup(product_id),
        get_bio_datas: Accounts.get_details(conn.assigns.user.id)
      )

  def loan_repayment_datatable(conn, params),
    do:
      render(conn, "loan_repayment_datatable.html",
        loan_details:
          Loan.get_loan_by_userId_for_repayment(conn.assigns.user.id, params["product_id"])
      )

  def create_loan_repayment_view(conn, params),
    do:
      render(conn, "create_repayment.html",
        loan_details: Loan.get_loans!(params["loan_id"]),
        get_bio_datas: Accounts.get_details(conn.assigns.user.id),
        product_details: Products.otc_product_details_lookup(params["product_id"])
      )

  def calculate_interest_and_repaymnent_amt(params) do
    interest_rate =
      Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).interest

    yearLengthInDays =
      Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).yearLengthInDays

    principle_amt =
      try do
        String.to_integer(params["amount"])
      rescue
        _ -> String.to_float(params["amount"])
      end

    tenor =
      try do
        String.to_integer(params["tenor"])
      rescue
        _ -> String.to_float(params["tenor"])
      end

    interest = principle_amt * interest_rate * tenor / yearLengthInDays / 100
    repayment = principle_amt + interest

    %{
      interest_amt: interest,
      repayement_amt: repayment
    }
  end

  def create_loan_application(conn, params) do
    loan_calculations = calculate_interest_and_repaymnent_amt(params)

    new_params =
      Map.merge(params, %{
        "customer_id" => conn.assigns.user.id,
        "principal_amount_proposed" => params["amount"],
        "loan_status" => "PENDING_APPROVAL",
        "status" => "PENDING_APPROVAL",
        "currency_code" => params["currency_code"],
        "loan_type" => params["product_type"],
        "principal_amount" => params["amount"],
        "repayment_amount" => loan_calculations.repayement_amt,
        "interest_amount" => loan_calculations.interest_amt,
        "balance" => loan_calculations.repayement_amt
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_loan, Loans.changeset(%Loans{}, new_params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Loan Application Successfully Submitted",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_loan: _add_loan, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Loan Application Submitted")
        |> redirect(to: Routes.individual_path(conn, :pending_loans))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.individual_path(conn, :pending_loans))
    end
  end

  def generate_reference_no do
    date = Timex.today()
    year = to_string(date.year)
    month = to_string(date.month)
    day = to_string(date.day)
    start_of_year_date = Timex.beginning_of_year(date)
    current_year = date
    date_difference = to_string(Date.diff(current_year, start_of_year_date))

    "LRP" <>
      "" <>
      year <>
      "" <>
      month <>
      "" <>
      day <>
      "" <> "." <> "" <> date_difference <> "" <> to_string(System.system_time(:microsecond))
  end

  def create_loan_repayment(conn, params) do
    new_params =
      Map.merge(params, %{
        "reference_no" => generate_reference_no(),
        "repayment" => params["repayment_type"],
        "modeOfRepayment" => params["repayment_method"],
        "dateOfRepayment" => to_string(Timex.today()),
        "loan_product" => params["product_name"],
        "status" => "SUCCESS",
        # "status" => "PENDING_PAYMENT",
        "loan_id" => String.to_integer(String.trim(params["loan_primary_id"])),
        "registeredByUserId" => conn.assigns.user.id
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :create_loan_repayment_view,
      LoanRepayment.changeset(%LoanRepayment{}, new_params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{create_loan_repayment_view: _add_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Loan Repayment is in progress ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{create_loan_repayment_view: _create_loan_repayment_view, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Loan Repayment is in progress.")
        |> redirect(
          to:
            Routes.individual_path(conn, :loan_repayment_datatable,
              loan_id: params["loan_id"],
              product_id: params["product_id"]
            )
        )

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(
          to:
            Routes.individual_path(conn, :loan_repayment_datatable,
              loan_id: params["loan_id"],
              product_id: params["product_id"]
            )
        )
    end
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")

  def update_profile(conn, params) do
    clients_profile = Loanmanagementsystem.Accounts.get_user_bio_data!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:clients_profile, UserBioData.changeset(clients_profile, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{clients_profile: clients_profile} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated the profile Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{clients_profile: clients_profile, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Updated the profile successfully!")
        |> redirect(to: Routes.individual_path(conn, :customer_360_view))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.individual_path(conn, :customer_360_view))
    end
  end


  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:client, :create}
      act when act in ~w(index view)a -> {:client, :view}
      act when act in ~w(update edit)a -> {:client, :edit}
      act when act in ~w(change_status)a -> {:client, :change_status}
      _ -> {:client, :unknown}
    end
  end

end
