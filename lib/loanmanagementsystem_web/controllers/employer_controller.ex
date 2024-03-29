defmodule LoanmanagementsystemWeb.EmployerController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false

  alias Loanmanagementsystem.Logs.UserLogs
  # alias Loanmanagementsystem.Emails.Email
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole}
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Companies.{Employee, Employee_account}
  alias Loanmanagementsystem.Products.Product
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Accounts.Customer_account
  alias Loanmanagementsystem.Employment.{Employee_Maintenance}
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Companies.Company


  plug LoanmanagementsystemWeb.Plugs.Authenticate,
      [module_callback: &LoanmanagementsystemWeb.EmployerController.authorize_role/1]
      when action not in [
          :all_staffs,
          :calculate_page_num,
          :calculate_page_size,
          :caplock,
          :company_all_loans,
          :csv,
          :default_dir,
          :employer_activate_employee,
          :employer_all_loans,
          :employer_create_admin_employee,
          :employer_create_employee,
          :employer_deactivate_employee,
          :employer_deactivate_employee_admin,
          :employer_disbursed_loans,
          :employer_employee_all_loans,
          :employer_employee_all_loans_list_item_lookup,
          :employer_employee_disbursed_loans,
          :employer_employee_disbursed_loans_list_item_lookup,
          :employer_employee_loan_products,
          :employer_employee_pending_loans,
          :employer_employee_pending_loans_list_item_lookup,
          :employer_employee_rejected_loans,
          :employer_employee_rejected_loans_list_item_lookup,
          :employer_pending_loans,
          :employer_rejected_loans,
          :employer_transaction_reports,
          :employer_update_employee,
          :employer_user_logs,
          :entries,
          :extract_xlsx,
          :generate_random_password,
          :handle_staff_bulk_upload,
          :is_valide_file,
          :number,
          :number2,
          :parse_image,
          :password_render,
          :persist,
          :process_bulk_upload,
          :process_csv,
          :random_string,
          :search_options,
          :small_latter,
          :small_latter2,
          :special,
          :staff_all_loans,
          :total_entries,
          :traverse_errors,
          :user_mgt,
          :client_approval_details,
          :approve_client_invoice_discounting_application,
          :employer_activate_employee_admin,
          :handle_bulk_creation
       ]

use PipeTo.Override


  def employer_employee_all_loans(conn, _params) do
    current_user = get_session(conn, :current_user)
    current_user_role = get_session(conn, :current_user_role)

    # IO.inspect("%%%%%%%%%%START current_user%%%%%%%%%%%%%")
    # IO.inspect(current_user)
    # IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

    if(current_user_role.roleType == "EMPLOYER") do
      query =
        from cl in Loanmanagementsystem.Loan.Loans,
          join: user in User,
          join: userBioData in UserBioData,
          join: userRole in UserRole,
          join: loanProduct in Product,
          on:
            cl.customer_id == user.id and
              cl.loan_userroleid == userRole.id and
              cl.product_id == loanProduct.id and
              user.id == userBioData.userId,
          where:
            cl.company_id == ^conn.assigns.user.company_id and
              (userRole.roleType == ^"EMPLOYEE" or
                 userRole.roleType == ^"ADMIN_EMPLOYER_INITIATOR" or
                 userRole.roleType == ^"ADMIN_EMPLOYER_APPROVER"),
          select: %{
            cl: cl,
            user: user,
            userRole: userRole,
            userBioData: userBioData,
            loanProduct: loanProduct
          }

      loan_transaction = Repo.all(query)

      # IO.inspect("%%%%%%%%%%START loan_transaction%%%%%%%%%%%%%")
      # IO.inspect(loan_transaction)
      # IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")
      render(conn, "employee_all_loans.html", loan_transaction: loan_transaction)
    end
  end

  def employer_employee_disbursed_loans(conn, _params) do
    current_user = get_session(conn, :current_user)
    current_user_role = get_session(conn, :current_user_role)

    IO.inspect("%%%%%%%%%%START current_user%%%%%%%%%%%%%")
    IO.inspect(current_user)
    IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

    if(current_user_role.roleType == "EMPLOYER") do
      query =
        from cl in Loanmanagementsystem.Loan.Loans,
          join: user in User,
          join: userBioData in UserBioData,
          join: userRole in UserRole,
          join: loanProduct in Product,
          on:
            cl.customer_id == user.id and
              cl.loan_userroleid == userRole.id and
              cl.product_id == loanProduct.id and
              user.id == userBioData.userId,
          where:
            cl.company_id == ^conn.assigns.user.company_id and cl.status == ^"DISBURSED" and
              (userRole.roleType == ^"EMPLOYEE" or
                 userRole.roleType == ^"ADMIN_EMPLOYER_INITIATOR" or
                 userRole.roleType == ^"ADMIN_EMPLOYER_APPROVER"),
          select: %{
            cl: cl,
            user: user,
            userRole: userRole,
            userBioData: userBioData,
            loanProduct: loanProduct
          }

      loan_transaction = Repo.all(query)

      IO.inspect("%%%%%%%%%%START loan_transaction%%%%%%%%%%%%%")
      IO.inspect(loan_transaction)
      IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")
      render(conn, "employee_disbursed_loan.html", loan_transaction: loan_transaction)
    end
  end

  def employer_employee_pending_loans(conn, _params) do
    current_user = get_session(conn, :current_user)
    current_user_role = get_session(conn, :current_user_role)

    IO.inspect("%%%%%%%%%%START current_user%%%%%%%%%%%%%")
    IO.inspect(current_user)
    IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

    if(current_user_role.roleType == "EMPLOYER") do
      query =
        from cl in Loanmanagementsystem.Loan.Loans,
          join: user in User,
          join: userBioData in UserBioData,
          join: userRole in UserRole,
          join: loanProduct in Product,
          on:
            cl.customer_id == user.id and
              cl.loan_userroleid == userRole.id and
              cl.product_id == loanProduct.id and
              user.id == userBioData.userId,
          where:
            cl.company_id == ^conn.assigns.user.company_id and cl.status == ^"PENDING" and
              (userRole.roleType == ^"EMPLOYEE" or
                 userRole.roleType == ^"ADMIN_EMPLOYER_INITIATOR" or
                 userRole.roleType == ^"ADMIN_EMPLOYER_APPROVER"),
          select: %{
            cl: cl,
            user: user,
            userRole: userRole,
            userBioData: userBioData,
            loanProduct: loanProduct
          }

      loan_transaction = Repo.all(query)

      IO.inspect("%%%%%%%%%%START loan_transaction%%%%%%%%%%%%%")
      IO.inspect(loan_transaction)
      IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

      render(conn, "employee_pending_loans.html", loan_transaction: loan_transaction)
    end
  end

  def employer_employee_rejected_loans(conn, _params) do
    # current_user = get_session(conn, :current_user);
    current_user_role = get_session(conn, :current_user_role)

    IO.inspect("%%%%%%%%%%START company%%%%%%%%%%%%%")
    IO.inspect(conn.assigns.user.company_id)
    IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

    if(current_user_role.roleType == "EMPLOYER") do
      query =
        from cl in Loanmanagementsystem.Loan.Loans,
          join: user in User,
          join: userBioData in UserBioData,
          join: userRole in UserRole,
          join: loanProduct in Product,
          on:
            cl.customer_id == user.id and
              cl.loan_userroleid == userRole.id and
              cl.product_id == loanProduct.id and
              user.id == userBioData.userId,
          where:
            cl.company_id == ^conn.assigns.user.company_id and cl.status == ^"REJECTED" and
              (userRole.roleType == ^"EMPLOYEE" or
                 userRole.roleType == ^"ADMIN_EMPLOYER_INITIATOR" or
                 userRole.roleType == ^"ADMIN_EMPLOYER_APPROVER"),
          select: %{
            cl: cl,
            user: user,
            userRole: userRole,
            userBioData: userBioData,
            loanProduct: loanProduct
          }

      loan_transaction = Repo.all(query)

      IO.inspect("%%%%%%%%%%START loan_transaction%%%%%%%%%%%%%")
      IO.inspect(loan_transaction)
      IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

      render(conn, "employee_rejected_loans.html", loan_transaction: loan_transaction)
    end
  end

  def employer_all_loans(conn, _params) do
    current_user = get_session(conn, :current_user)
    current_user_role = get_session(conn, :current_user_role)

    IO.inspect("%%%%%%%%%%START current_user%%%%%%%%%%%%%")
    IO.inspect(current_user)
    IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

    if(current_user_role.roleType == "EMPLOYER") do
      query =
        from cl in Loanmanagementsystem.Loan.Loans,
          join: user in User,
          join: userBioData in UserBioData,
          join: userRole in UserRole,
          join: loanProduct in Product,
          on:
            cl.customer_id == user.id and
              cl.loan_userroleid == userRole.id and
              cl.product_id == loanProduct.id and
              user.id == userBioData.userId,
          where:
            cl.company_id == ^conn.assigns.user.company_id and userRole.roleType == ^"EMPLOYER",
          select: %{
            cl: cl,
            user: user,
            userRole: userRole,
            userBioData: userBioData,
            loanProduct: loanProduct
          }

      loan_transaction = Repo.all(query)

      IO.inspect("%%%%%%%%%%START loan_transaction%%%%%%%%%%%%%")
      IO.inspect(loan_transaction)
      IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")
      render(conn, "employer_all_loans.html", loan_transaction: loan_transaction)
    end
  end

  def employer_disbursed_loans(conn, _params) do
    current_user = get_session(conn, :current_user)
    current_user_role = get_session(conn, :current_user_role)

    IO.inspect("%%%%%%%%%%START current_user%%%%%%%%%%%%%")
    IO.inspect(current_user)
    IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

    if(current_user_role.roleType == "EMPLOYER") do
      query =
        from cl in Loanmanagementsystem.Loan.Loans,
          join: user in User,
          join: userBioData in UserBioData,
          join: userRole in UserRole,
          join: loanProduct in Product,
          on:
            cl.customer_id == user.id and
              cl.loan_userroleid == userRole.id and
              cl.product_id == loanProduct.id and
              user.id == userBioData.userId,
          where:
            cl.company_id == ^conn.assigns.user.company_id and cl.status == ^"DISBURSED" and
              userRole.roleType == ^"EMPLOYER",
          select: %{
            cl: cl,
            user: user,
            userRole: userRole,
            userBioData: userBioData,
            loanProduct: loanProduct
          }

      loan_transaction = Repo.all(query)

      IO.inspect("%%%%%%%%%%START loan_transaction%%%%%%%%%%%%%")
      IO.inspect(loan_transaction)
      IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")
      render(conn, "employer_disbursed_loan.html", loan_transaction: loan_transaction)
    end
  end

  def employer_pending_loans(conn, _params) do
    current_user = get_session(conn, :current_user)
    current_user_role = get_session(conn, :current_user_role)

    IO.inspect("%%%%%%%%%%START current_user%%%%%%%%%%%%%")
    IO.inspect(current_user)
    IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

    if(current_user_role.roleType == "EMPLOYER") do
      query =
        from cl in Loanmanagementsystem.Loan.Loans,
          join: user in User,
          join: userBioData in UserBioData,
          join: userRole in UserRole,
          join: loanProduct in Product,
          on:
            cl.customer_id == user.id and
              cl.loan_userroleid == userRole.id and
              cl.product_id == loanProduct.id and
              user.id == userBioData.userId,
          where:
            cl.company_id == ^conn.assigns.user.company_id and cl.status == ^"PENDING" and
              userRole.roleType == ^"EMPLOYER",
          select: %{
            cl: cl,
            user: user,
            userRole: userRole,
            userBioData: userBioData,
            loanProduct: loanProduct
          }

      loan_transaction = Repo.all(query)

      IO.inspect("%%%%%%%%%%START loan_transaction%%%%%%%%%%%%%")
      IO.inspect(loan_transaction)
      IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

      render(conn, "employer_pending_loans.html", loan_transaction: loan_transaction)
    end
  end

  def employer_rejected_loans(conn, _params) do
    # current_user = get_session(conn, :current_user);
    current_user_role = get_session(conn, :current_user_role)

    IO.inspect("%%%%%%%%%%START company%%%%%%%%%%%%%")
    IO.inspect(conn.assigns.user.company_id)
    IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

    if(current_user_role.roleType == "EMPLOYER") do
      query =
        from cl in Loanmanagementsystem.Loan.Loans,
          join: user in User,
          join: userBioData in UserBioData,
          join: userRole in UserRole,
          join: loanProduct in Product,
          on:
            cl.customer_id == user.id and
              cl.loan_userroleid == userRole.id and
              cl.product_id == loanProduct.id and
              user.id == userBioData.userId,
          where:
            cl.company_id == ^conn.assigns.user.company_id and cl.status == ^"REJECTED" and
              userRole.roleType == ^"EMPLOYER",
          select: %{
            cl: cl,
            user: user,
            userRole: userRole,
            userBioData: userBioData,
            loanProduct: loanProduct
          }

      loan_transaction = Repo.all(query)

      IO.inspect("%%%%%%%%%%START loan_transaction%%%%%%%%%%%%%")
      IO.inspect(loan_transaction)
      IO.inspect("%%%%%%%%%%%END%%%%%%%%%%%%%%%")

      render(conn, "employer_rejected_loans.html", loan_transaction: loan_transaction)
    end
  end

  def employer_employee_loan_products(conn, _params),
    do:
      render(conn, "employer_employee_loan_products.html",
        products:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "PENDING"))
      )

  def staff_all_loans(conn, _params) do
    products = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "staff_all_loans.html", products: products)
  end

  @headers ~w/ title	firstName	lastName	otherName	idType	idNumber	mobileNumber	emailAddress	marital_status	nationality	dateOfBirth number_of_dependants accomodation_status year_at_current_address	area house_number	street_name	town province	loan_limit mobile_network_operator registered_name_mobile_number  job_title employee_number hr_supervisor_email hr_supervisor_mobile_number hr_supervisor_name employment_type contract_start_date contract_end_date date_of_joining/a

  def handle_bulk_creation(user, list) do

    Ecto.Multi.new()
    |> Ecto.Multi.merge(fn multi -> handle_request(multi, user.company_id, list) end)
    |> Repo.transaction()
    |> IO.inspect(label: "-----------ID-----------")
    |> case do
      {:ok, _} -> {:ok, "success"}
      {:error, _, failed_value, _} -> traverse_errors(failed_value.errors)
    end
  end


  def handle_request(_multi, company_id, list) do
    Ecto.Multi.new()
    |> Ecto.Multi.merge(fn _multi ->
      Enum.with_index(list, 1)
      |> Enum.reduce(Ecto.Multi.new(), fn {map, index}, multi ->
          index = Integer.to_string(index)
          insert_bulk(multi, index, map, company_id)
      end)
    end)
  end


  def prep_user(map, company_id, otp, password) do
    %{
      password: password,
      status: "INACTIVE",
      username: map.emailAddress,
      pin: otp,
      company_id: company_id,
      auto_password: "Y"
    }
  end


  def prep_address(_user_id, map) do
    %{
      accomodation_status: map.accomodation_status,
      year_at_current_address: map.year_at_current_address,
      area: map.area,
      house_number: map.house_number,
      street_name: map.street_name,
      town: map.town,
      userId: User.find_by(username: map.emailAddress).id,
      province: map.province
    }
  end

  def prep_boi_data(_user_id, map) do
    %{
      dateOfBirth: map.dateOfBirth,
      emailAddress: map.emailAddress,
      firstName: map.firstName,
      gender: if map.title == "Mr" or map.title == "mr" or map.title == "MR" do "Male" else "Female" end,
      lastName: map.lastName,
      meansOfIdentificationNumber: map.idNumber,
      meansOfIdentificationType: map.idType,
      mobileNumber: map.mobileNumber,
      otherName: map.otherName,
      title: map.title,
      userId: User.find_by(username: map.emailAddress).id,
      # bank_id: params[""],
      # bank_account_number: params[""],
      marital_status: map.marital_status,
      nationality: map.nationality,
      number_of_dependants: map.number_of_dependants,
      age: nil
    }
  end

  def prep_employee_details(_user_id, map, company_id) do
    %{

      area: map.area,
      date_of_joining: map.date_of_joining,
      employee_number: map.employee_number,
      employer: Company.find_by(id: company_id).companyName,
      employment_type: map.employment_type,
      hr_supervisor_email: map.hr_supervisor_email,
      hr_supervisor_mobile_number: map.hr_supervisor_mobile_number,
      hr_supervisor_name: map.hr_supervisor_name,
      job_title: map.job_title,
      occupation: map.job_title,
      province: map.province,
      town: map.town,
      userId: User.find_by(username: map.emailAddress).id,
      mobile_network_operator: map.mobile_network_operator,
      registered_name_mobile_number: map.registered_name_mobile_number,
      contract_start_date: map.contract_start_date,
      contract_end_date: map.contract_end_date,
      company_id: company_id,
    }
  end

  def prep_user_role(_user_id, map, otp) do
    %{
      roleType: map.roleType,
      status: "INACTIVE",
      userId: User.find_by(username: map.emailAddress).id,
      otp: otp,
      isStaff: false
    }
  end

  def prep_customer_account(_user_id, map) do
    %{
      account_number: "01",
      user_id: User.find_by(username: map.emailAddress).id,
      status: "INACTIVE"
    }
  end

  def prep_employee(_user_id, map, company_id) do
    %{
      status: "INACTIVE",
      userId: User.find_by(username: map.emailAddress).id,
      userRoleId: UserRole.find_by(userId: User.find_by(username: map.emailAddress).id).id,
      loan_limit: map.loan_limit,
      companyId: company_id,
      employerId: company_id
    }
  end

  def prep_employee_maintenance(_user_id, map) do
    %{
      registered_name_mobile_number: map.registered_name_mobile_number,
      mobile_network_operator: map.mobile_network_operator,
      userId: User.find_by(username: map.emailAddress).id,
      roleTypeId: UserRole.find_by(userId: User.find_by(username: map.emailAddress).id).id
    }
  end




  def prep_employee_account(_user_id, map, employee_number) do
    %{
      employee_id: User.find_by(username: map.emailAddress).id,
      employee_number: employee_number,
      limit: map.loan_limit,
      limit_balance: map.loan_limit,
      status: "INACTIVE"
    }
  end

  def insert_bulk(multi, index, map, company_id) do

    otp = to_string(Enum.random(1111..9999))
    password = "pass-#{Enum.random(1_000_000_000..9_999_999_999)}"
    user = prep_user(map, company_id, otp, password)
    employee_number = "A-#{Enum.random(10000..99999)}"
    atn = "user" <> index
    multi
    |> Ecto.Multi.insert(atn, User.changeset(%User{}, user))
    |> Ecto.Multi.run("address" <> index, fn (_repo, atn) ->
      addr = prep_address(Map.get(atn, :id), map)
      Repo.insert(Address_Details.changeset(%Address_Details{}, addr))
    end)
    |> Ecto.Multi.run("boi" <> index, fn (_repo, atn) ->
      boi = prep_boi_data(Map.get(atn, :id), map)
      Repo.insert(UserBioData.changeset(%UserBioData{}, boi))
    end)
    |> Ecto.Multi.run("user_role" <> index, fn (_repo, atn) ->
      user_role = prep_user_role(Map.get(atn, :id), map, otp)
      Repo.insert(UserRole.changeset(%UserRole{}, user_role))
    end)
    |> Ecto.Multi.run("customer_account" <> index, fn (_repo, atn) ->
      customer_account = prep_customer_account(Map.get(atn, :id), map)
      Repo.insert(Customer_account.changeset(%Customer_account{}, customer_account))
    end)
    |> Ecto.Multi.run("employee" <> index, fn (_repo, atn) ->
      employee = prep_employee(Map.get(atn, :id), map, company_id)
      Repo.insert(Employee.changeset(%Employee{}, employee))
    end)
    |> Ecto.Multi.run("employee_maintenance" <> index, fn (_repo, atn) ->
      employee_maintenance = prep_employee_maintenance(Map.get(atn, :id), map)
      Repo.insert(Employee_Maintenance.changeset(%Employee_Maintenance{}, employee_maintenance))
    end)
    |> Ecto.Multi.run("employee_details" <> index, fn (_repo, atn) ->
      employee_details = prep_employee_details(Map.get(atn, :id), map, company_id)
      Repo.insert(Employment_Details.changeset(%Employment_Details{}, employee_details))
    end)
    |> Ecto.Multi.run("employee_account" <> index, fn (_repo, atn) ->
      employee_account = prep_employee_account(Map.get(atn, :id), map, employee_number)
      Repo.insert(Employee_account.changeset(%Employee_account{}, employee_account))
    end)
  end


  def handle_staff_bulk_upload(conn, params) do
    IO.inspect(params, label: "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu")
    user = conn.assigns.user
    {key, msg, _invalid} = handle_file_upload(user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.employer_path(conn, :all_staffs))
    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.employer_path(conn, :all_staffs))
    end
  end

  defp handle_file_upload(user, params) do
    params = Map.merge(params, %{"roleType"=> params["roleType"]})
    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
      user
      |> process_bulk_upload(filename, destin_path)
      |> case do
        {:ok, msg} ->
          {:info, "Staffs Uploaded Successful ", ""}

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
      handle_bulk_creation(user, items)

      # {:error, _, changeset, _}
      #   reason = traverse_errors(changeset.errors) |> Enum.join("\r\n")
      #   {:error, reason}

      # {:error, reason} ->
      #     {:error, reason}
  end

  defp prepare_bulk_params(user, filename, items) do

    validate_email = items |> Enum.map(fn records -> if UserBioData.exists?(emailAddress: records.emailAddress) == true do  "EXIST" else "PROCEED" end end)
    validate_idNumber = items |> Enum.map(fn records -> if UserBioData.exists?(meansOfIdentificationNumber: records.idNumber) == true do "EXIST" else "PROCEED" end end)
    validate_mobileNumber = items |> Enum.map(fn records -> if UserBioData.exists?(mobileNumber: records.mobileNumber) == true do "EXIST" else "PROCEED" end end)
    case  Enum.member?(validate_email, "EXIST") do
      false ->
     case  Enum.member?(validate_idNumber, "EXIST") do
      false ->
     case  Enum.member?(validate_mobileNumber, "EXIST") do
      false ->
      Ecto.Multi.new()
      |> Ecto.Multi.run(:staffupload_entries, fn _repo, _changes_so_far ->
         user
         |> prepare_user_bulk_params(filename, items)
         |> prepare_address_detail_bulk_params(user, filename, items)
         |> prepare_userbio_bulk_params(user, filename, items)
         |> prepare_userrole_bulk_params(user, filename, items)
         |> prepare_customer_account_bulk_params(user, filename, items)
         |> prepare_emploee_bulk_params(user, filename, items)
         |> prepare_employee_maintenance_bulk_params(user, filename, items)
         |> prepare_logs_bulk_params(user, filename, items)
          |> case do
            nil ->
              {:ok, "UPLOAD COMPLETE"}
            error ->
              error
          end
      end)
      true ->
        {:error, "emailAddress already exists!"}
        Ecto.Multi.new()
      end
      true ->
        {:error, "emailAddress already exists!"}
        Ecto.Multi.new()
      end
      true ->
      {:error, "emailAddress already exists!"}
      Ecto.Multi.new()

      end
  end

  defp execute_multi(multi) do
    multi
    |> Repo.transaction()
    |> case do
      {:ok, _result} ->
        nil
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        IO.inspect(failed_value)
        {:error, failed_value}
    end
  end

  # defp prepare_userbio_bulk_params(user_bio_resp, _user) when not is_nil(user_bio_resp), do: user_bio_resp
  defp prepare_userbio_bulk_params(_user_bio_resp, user, _filename, items) do
      items
      |> Stream.with_index(1)
      |> Enum.map(fn {item, index} ->

        userbiodata_params = prepare_userbio_data_params(item, user)
        changeset_bio = UserBioData.changeset(%UserBioData{}, userbiodata_params)
        Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_bio)
      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
  end

  # defp prepare_address_detail_bulk_params(address_resp, _user) when not is_nil(address_resp), do: address_resp
  defp prepare_address_detail_bulk_params(_address_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      address_details_params = prepare_address_details_params(item, user)
      changeset_address = Address_Details.changeset(%Address_Details{}, address_details_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_address)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  # defp prepare_userrole_bulk_params(role_resp, _user) when not is_nil(role_resp), do: role_resp
  defp prepare_userrole_bulk_params(_role_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      otp = to_string(Enum.random(1111..9999))
      userrole_params = prepare_userrole_params(item, user, otp)
      changeset_role = UserRole.changeset(%UserRole{}, userrole_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_role)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp prepare_user_bulk_params(user, _filename, items) do

    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      otp = to_string(Enum.random(1111..9999))
      user_params = prepare_user_params(item, user, otp)
      changeset_user = User.changeset(%User{}, user_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_user)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()

  end

  # defp prepare_customer_account_bulk_params(acc_resp, _user) when not is_nil(acc_resp), do: acc_resp
  defp prepare_customer_account_bulk_params(_acc_resp, user, _filename, items) do

    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->

      # employee_account_number = LoanmanagementsystemWeb.ClientManagementController.init_acc_no_generation(item.product_name)
      customer_account_params = prepare_customer_account_params(item, user)
      changeset_customer_acc = Customer_account.changeset(%Customer_account{}, customer_account_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_customer_acc)

    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()

  end

  # defp prepare_emploee_bulk_params(emplo_resp, _user) when not is_nil(emplo_resp), do: emplo_resp
  defp prepare_emploee_bulk_params(_emplo_resp, user, _filename, items) do

    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      employee_params = prepare_employee_params(item, user)
      changeset_employee = Employee.changeset(%Employee{}, employee_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_employee)

    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()

  end

  # defp prepare_employee_maintenance_bulk_params(emplo_resp, _user) when not is_nil(emplo_resp), do: emplo_resp
  defp prepare_employee_maintenance_bulk_params(_emplo_resp, user, _filename, items) do

    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      maintenance_params = prepare_maintenance_params(item, user)
      maintenance_employee = Employee_Maintenance.changeset(%Employee_Maintenance{}, maintenance_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)

    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()

  end


  # defp prepare_logs_bulk_params(logs_resp, _user) when not is_nil(logs_resp), do: logs_resp
  defp prepare_logs_bulk_params(_logs_resp, user, _filename, items) do

    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      user_logs_params = prepare_user_logs_params(item, user)
      changeset_userlogs = UserLogs.changeset(%UserLogs{}, user_logs_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_userlogs)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()

  end

  defp prepare_userbio_data_params(item, _user) do
    %{
      dateOfBirth: item.dateOfBirth,
      emailAddress: item.emailAddress,
      firstName: item.firstName,
      gender: item.gender,
      lastName: item.lastName,
      meansOfIdentificationNumber: item.idNumber,
      meansOfIdentificationType: item.idType,
      mobileNumber: item.mobileNumber,
      otherName: item.otherName,
      title: item.title,
      userId: User.find_by(username: item.mobileNumber).id,
      # bank_id: params[""],
      # bank_account_number: params[""],
      marital_status: item.marital_status,
      nationality: item.nationality,
      number_of_dependants: item.number_of_dependants,
      age: nil
    }
  end

  defp prepare_address_details_params(item, _) do
    %{
      accomodation_status: item.accomodation_status,
      year_at_current_address: item.year_at_current_address,
      area: item.area,
      house_number: item.house_number,
      street_name: item.street_name,
      town: item.town,
      userId: User.find_by(username: item.mobileNumber).id,
      province: item.province
    }
  end

  defp prepare_userrole_params(item, _user, otp) do
    %{
      roleType: "EMPLOYEE",
      status: "INACTIVE",
      userId: User.find_by(username: item.mobileNumber).id,
      otp: otp,
      isStaff: false
    }
  end

  defp prepare_user_params(item, user, otp) do
    %{
      password: "edecrjhgh",
      status: "INACTIVE",
      username: item.mobileNumber,
      pin: otp,
      company_id: user.company_id
    }
  end

  defp prepare_customer_account_params(item, _user) do
    %{
      # account_number: employee_account_number,
      user_id: User.find_by(username: item.mobileNumber).id,
      status: "INACTIVE"
    }
  end

  defp prepare_employee_params(item, user) do

    %{
      status: "INACTIVE",
      userId: User.find_by(username: item.mobileNumber).id,
      userRoleId: UserRole.find_by(userId: User.find_by(username: item.mobileNumber).id).id,
      loan_limit: item.loan_limit,
      companyId: user.company_id,
      employerId: user.company_id
    }
  end

  defp prepare_maintenance_params(item,_user) do

    %{
      registered_name_mobile_number: item.registered_name_mobile_number,
      mobile_network_operator: item.mobile_network_operator,
      userId: User.find_by(username: item.mobileNumber).id,
      roleTypeId: UserRole.find_by(userId: User.find_by(username: item.mobileNumber).id).id
    }
  end

  defp prepare_user_logs_params(item, user) do
    %{
      activity: "You have Successfully Added #{item.firstName} #{item.lastName} as a Staff of ",
      user_id: user.id
    }
  end

  # ---------------------- file persistence --------------------------------------
  def is_valide_file(%{"uploafile_name" => params}) do
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
    destin_path = "C:/staffbulkupload/file" |> default_dir()
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

  def company_all_loans(conn, _params),
    do:
      render(conn, "company_all_loans.html",
        products: Loanmanagementsystem.Products.list_tbl_products()
      )

  def employer_user_logs(conn, _params) do
    logs =
      Loanmanagementsystem.Services.Services.get_employer_userlogs(conn.assigns.user.company_id)

    render(conn, "user_logs.html", logs: logs)
  end

  def user_mgt(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")
    # current_user_details = Accounts.get_details(currentUserRole.userId)
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_admin_logged_user_details(conn.assigns.user.company_id)
    users = Loanmanagementsystem.Accounts.get_system_admin()

    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    branches = Loanmanagementsystem.Maintenance.list_tbl_qfin_branches()
    classifications = Loanmanagementsystem.Maintenance.list_tbl_classification()
    provinces = Loanmanagementsystem.Maintenance.list_tbl_province()

    # roles = Accounts.list_tbl_user_role()
    render(conn, "employer_admin_mgt.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users,
      banks: banks,
      branches: branches,
      classifications: classifications,
      provinces: provinces
    )
  end

  def employer_transaction_reports(conn, params) do
    IO.inspect("#############")
    IO.inspect(params)
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    curencies = Loanmanagementsystem.Maintenance.list_tbl_currency()
    products = Loanmanagementsystem.Products.list_tbl_products()
    i1 = 1

    reports = nil

    render(conn, "employer_transaction_reports.html",
      reports: reports,
      curencies: curencies,
      branches: branches,
      params: params,
      products: products,
      i1: i1
    )
  end

  # def user_mgt(conn, _params) do
  #   currentUserRole = get_session(conn, :current_user_role)
  #   IO.inspect(currentUserRole, label: "Am here man!")
  #   # current_user_details = Accounts.get_details(currentUserRole.userId)
  #   system_users = Accounts.list_tbl_users()
  #   get_bio_datas = Accounts.get_logged_user_details(conn.assigns.user.company_id)
  #   users = Loanmanagementsystem.Accounts.get_system_admin()
  # # roles = Accounts.list_tbl_user_role()
  #   render(conn, "user_mgt.html", system_users: system_users, get_bio_datas: get_bio_datas, users: users)
  # end
  def all_staffs(conn, _params) do
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details(conn.assigns.user.company_id)
    users = Loanmanagementsystem.Accounts.get_system_admin()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    branches = Loanmanagementsystem.Maintenance.list_tbl_qfin_branches()
    classifications = Loanmanagementsystem.Maintenance.list_tbl_classification()
    provinces = Loanmanagementsystem.Maintenance.list_tbl_province()

    render(conn, "employer_staff_mgt.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users,
      banks: banks,
      branches: branches,
      classifications: classifications,
      provinces: provinces
    )
  end

  # def employer_create_employee(conn, params) do
  #   company_id = conn.assigns.user.company_id

  #   IO.inspect(company_id, label: "DDDDDDDDDDDDDDDDDDD")

  #   otp = to_string(Enum.random(1111..9999))

  #   Ecto.Multi.new()
  #   |> Ecto.Multi.insert(
  #     :add_user,
  #     User.changeset(%User{}, %{
  #       password: params["password"],
  #       status: "INACTIVE",
  #       username: params["emailAddress"],
  #       auto_password: "Y",
  #       company_id: company_id
  #     })
  #   )
  #   |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
  #     UserRole.changeset(%UserRole{}, %{
  #       roleType: params["roleType"],
  #       status: "INACTIVE",
  #       userId: add_user.id,
  #       otp: otp
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
  #                                            %{add_user: add_user, add_user_role: _add_user_role} ->
  #     UserBioData.changeset(%UserBioData{}, %{
  #       dateOfBirth: params["dateOfBirth"],
  #       emailAddress: params["emailAddress"],
  #       firstName: params["firstName"],
  #       gender: params["gender"],
  #       lastName: params["lastName"],
  #       meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
  #       meansOfIdentificationType: params["meansOfIdentificationType"],
  #       mobileNumber: params["mobileNumber"],
  #       otherName: params["otherName"],
  #       title: params["title"],
  #       userId: add_user.id,
  #       idNo: nil
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:employee, fn _repo,
  #                                   %{
  #                                     add_user: add_user,
  #                                     add_user_role: add_user_role,
  #                                     add_user_bio_data: _add_user_bio_data
  #                                   } ->
  #     Employee.changeset(%Employee{}, %{
  #       companyId: company_id,
  #       employerId: company_id,
  #       status: "INACTIVE",
  #       userId: add_user.id,
  #       userRoleId: add_user_role.id,
  #       loan_limit: params["loan_limit"]
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:user_logs, fn _repo,
  #                                    %{
  #                                      add_user: _add_user,
  #                                      add_user_role: _add_user_role,
  #                                      add_user_bio_data: _add_user_bio_data,
  #                                      employee: _employee
  #                                    } ->
  #     UserLogs.changeset(%UserLogs{}, %{
  #       activity: "Created Staff Successfully",
  #       user_id: conn.assigns.user.id
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     # {:ok, _} ->
  #     {:ok, %{add_user: _add_user}} ->
  #       Email.send_email(params["emailAddress"], params["password"])

  #       conn
  #       |> put_flash(:info, "You have Successfully Staff")
  #       |> redirect(to: Routes.employer_path(conn, :all_staffs))

  #     {:error, _failed_operations, failed_value, _changes_so_far} ->
  #       reason = traverse_errors(failed_value.errors)

  #       conn
  #       |> put_flash(:error, reason)
  #       |> redirect(to: Routes.employer_path(conn, :all_staffs))
  #   end
  # end

  def employer_create_employee(conn, params) do
    image = params["nrc_image"]
    otp = to_string(Enum.random(1111..9999))
    company_id = conn.assigns.user.company_id
    company = Loanmanagementsystem.Companies.get_company!(company_id)
    employee_account_number = LoanmanagementsystemWeb.ClientManagementController.init_acc_no_generation(params["product_name"])
    employee_number = "A-#{Enum.random(10000..99999)}"

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_user,
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["mobileNumber"],
        pin: otp,
        company_id: company_id
      })
    )
    |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
      UserRole.changeset(%UserRole{}, %{
        roleType: "EMPLOYEE",
        status: "INACTIVE",
        userId: add_user.id,
        otp: otp,
        isStaff: false
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:customer_account, fn _repo, %{add_user: add_user} ->
      Customer_account.changeset(%Customer_account{}, %{
        account_number: employee_account_number,
        user_id: add_user.id,
        status: "INACTIVE"
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:userBioDate, fn _repo, %{add_user: add_user, add_user_role: _add_user_role} ->
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
        # bank_id: params[""],
        # bank_account_number: params[""],
        marital_status: params["marital_status"],
        nationality: params["nationality"],
        number_of_dependants: params["number_of_dependants"],
        age: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:employee_account, fn _repo, %{add_user: add_user, add_user_role: _add_user_role} ->
      Employee_account.changeset(%Employee_account{}, %{

        employee_id: add_user.id,
        employee_number: employee_number,
        limit_balance: params["loan_limit"],
        limit: params["loan_limit"],
        status: "ACTIVE"
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_emplee_values, fn _repo, %{add_user: add_user, add_user_role: add_user_role, userBioDate: _userBioDate} ->
      validate_img = if Loanmanagementsystem.Employment.get_employee__maintenance_by_userId(add_user.id) == nil do

          ""
        else
          Loanmanagementsystem.Employment.get_employee__maintenance_by_userId(add_user.id).nrc_image
        end

      encode_img =
        if image != nil || image != "" do
          parse_image(image.path)
        else
          validate_img
        end

      Employee.changeset(%Employee{}, %{
        status: "INACTIVE",
        userId: add_user.id,
        userRoleId: add_user_role.id,
        loan_limit: params["loan_limit"],
        nrc_image: encode_img,
        companyId: company_id,
        employerId: company_id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_address_address, fn _repo, %{add_user: add_user, add_user_role: _add_user_role, userBioDate: _userBioDate, add_emplee_values: _add_emplee_values } ->
      Address_Details.changeset(%Address_Details{}, %{
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        userId: add_user.id,
        year_at_current_address: params["year_at_current_address"],
        province: params["province"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_employment_details, fn _repo, %{add_user: add_user, add_user_role: add_user_role, userBioDate: _userBioDate, add_emplee_values: add_emplee_values } ->
      Employee_Maintenance.changeset(%Employee_Maintenance{}, %{
        mobile_network_operator: params["mobile_network_operator"],
        registered_name_mobile_number: params["registered_name_mobile_number"],
        userId: add_user.id,
        roleTypeId: add_user_role.id,
        nrc_image: add_emplee_values.nrc_image
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_user: _add_user, add_user_role: _add_user_role, userBioDate: userBioDate, add_emplee_values: _add_emplee_values, add_address_address: _add_address_address} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "You have Successfully Added #{userBioDate.firstName} #{userBioDate.lastName} as a Staff of #{company.companyName}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{userBioDate: userBioDate}} ->
        conn
        |> put_flash(
          :info,
          "You have Successfully Added #{userBioDate.firstName} #{userBioDate.lastName} as a Staff of #{company.companyName}"
        )
        |> redirect(to: Routes.employer_path(conn, :all_staffs))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.employer_path(conn, :all_staffs))
    end
  end

  def employer_update_employee(conn, params) do
    IO.inspect(params["id"], label: "ppppppppppppppppppppppppppppppppppppppppppppppp")

    userbiodate = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])

    employment_maintenance = Loanmanagementsystem.Employment.get_employee__details_by_userId(params["id"])

    address_details = Loanmanagementsystem.Accounts.get_address__details_by_userId(params["id"])

    company_id = conn.assigns.user.company_id

    company = Loanmanagementsystem.Companies.get_company!(company_id)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_userbiodate,
    UserBioData.changeset(userbiodate, %{

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
        marital_status: params["marital_status"]

    }))

    |> Ecto.Multi.run(:update_address_details, fn _repo, %{ update_userbiodate: _update_userbiodate} ->
      Address_Details.changeset(address_details, %{

        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        year_at_current_address: params["year_at_current_address"],
        province: params["province"]
      })
      |> Repo.update()
    end)

    |> Ecto.Multi.run(:update_employoiment_details, fn _repo, %{update_userbiodate: _update_userbiodate, update_address_details: _update_address_details} ->
      Employment_Details.changeset(employment_maintenance, %{
        mobile_network_operator: params["mobile_network_operator"],
        registered_name_mobile_number: params["registered_name_mobile_number"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_employoiment_details: _update_employoiment_details, update_userbiodate: update_userbiodate} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Updated #{update_userbiodate.firstName} #{update_userbiodate.lastName} Staff",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_userbiodate: update_userbiodate}} ->
        conn
        |> put_flash(:info, "You have Successfully Updated #{update_userbiodate.firstName} #{update_userbiodate.lastName} as a Staff of #{company.companyName}")
        |> redirect(to: Routes.employer_path(conn, :all_staffs))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.employer_path(conn, :all_staffs))
    end
  end

  def employer_activate_employee(conn, params) do
    id = params["id"]
    IO.inspect(params, label: "-----------------PARAMS----------------")
    IO.inspect(id, label: "-----------------PARAMS----------------")

    users_approve = Accounts.get_user!(params["id"])
    IO.inspect(users_approve, label: "-----------------PARAMS----------------")

    user_role_approve = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])
    user_account_no = Loanmanagementsystem.Accounts.get_account_by_user_id!(params["id"])
    update_employees_tbl = Loanmanagementsystem.Companies.get_employee_by_user_id!(params["id"])
    update_employee_account = Loanmanagementsystem.Companies.get_employee_account_by_user_id!(params["id"])
    current_user = conn.assigns.user.id
    activated_user_id = params["id"]

    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "ACTIVE"}))
    |> Ecto.Multi.update(:user_role_approve,UserRole.changeset(user_role_approve, %{status: "ACTIVE"}))
    |> Ecto.Multi.update(:user_account_no,Customer_account.changeset(user_account_no, %{status: "ACTIVE"}))
    |> Ecto.Multi.update(:update_employees_tbl,Employee.changeset(update_employees_tbl, %{status: "ACTIVE"}))
    |> Ecto.Multi.update(:user_bio_data,UserBioData.changeset(user_bio_data, %{status: "ACTIVE"}))
    |> Ecto.Multi.update(:update_employee_account,Employee_account.changeset(update_employee_account, %{status: "ACTIVE"}))
    |> Ecto.Multi.run(:user_log, fn _, %{users: _users} ->
      activity = "User with id #{activated_user_id} has been Activated by user with id #{current_user}\n"

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }
      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: _users, user_log: _user_log}} ->
        json(conn, %{data: "Staff has been activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end


  def employer_activate_employee_admin(conn, params) do
    users_approve = Accounts.get_user!(params["id"])
    user_role_approve = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])
    user_account_no = Loanmanagementsystem.Accounts.get_account_by_user_id!(params["id"])
    update_employees_tbl = Loanmanagementsystem.Companies.get_employee_by_user_id!(params["id"])
    current_user = conn.assigns.user.id
    activated_user_id = params["id"]

    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "ACTIVE"}))
    |> Ecto.Multi.update(:user_role_approve,UserRole.changeset(user_role_approve, %{status: "ACTIVE"}))
    |> Ecto.Multi.update(:user_account_no,Customer_account.changeset(user_account_no, %{status: "ACTIVE"}))
    |> Ecto.Multi.update(:update_employees_tbl,Employee.changeset(update_employees_tbl, %{status: "ACTIVE"}))
    |> Ecto.Multi.update(:user_bio_data,UserBioData.changeset(user_bio_data, %{status: "ACTIVE"}))
    |> Ecto.Multi.run(:user_log, fn _, %{users: _users} ->
      activity =
        "User with id #{activated_user_id} has been Activated by user with id #{current_user}\n"

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: _users, user_log: _user_log}} ->
        json(conn, %{data: "Administrative Staff has been activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def employer_deactivate_employee(conn, params) do
    users_approve = Accounts.get_user!(params["id"])
    user_role_approve = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])
    user_account_no = Loanmanagementsystem.Accounts.get_account_by_user_id!(params["id"])
    update_employees_tbl = Loanmanagementsystem.Companies.get_employee_by_user_id!(params["id"])
    update_employee_account = Loanmanagementsystem.Companies.get_employee_account_by_user_id!(params["id"])
    current_user = conn.assigns.user.id
    activated_user_id = params["id"]

    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "DISABLED"}))
    |> Ecto.Multi.update(
      :user_role_approve,
      UserRole.changeset(user_role_approve, %{status: "DISABLED"})
    )
    |> Ecto.Multi.update(
      :user_account_no,
      Customer_account.changeset(user_account_no, %{status: "DISABLED"})
    )
    |> Ecto.Multi.update(
      :update_employees_tbl,
      Employee.changeset(update_employees_tbl, %{status: "DISABLED"})
    )
    |> Ecto.Multi.update(
      :user_bio_data,
      UserBioData.changeset(user_bio_data, %{status: "DISABLED"})
    )
    |> Ecto.Multi.update(:update_employee_account,Employee_account.changeset(update_employee_account, %{status: "DISABLED"}))
    |> Ecto.Multi.run(:user_log, fn _, %{users: _users} ->
      activity =
        "User with id #{activated_user_id} has been deactivated by user with id #{current_user}\n"

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: _users, user_log: _user_log}} ->
        json(conn, %{data: "Staff has been deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end


  def employer_deactivate_employee_admin(conn, params) do
    users_approve = Accounts.get_user!(params["id"])
    user_role_approve = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])
    user_account_no = Loanmanagementsystem.Accounts.get_account_by_user_id!(params["id"])
    update_employees_tbl = Loanmanagementsystem.Companies.get_employee_by_user_id!(params["id"])
    current_user = conn.assigns.user.id
    activated_user_id = params["id"]

    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "DISABLED"}))
    |> Ecto.Multi.update(
      :user_role_approve,
      UserRole.changeset(user_role_approve, %{status: "DISABLED"})
    )
    |> Ecto.Multi.update(
      :user_account_no,
      Customer_account.changeset(user_account_no, %{status: "DISABLED"})
    )
    |> Ecto.Multi.update(
      :update_employees_tbl,
      Employee.changeset(update_employees_tbl, %{status: "DISABLED"})
    )
    |> Ecto.Multi.update(
      :user_bio_data,
      UserBioData.changeset(user_bio_data, %{status: "DISABLED"})
    )
    |> Ecto.Multi.run(:user_log, fn _, %{users: _users} ->
      activity =
        "User with id #{activated_user_id} has been deactivated by user with id #{current_user}\n"

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: _users, user_log: _user_log}} ->
        json(conn, %{data: "Administrative Staff has been deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def employer_create_admin_employee(conn, params) do
    IO.inspect(params, label: "image params")
    image = params["nrc_image"]
    otp = to_string(Enum.random(1111..9999))
    company_id = conn.assigns.user.company_id
    company = Loanmanagementsystem.Companies.get_company!(company_id)

    employee_account_number =
      LoanmanagementsystemWeb.ClientManagementController.init_acc_no_generation(
        params["product_name"]
      )

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_user,
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["mobileNumber"],
        pin: otp,
        company_id: company_id
      })
    )
    |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
      UserRole.changeset(%UserRole{}, %{
        roleType: params["roleType"],
        status: "INACTIVE",
        userId: add_user.id,
        otp: otp,
        isStaff: false
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:customer_account, fn _repo, %{add_user: add_user} ->
      Customer_account.changeset(%Customer_account{}, %{
        account_number: employee_account_number,
        user_id: add_user.id,
        status: "INACTIVE"
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:userBioDate, fn _repo,
                                       %{add_user: add_user, add_user_role: _add_user_role} ->
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
        # bank_id: params[""],
        # bank_account_number: params[""],
        marital_status: params["marital_status"],
        nationality: params["nationality"],
        number_of_dependants: params["number_of_dependants"],
        age: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_emplee_values, fn _repo,
                                             %{
                                               add_user: add_user,
                                               add_user_role: add_user_role,
                                               userBioDate: _userBioDate
                                             } ->
      validate_img =
        if Loanmanagementsystem.Employment.get_employee__maintenance_by_userId(add_user.id) == nil do
          ""
        else
          Loanmanagementsystem.Employment.get_employee__maintenance_by_userId(add_user.id).nrc_image
        end

      encode_img =
        if image != nil || image != "" do
          parse_image(image.path)
        else
          validate_img
        end

      Employee.changeset(%Employee{}, %{
        status: "INACTIVE",
        userId: add_user.id,
        userRoleId: add_user_role.id,
        loan_limit: params["loan_limit"],
        nrc_image: encode_img,
        companyId: company_id,
        employerId: company_id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_address_address, fn _repo,
                                               %{
                                                 add_user: add_user,
                                                 add_user_role: _add_user_role,
                                                 userBioDate: _userBioDate,
                                                 add_emplee_values: _add_emplee_values
                                               } ->
      Address_Details.changeset(%Address_Details{}, %{
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        userId: add_user.id,
        year_at_current_address: params["year_at_current_address"],
        province: params["province"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_user: _add_user,
                                       add_user_role: _add_user_role,
                                       userBioDate: userBioDate,
                                       add_emplee_values: _add_emplee_values,
                                       add_address_address: _add_address_address
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "You have Successfully Added #{userBioDate.firstName} #{userBioDate.lastName} as a Staff of ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{userBioDate: userBioDate}} ->
        conn
        |> put_flash(
          :info,
          "You have Successfully Added #{userBioDate.firstName} #{userBioDate.lastName} as a Staff of #{company.companyName}"
        )
        |> redirect(to: Routes.employer_path(conn, :user_mgt))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.employer_path(conn, :user_mgt))
    end
  end

  def password_render() do
    random_string()
  end

  def number do
    spec = Enum.to_list(?2..?9)
    length = 2
    Enum.take_random(spec, length)
  end

  def number2 do
    spec = Enum.to_list(?1..?9)
    length = 1
    Enum.take_random(spec, length)
  end

  def caplock do
    spec = Enum.to_list(?A..?N)
    length = 1
    Enum.take_random(spec, length)
  end

  def small_latter do
    spec = Enum.to_list(?a..?n)
    length = 1
    Enum.take_random(spec, length)
  end

  def small_latter2 do
    spec = Enum.to_list(?p..?z)
    length = 2
    Enum.take_random(spec, length)
  end

  def special do
    spec = Enum.to_list(?#..?*)
    length = 1

    Enum.take_random(spec, length)
    |> to_string()
    |> String.replace("'", "^")
    |> String.replace("(", "!")
    |> String.replace(")", "@")
  end

  def random_string do
    smll = to_string(small_latter())
    smll2 = to_string(small_latter2())
    nmb = to_string(number())
    nmb2 = to_string(number2())
    spc = to_string(special())
    cpl = to_string(caplock())
    smll <> "" <> nmb <> "" <> spc <> "" <> cpl <> "" <> nmb2 <> "" <> smll2
  end

  def generate_random_password(conn, _param) do
    account = random_string()
    json(conn, %{"account" => account})
  end

  def parse_image(path) do
    path
    |> File.read!()
    |> Base.encode64()
  end

  def employer_employee_disbursed_loans_list_item_lookup(conn, params) do
    companyId = conn.assigns.user.company_id
    loan_status = "DISBURSED"

    {draw, start, length, search_params} = search_options(params)

    results =
      Loanmanagementsystem.Loan.employer_employee_loans_list(
        search_params,
        start,
        length,
        companyId,
        loan_status
      )

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

  def employer_employee_pending_loans_list_item_lookup(conn, params) do
    companyId = conn.assigns.user.company_id
    # loan_status = "PENDING_CLIENT_CONFIRMATION"

    {draw, start, length, search_params} = search_options(params)

    results =
    Loanmanagementsystem.Operations.employer_employee_pending_loans_list(
        search_params,
        start,
        length,
        companyId
      )

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

  def employer_employee_rejected_loans_list_item_lookup(conn, params) do
    companyId = conn.assigns.user.company_id
    loan_status = "REJECTED"

    {draw, start, length, search_params} = search_options(params)

    results =
      Loanmanagementsystem.Loan.employer_employee_loans_list(
        search_params,
        start,
        length,
        companyId,
        loan_status
      )

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

  def employer_employee_all_loans_list_item_lookup(conn, params) do
    companyId = conn.assigns.user.company_id

    {draw, start, length, search_params} = search_options(params)

    results =
      Loanmanagementsystem.Loan.all_employer_employee_loans_list(
        search_params,
        start,
        length,
        companyId
      )

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

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end

  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:employer_client, :create}
      act when act in ~w(index view)a -> {:employer_client, :view}
      act when act in ~w(update edit)a -> {:employer_client, :edit}
      act when act in ~w(change_status)a -> {:employer_client, :change_status}
      _ -> {:employer_client, :unknown}
    end
  end

  def client_approval_details(conn, %{"loan_id" => loan_id}) do

    loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(loan_id)

    loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)

    credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

    render(conn, "client_approval_details.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details)
  end


  def approve_client_invoice_discounting_application(conn, params) do

    loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :add_loan,
        Loans.changeset(loans, %{

          loan_status: "PENDING_CREDIT_ANALYST",
          status: "PENDING_CREDIT_ANALYST"

        })
      )

      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Loan Application Successfully Approved By Client",
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
          |> put_flash(:info, "Loan Application Approved Successfully By Client")
          |> redirect(to: Routes.employer_path(conn, :employer_employee_pending_loans))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.employer_path(conn, :employer_employee_pending_loans))
      end
  end

end
