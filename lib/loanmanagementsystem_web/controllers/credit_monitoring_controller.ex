defmodule LoanmanagementsystemWeb.CreditMonitoringController do
  use LoanmanagementsystemWeb, :controller
  use Ecto.Schema
  import Ecto.Query, warn: false
  require Logger

  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Accounts.UserBioData

  plug(
    LoanmanagementsystemWeb.Plugs.RequireAuth
    when action in [
           :user_creation,
           :student_dashboard
         ]
  )

  plug(
    LoanmanagementsystemWeb.Plugs.EnforcePasswordPolicy
    when action not in [
           :new_password,
           :change_password,
           :user_creation,
           :student_dashboard
         ]
  )

  def loan_rescheduling(conn, _params) do
    rescheduling = Loanmanagementsystem.Accounts.loan_details()
    render(conn, "loan_rescheduling.html", rescheduling: rescheduling)
  end

  def loan_portifolio(conn, _params) do
    render(conn, "loan_portifolio.html")
  end

  def loan_portifolio_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loan_portifolio_list(search_params, start, length)
    total_entries = total_entries(results)
    entries = entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }

    json(conn, results)
  end



  def total_entries(%{total_entries: total_entries}), do: total_entries
  def total_entries(_), do: 0

  def entries(%{entries: entries}), do: entries
  def entries(_), do: []

  def search_options(params) do
    length = calculate_page_size(params["length"])
    page = calculate_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def calculate_page_num(nil, _), do: 1

  def calculate_page_num(start, length) do
    start = String.to_integer(start)
    round(start / length + 1)
  end

  def calculate_page_size(nil), do: 10
  def calculate_page_size(length), do: String.to_integer(length)

  def edit_loan_details(conn, params) do
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_loan,
      Loans.changeset(
        Loanmanagementsystem.Loan.get_loans!(params["id"]),
        Map.merge(params, %{
          "account_no" => params["account_no"],
          "account_name" => params["account_name"],
          "branch_name" => params["branch_name"],
          "bank_name" => params["bank_name"]
        })
      )
    )
    |> Ecto.Multi.run(:update_user_bio_data, fn _repo, %{update_loan: _update_loan} ->
      UserBioData.changeset(user_bio_data, %{
        dateOfBirth: params["dateOfBirth"],
        emailAddress: params["emailAddress"],
        firstName: params["firstName"],
        gender: params["gender"],
        lastName: params["lastName"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
        meansOfIdentificationType: params["meansOfIdentificationType"],
        mobileNumber: params["mobileNumber"],
        otherName: params["otherName"],
        title: params["title"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       update_loan: _update_loan,
                                       update_user_bio_data: _update_user_bio_data
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated  Loan Details Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the Loan Details")
        |> redirect(to: Routes.credit_monitoring_path(conn, :loan_rescheduling))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.credit_monitoring_path(conn, :loan_rescheduling))
    end
  end

  def activate_loan_reschedule(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_loan,
      Loans.changeset(
        Loanmanagementsystem.Loan.get_loans!(params["id"]),
        Map.merge(params, %{"loan_status" => "ACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_loan: _activate_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated Loan Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "You Have Activated The Loan Successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def deactivate_loan_reschedule(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_loan,
      Loans.changeset(
        Loanmanagementsystem.Loan.get_loans!(params["id"]),
        Map.merge(params, %{"loan_status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_loan: _activate_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Dectivated Loan Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "You Have Dectivated The Loan Successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def loan_write_offs(conn, _params), do: render(conn, "loan_write_offs.html")

  def clients_loan_portfolio_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.clients_loan_portfolio(search_params, start, length)
    total_entries = total_entries(results)
    entries = entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }

    json(conn, results)
  end

  def total_entries(%{total_entries: total_entries}), do: total_entries
  def total_entries(_), do: 0

  def entries(%{entries: entries}), do: entries
  def entries(_), do: []

  def search_options(params) do
    length = calculate_page_size(params["length"])
    page = calculate_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def calculate_page_num(nil, _), do: 1

  def calculate_page_num(start, length) do
    start = String.to_integer(start)
    round(start / length + 1)
  end

  def calculate_page_size(nil), do: 10
  def calculate_page_size(length), do: String.to_integer(length)

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
