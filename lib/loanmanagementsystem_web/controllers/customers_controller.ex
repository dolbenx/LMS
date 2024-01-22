defmodule LoanmanagementsystemWeb.CustomersController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  use Ecto.Schema

  alias Loanmanagementsystem.Repo
  # alias Loanmanagementsystem.Accounts.User
  # alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.UserBioData
  # alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Accounts

  def company(conn, _params),
    do:
      render(conn, "companies.html",
        companies:
          Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isEmployer != true)),
        banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
        branches: Loanmanagementsystem.Maintenance.list_tbl_branch(),
        classifications: Loanmanagementsystem.Maintenance.list_tbl_classification()
      )

  def offtaker(conn, _params),
    do:
      render(conn, "offtaker.html",
        companies:
          Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isOfftaker != true)),
        banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
        branches: Loanmanagementsystem.Maintenance.list_tbl_branch(),
        classifications: Loanmanagementsystem.Maintenance.list_tbl_classification()
      )

  def individuals(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")
    # current_user_details = Accounts.get_details(currentUserRole.userId)
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    users = Loanmanagementsystem.Accounts.get_system_admin()

    classifications = Loanmanagementsystem.Maintenance.list_tbl_classification()

    render(conn, "individuals.html",
      individual_customer: Loanmanagementsystem.Accounts.get_loan_customer_individual(),
      banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users,
      classifications: classifications
    )
  end

  def smes(conn, _params),
    do:
      render(conn, "Smes.html",
        companies:
          Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isSme != true)),
        banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
        branches: Loanmanagementsystem.Maintenance.list_tbl_branch(),
        classifications: Loanmanagementsystem.Maintenance.list_tbl_classification()
      )

  @spec otc(Plug.Conn.t(), any) :: Plug.Conn.t()
  def otc(conn, _params),
    do:
      render(conn, "otc.html",
        individual_customer: Loanmanagementsystem.Accounts.get_loan_customer_individual(),
        product_details:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "ACTIVE"))
      )

  def otc_logs(conn, _params),
    do:
      render(conn, "otc_log.html",
        individual_customer: Loanmanagementsystem.Accounts.get_loan_customer_individual(),
        loan_details: Loanmanagementsystem.Loan.oct_loan_customer()
      )

  @spec admin_loan_repayment(Plug.Conn.t(), any) :: Plug.Conn.t()
  def admin_loan_repayment(conn, _params),
    do:
      render(conn, "repayment.html",
        repays: Loanmanagementsystem.Loan.get_list_tbl_loan_repayment()
      )

  def oct_customer_lookup(conn, %{"meansOfIdentificationNumber" => meansOfIdentificationNumber}) do
    user_details = Loanmanagementsystem.Accounts.otc_user_lookup(meansOfIdentificationNumber)
    json(conn, %{"data" => List.wrap(user_details)})
  end

  def oct_product_lookup(conn, %{"product_id" => product_id}) do
    product_details = Loanmanagementsystem.Products.otc_product_details_lookup(product_id)
    json(conn, %{"data" => List.wrap(product_details)})
  end

  def oct_loan_application(conn, params) do
    otp = to_string(Enum.random(1111..9999))

    if params["user_id_data"] != "" do
      new_params =
        Map.merge(params, %{
          "customer_id" => params["user-id-data"],
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => params["currency_code"],
          "loan_type" => params["product_type"],
          "principal_amount" => params["amount"]
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
          |> redirect(to: Routes.customers_path(conn, :otc_logs))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.customers_path(conn, :otc_logs))
      end
    else
      ############## create user

      my_password = LoanmanagementsystemWeb.UserController.random_string()

      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :add_user,
        User.changeset(%User{}, %{
          password: my_password,
          status: "INACTIVE",
          username: params["emailAddress"],
          auto_password: "Y"
        })
      )
      |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
        UserRole.changeset(%UserRole{}, %{
          roleType: params["roleType"],
          status: "INACTIVE",
          userId: add_user.id,
          otp: otp
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                               %{
                                                 add_user: add_user,
                                                 add_user_role: _add_user_role
                                               } ->
        UserBioData.changeset(%UserBioData{}, %{
          dateOfBirth: params["dateOfBirth"],
          emailAddress: params["emailAddress"],
          firstName: params["firstName"],
          gender: params["gender"],
          lastName: params["lastName"],
          meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
          meansOfIdentificationType: params["meansOfIdentificationType"],
          mobileNumber: params["mobileNumber"],
          otherName: params["otherName"],
          title: params["title"],
          userId: add_user.id,
          idNo: nil
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:user_logs, fn _repo,
                                       %{
                                         add_user: _add_user,
                                         add_user_role: _add_user_role,
                                         add_user_bio_data: _add_user_bio_data
                                       } ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "user creations and loan application Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:loan_application, fn _repo,
                                              %{add_user: add_user, add_user_role: _add_user_role} ->
        Loans.changeset(%Loans{}, %{
          "customer_id" => add_user.id,
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => params["currency_code"],
          "loan_type" => params["product_type"],
          "principal_amount" => params["amount"]
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_user: _add_user}} ->
          conn
          |> put_flash(:info, "Loan Application Submitted")
          |> redirect(to: Routes.customers_path(conn, :otc_logs))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.customers_path(conn, :otc_logs))
      end
    end
  end

  def customer_loan_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.customer_loans(search_params, start, length)
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

  alias Loanmanagementsystem.Companies.Paths
  alias Loanmanagementsystem.Companies.Documents

  def upload_documents(update, %{"document" => file}) do
    path = Repo.one(from m in Paths, where: m.name == ^"USER")

    case path != nil do
      true ->
        with {:ok, doc} <- validate_document(file) do
          Ecto.Multi.new()
          |> Ecto.Multi.insert(
            :docx,
            Documents.changeset(%Documents{}, %{
              update: update.id,
              name: "#{update.id}#{file.filename}",
              path_id: path.id
            })
          )
          |> Ecto.Multi.run(:upload, fn _REPO_, %{docx: _docx} ->
            upload(path.path, doc, update.id)
          end)
          |> Repo.transaction()
          |> case do
            {:ok, %{docx: _docx}} ->
              {:ok, "successfully inserted and uploaded documents"}

            {:error, _failed_operation, failed_value, _changes_so_far} ->
              File.rm("#{path.path}/#{update.id}#{file.filename}")
              {:error, %{errors: traverse_errors(failed_value.errors) |> List.first()}}
          end
        else
          {:error, msg} -> {:error, %{errors: msg}}
        end

      false ->
        {:error, %{errors: "Failed to upload documents kindly contact the system administrator"}}
    end
  end

  def validate_document(file) do
    with true <- Enum.member?([".PDF", ".Pdf", ".pdf"], Path.extname(file.filename)) do
      {:ok, file}
    else
      false ->
        {:error, "Kindly upload a \"PDF\" document or convert the one you have to \"PDF\" "}
    end
  end

  def upload(path, doc, company_id) do
    with :ok <- File.cp(doc.path, "#{path}/#{company_id}#{doc.filename}") do
      {:ok, "success"}
    else
      _ANYTHING_ELSE -> {:error, %{errors: "Failed to upload documents"}}
    end
  end

  def update_user_data(conn, %{"user_id" => user_id} = params) do
    IO.inspect(params, label: "Am here MAN ####")

    user_details = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(user_id)
    user = conn.assigns.user

    handle_update(user, user_details, Map.put(params, "checker_id", user.id))
    |> Repo.transaction()
    |> case do
      {:ok, %{update: _update, insert: _insert}} ->
        conn
        |> put_flash(:info, "User updated successful")
        |> redirect(to: Routes.user_path(conn, :employee_dashboard))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :employee_dashboard))
    end
  end

  defp handle_update(user, user_details, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update,
      Loanmanagementsystem.Accounts.UserBioData.changeset(user_details, params)
    )
    |> Ecto.Multi.run(:insert, fn _repo, %{update: update} ->
      activity = "Updated User \"#{update.id}\""

      user_logs = %{
        user_id: user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()

      upload_documents(update, params)
    end)
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
