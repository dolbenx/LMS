defmodule LoanmanagementsystemWeb.OfftakerController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.Loans
  # alias Loanmanagementsystem.Loan.Loan_applicant_collateral
  alias Loanmanagementsystem.Emails.Email





  def offtaker_pending_loans(conn, _params), do: render(conn, "offtaker_pending_loans.html")
  def offtaker_loan_tracker(conn, _params), do: render(conn, "offtaker_loan_tracker.html")
  def offtaker_loan_repayment(conn, _params), do: render(conn, "offtaker_loan_repayment.html")



  def offtaker_pending_loans_item_lookup(conn, params) do
    company_id = conn.assigns.user.company_id

    IO.inspect(company_id, label: "--------------------------company_id")
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.offtaker_pending_loans_list(search_params, start, length, company_id)
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

  # def customer_pending_item_lookup(conn, params) do
  #   {draw, start, length, search_params} = search_options(params)
  #   results = Loanmanagementsystem.Loan.customer_pending_list(search_params, start, length)
  #   total_entries = total_entries(results)
  #   entries = entries(results)

  #   results = %{
  #     draw: draw,
  #     recordsTotal: total_entries,
  #     recordsFiltered: total_entries,
  #     data: entries
  #   }

  #   json(conn, results)
  # end

  # def customer_disbursed_item_lookup(conn, params) do
  #   {draw, start, length, search_params} = search_options(params)
  #   results = Loanmanagementsystem.Loan.customer_disbursed_list(search_params, start, length)
  #   total_entries = total_entries(results)
  #   entries = entries(results)

  #   results = %{
  #     draw: draw,
  #     recordsTotal: total_entries,
  #     recordsFiltered: total_entries,
  #     data: entries
  #   }

  #   json(conn, results)
  # end

  # def quick_advance_loan_item_lookup(conn, params) do
  #   {draw, start, length, search_params} = search_options(params)
  #   results = Loanmanagementsystem.Loan.loan_application_listing(search_params, start, length)
  #   total_entries = total_entries(results)
  #   entries = entries(results)

  #   results = %{
  #     draw: draw,
  #     recordsTotal: total_entries,
  #     recordsFiltered: total_entries,
  #     data: entries
  #   }

  #   json(conn, results)
  # end
    def offtaker_approval_with_documents(conn, params) do

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])

      email_address = try do Loanmanagementsystem.Companies.Company.find_by(id: params["customer_id"]).contactEmail rescue _-> nil end


      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "PENDING_CLIENT_CONFIRMATION",
          "status"=> "PENDING_CLIENT_CONFIRMATION"
        })

      ))
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
        user_logs = %{
          activity: "Offtaker Approval and Document Upload Successful",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads.invoice_loan_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => update_loan_status.id}, params)
      end)
      |>Repo.transaction()
      |>case do
        {:ok, _ } ->
          Email.send_to_client_approval(email_address)
          conn
          |>put_flash(:info, "You have Successfully Approved the Loan and Uploaded the required documents")
          |>redirect(to: Routes.offtaker_path(conn, :offtaker_pending_loans))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.offtaker_path(conn, :offtaker_pending_loans))
      end
    end


    def offtaker_reject_without_documents(conn, params) do
      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])


      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "REJECTED_BY_OFFTAKER",
          "status"=> "REJECTED_BY_OFFTAKER",
          "reason" => params["reason"]
        })

      ))
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
        user_logs = %{
          activity: "Offtaker Rejected Successful",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Repo.transaction()
      |>case do
        {:ok, _ } ->
          conn
          |>put_flash(:info, "You have Successfully Rejected the Loan")
          |>redirect(to: Routes.offtaker_path(conn, :offtaker_pending_loans))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.offtaker_path(conn, :offtaker_pending_loans))
      end
    end




  def offtaker_approval_details(conn, %{"userId" => userId, "company_id"=> company_id, "loan_id"=> loan_id } = params) do
    IO.inspect(params, label: "--------------------------------------------------- params")
    loans = Loanmanagementsystem.Operations.get_loan_by_id!(loan_id)
    employer_doc = Loanmanagementsystem.Operations.get_offtaker_client_docs(loan_id,userId )
    companies = Loanmanagementsystem.Operations.get_company_by_id_offtaker(company_id, userId, loan_id)
    render(conn, "offtaker_approval_details.html", companies: companies, employer_doc: employer_doc, loans: loans)
  end




  def offtaker_approval_reject_details(conn, %{"userId" => userId, "company_id"=> company_id, "loan_id"=> loan_id } = params) do
    IO.inspect(params, label: "--------------------------------------------------- params")
    loans = Loanmanagementsystem.Operations.get_loan_by_id!(loan_id)
    employer_doc = Loanmanagementsystem.Operations.get_offtaker_client_docs(loan_id,userId )
    companies = Loanmanagementsystem.Operations.get_company_by_id_offtaker(company_id, userId, loan_id)
    render(conn, "offtaker_approval_reject_details.html", companies: companies, employer_doc: employer_doc, loans: loans)
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

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end

end
