defmodule LoanmanagementsystemWeb.CreditManagementController do
  use LoanmanagementsystemWeb, :controller
  use Ecto.Schema
  import Ecto.Query, warn: false
  require Logger

  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole}
  alias Loanmanagementsystem.Companies.Employee
  alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Employment.Personal_Bank_Details
  alias Loanmanagementsystem.Companies.{Client_company_details}
  alias Loanmanagementsystem.Maintenance.{District, Country, Province}
  alias Loanmanagementsystem.Emails.Email

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

  def credit_management(conn, _params) do
    render(conn, "credit_management.html")
  end

  def employee_maintenance(conn, _request) do
    employee =
      Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.roleType != "EMPLOYEE"))

    companies = Loanmanagementsystem.Companies.list_tbl_company()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()

    render(conn, "employee_maintenance.html",
      employee: employee,
      banks: banks,
      branches: branches,
      departments: departments,
      companies: companies
    )
  end

  def create_employee_user(conn, params) do
    IO.inspect(params, label: "Param print out")
    otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_employer_user,
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y",
        company_id: params["company_id"],
        pin: otp
      })
    )
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo, %{add_employer_user: add_employer_user} ->
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
        userId: add_employer_user.id,
        idNo: nil,
        bank_id: params["bank_id"],
        bank_account_number: params["bank_account_number"],
        marital_status: params["marital_status"],
        nationality: params["nationality"],
        number_of_dependants: params["number_of_dependants"],
        disability_status: params["disability_status"],
        disability_detail: params["disability_detail"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_employer_user: add_employer_user,
                                           add_user_bio_data: _add_user_bio_data
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: "EMPLOYEE",
        status: "INACTIVE",
        client_type: params["client_type"],
        userId: add_employer_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_client_company, fn _repo,
                                              %{
                                                add_employer_user: add_employer_user,
                                                add_user_bio_data: _add_user_bio_data,
                                                add_user_role: add_user_role
                                              } ->
      Client_company_details.changeset(%Client_company_details{}, %{
        company_name: params["company_name"],
        company_account_number: params["company_account_number"],
        company_phone: params["company_phone"],
        company_registration_date: params["company_registration_date"],
        contact_email: params["contact_email"],
        registration_number: params["registration_number"],
        taxno: params["taxno"],
        bank_id: params["bank_id"],
        status: "INACTIVE",
        createdByUserId: add_employer_user.id,
        createdByUserRoleId: add_user_role.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_employer_employee, fn _repo,
                                                 %{
                                                   add_user_role: add_user_role,
                                                   add_employer_user: add_employer_user,
                                                   add_user_bio_data: _add_user_bio_data
                                                 } ->
      Employee.changeset(%Employee{}, %{
        companyId: params["company_id"],
        employerId: params["company_id"],
        status: "INACTIVE",
        userId: add_employer_user.id,
        userRoleId: add_user_role.id,
        loan_limit: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_address_details, fn _repo,
                                               %{
                                                 add_user_role: _add_user_role,
                                                 add_employer_user: add_employer_user,
                                                 add_user_bio_data: _add_user_bio_data,
                                                 add_employer_employee: _add_employer_employee
                                               } ->
      Address_Details.changeset(%Address_Details{}, %{
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        userId: add_employer_user.id,
        year_at_current_address: params["year_at_current_address"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_employment_details, fn _repo,
                                                  %{
                                                    add_employer_employee: _add_employer_employee,
                                                    add_address_details: _add_address_details,
                                                    add_employer_user: add_employer_user,
                                                    add_user_bio_data: _add_user_bio_data
                                                  } ->
      Employment_Details.changeset(%Employment_Details{}, %{
        area: params["area"],
        date_of_joining: params["date_of_joining"],
        employee_number: params["employee_number"],
        employer: params["employer"],
        employer_industry_type: params["employer_industry_type"],
        employer_office_building_name: params["employer_office_building_name"],
        employer_officer_street_name: params["employer_officer_street_name"],
        employment_type: params["employment_type"],
        hr_supervisor_email: params["hr_supervisor_email"],
        hr_supervisor_mobile_number: params["hr_supervisor_mobile_number"],
        hr_supervisor_name: params["hr_supervisor_name"],
        job_title: params["job_title"],
        occupation: params["occupation"],
        province: params["province"],
        town: params["town"],
        userId: add_employer_user.id,
        departmentId: params["departmentId"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_Personal_details, fn _repo,
                                                %{
                                                  add_employer_employee: _add_employer_employee,
                                                  add_address_details: _add_address_details,
                                                  add_employer_user: add_employer_user,
                                                  add_user_bio_data: _add_user_bio_data
                                                } ->
      Personal_Bank_Details.changeset(%Personal_Bank_Details{}, %{
        accountName: params["accountName"],
        accountNumber: params["bank_account_number"],
        bankName: params["bankName"],
        branchName: params["branchName"],
        upload_bank_statement: nil,
        userId: add_employer_user.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_Personal_details: _add_Personal_details,
                                       add_employer_employee: _add_employer_employee,
                                       add_address_details: _add_address_details,
                                       add_employer_user: _add_employer_user,
                                       add_user_bio_data: _add_user_bio_data
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Added User Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_user_bio_data: add_user_bio_data}} ->
        Email.send_email(params["emailAddress"], params["password"])

        conn
        |> put_flash(
          :info,
          "You have Successfully Created #{add_user_bio_data.firstName} #{add_user_bio_data.lastName} Aa A Client"
        )
        |> redirect(to: Routes.credit_management_path(conn, :employee_maintenance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.credit_management_path(conn, :employee_maintenance))
    end
  end

  def mobile_money_agent(conn, _request), do: render(conn, "mobile_money_agent.html")
  def msme_maintenance(conn, _request), do: render(conn, "msme_maintenance.html")
  def client_transfer(conn, _request), do: render(conn, "client_transfer.html")
  def blacklist_client(conn, _request), do: render(conn, "blacklist_client.html")
  def quick_advance_application(conn, _params), do: render(conn, "quick_advance_application.html")
  def quick_loan_application(conn, _params), do: render(conn, "quick_loan_application.html")
  def float_advance_application(conn, _params), do: render(conn, "float_advance_application.html")
  def order_finance(conn, _params), do: render(conn, "order_finance.html")
  def invoice_discouting(conn, _params), do: render(conn, "invoice_discouting.html")
  def clint_statements(conn, _params), do: render(conn, "clint_statements.html")

  def loan_appraisal(conn, _params),
    do:
      render(conn, "loan_appraisal.html",
        loan_details: Loanmanagementsystem.OperationsServices.get_loan_details_for_appraisal()
      )

  def loan_approval_and_disbursements(conn, _params),
    do: render(conn, "loan_approval_and_disbursements.html")

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

  def loan_approval_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results =
      Loanmanagementsystem.Loan.loan_approval_and_disbursement_list(search_params, start, length)

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

  def debit_mandate_management(conn, _params), do: render(conn, "debit_mandate_management.html")

  def collection_schedule_generation(conn, _params),
    do: render(conn, "collection_schedule_generation.html")

  def repayment_maintenance(conn, _params), do: render(conn, "repayment_maintenance.html")

  def loan_repayment_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results =  Loanmanagementsystem.Loan.loan_repayment_list(search_params, start, length)
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


  def view_loan_apriasal(conn, params) do
    IO.inspect(params["userId"], label: "inspections")
    userId = params["userId"]
    users = Loanmanagementsystem.OperationsServices.get_user_by_id(userId)

    loan_details =
      Loanmanagementsystem.OperationsServices.get_loan_details_for_appraisal_by_userId(userId)

    IO.inspect(loan_details, label: "inspections")

    render(conn, "view_loan_apraisal.html",
      loan_details: loan_details,
      users: users,
      userId: userId
    )
  end


  def customer_loan_apraisals_item_lookup(conn, params) do
    IO.inspect(params, label: "inspections")
    userId = params["userId"]
    {draw, start, length, search_params} = search_options(params)

    results =
      Loanmanagementsystem.Loan.customer_loan_apraisals_list(search_params, start, length, userId)

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

  def updating_loan_limit(conn, params) do
    userrole = Loanmanagementsystem.Accounts.get_userRole_by_userId(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_loan_limit, UserRole.changeset(userrole, Map.merge(params, %{"loan_limit" => params["loan_limit"]})))
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       update_loan_limit: _update_loan_limit

                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Updated Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
     |> case do
      {:ok, _} ->
        conn
        |> put_flash(
          :info,
          "You have Successfully Updated Successfully"
        )
        |> redirect(
          to: Routes.credit_management_path(conn, :loan_appraisal)
        )

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(
          to: Routes.credit_management_path(conn, :loan_appraisal)
        )
    end
  end

  @headers ~w/ country province district /a

  def handle__district_bulk_upload(conn, params) do
    user = conn.assigns.user
    {key, msg, _invalid} = handle_file_upload(user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.system_management_path(conn, :district))
    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.system_management_path(conn, :district))
    end
  end

  defp handle_file_upload(user, params) do
    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
      user
      |> process_bulk_upload(filename, destin_path)
      |> case do
        {:ok, {invalid, valid}} ->
          {:info, "#{valid} Successful entrie(s) and #{invalid} invalid entrie(s)", invalid}

        {:error, reason} ->
          {:error, reason, 0}
      end
    else
      {:error, reason} ->
        {:error, reason, 0}
    end
  end

  def process_csv(file) do
    case File.exists?(file) do
      true ->
        data =
          File.stream!(file)
          |> CSV.decode!(separator: ?,, headers: true)
          |> Enum.map(& &1)

        {:ok, data}

      false ->
        {:error, "File does not exist"}
    end
  end

  def process_bulk_upload(user, filename, path) do
    {:ok, items} = extract_xlsx(path)

    prepare_bulk_params(user, filename, items)
    |> Repo.transaction(timeout: 290_000)
    |> case do
      {:ok, multi_records} ->
        {invalid, valid} =
          multi_records
          |> Map.values()
          |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->
            case item do
              %{districtfile_name: _src} -> {invalid, valid + 1}
              %{col_index: _index} -> {invalid + 1, valid}
              _ -> {invalid, valid}
            end
          end)

        {:ok, {invalid, valid}}

      {:error, _, changeset, _} ->
        reason = traverse_errors(changeset.errors) |> Enum.join("\r\n")
        {:error, reason}
    end
  end

  defp prepare_bulk_params(_user, _filename, items) do
    items
    |> Stream.with_index(2)
    |> Stream.map(fn {item, index} ->

      provinceId = try do Province.find_by(name: item.province).id rescue _-> "" end

      countryId = try do Country.find_by(name: item.country).id rescue _-> "" end

      other_details = %{
        countryName: item.country,
        provinceName: item.province,
        name: item.district,
        countryId: countryId,
        provinceId: provinceId
      }

      changeset = District.changeset(%District{}, Map.merge(item, other_details))
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset)
    end)
    |> Enum.reject(fn
      %{operations: [{_, {:run, _}}]} -> false
      %{operations: [{_, {_, changeset, _}}]} -> changeset.valid? == false
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
  end

  # ---------------------- file persistence --------------------------------------
  def is_valide_file(%{"districtfile_name" => params}) do
    if upload = params do
      case Path.extname(upload.filename) do
        ext when ext in ~w(.xlsx .XLSX .xls .XLS .csv .CSV) ->
          with {:ok, destin_path} <- persist(upload) do
            case ext not in ~w(.csv .CSV) do
              true ->
                case Xlsxir.multi_extract(destin_path, 0, false, extract_to: :memory) do
                  {:ok, table_id} ->
                    row_count = Xlsxir.get_info(table_id, :rows)
                    Xlsxir.close(table_id)
                    {:ok, upload.filename, destin_path, row_count - 1}

                  {:error, reason} ->
                    {:error, reason}
                end

              _ ->
                {:ok, upload.filename, destin_path, "N(count)"}
            end
          else
            {:error, reason} ->
              {:error, reason}
          end

        _ ->
          {:error, "Invalid File Format"}
      end
    else
      {:error, "No File Uploaded"}
    end
  end

  def csv(path, upload) do
    case process_csv(path) do
      {:ok, data} ->
        row_count = Enum.count(data)

        case row_count do
          rows when rows in 1..100_000 ->
            {:ok, upload.filename, path, row_count}

          _ ->
            {:error, "File records should be between 1 to 100,000"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def persist(%Plug.Upload{filename: filename, path: path}) do
    destin_path = "C:/CountriesUploads/file" |> default_dir()
    destin_path = Path.join(destin_path, filename)

    {_key, _resp} =
      with true <- File.exists?(destin_path) do
        {:error, "File with the same name aready exists"}
      else
        false ->
          File.cp(path, destin_path)
          {:ok, destin_path}
      end
  end

  def default_dir(path) do
    File.mkdir_p(path)
    path
  end

  def extract_xlsx(path) do
    case Xlsxir.multi_extract(path, 0, false, extract_to: :memory) do
      {:ok, id} ->
        items =
          Xlsxir.get_list(id)
          |> Enum.reject(&Enum.empty?/1)
          |> Enum.reject(&Enum.all?(&1, fn item -> is_nil(item) end))
          |> List.delete_at(0)
          |> Enum.map(
            &Enum.zip(
              Enum.map(@headers, fn h -> h end),
              Enum.map(&1, fn v -> strgfy_term(v) end)
            )
          )
          |> Enum.map(&Enum.into(&1, %{}))
          |> Enum.reject(&(Enum.join(Map.values(&1)) == ""))

        Xlsxir.close(id)
        {:ok, items}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp strgfy_term(term) when is_tuple(term), do: term
  defp strgfy_term(term) when not is_tuple(term), do: String.trim("#{term}")


  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
