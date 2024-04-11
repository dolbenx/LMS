defmodule LoanmanagementsystemWeb.MerchantController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole, Customer_account, Address_Details}
  alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Companies.Employee
  # alias Loanmanagementsystem.Companies
  alias Loanmanagementsystem.Merchants
  alias  Loanmanagementsystem.Logs.UserLogs
  import Ecto.Query, warn: false

  def all_loans(conn, _params) do
    all_loans = Loanmanagementsystem.Loan.list_tbl_loans_all()
    render(conn, "all_loans.html", all_loans: all_loans)
  end

  def make_payment_view(conn, _params) do
    current_user = conn.assigns.user.id
    render(conn, "make_repayment.html", loan_details: Loanmanagementsystem.Loan.get_loan_by_userId(current_user))
  end

  def pending_loans(conn, _params) do
    loan_details = Loanmanagementsystem.Loan.list_tbl_loans_all() |> Enum.reject(&(&1.loan_status != "PENDING_APPROVAL"))
    render(conn, "pending_loans.html", loan_details: loan_details)
  end

  def rejected_loans(conn, _params) do
    loan_details = Loanmanagementsystem.Loan.list_tbl_loans_all() |> Enum.reject(&(&1.loan_status != "REJECTED"))
    render(conn, "merchant_rejected_loans.html", loan_details: loan_details)
  end

  def loan_tracking(conn, _params) do
    current_user = conn.assigns.user.id
    render(conn, "loan_tracker.html", loan_details: Loanmanagementsystem.Loan.get_loan_by_userId(current_user))
  end

  def qr_code(conn, _params) do
    current_user = 255
    qr_code = Loanmanagementsystem.Merchants.get_merchant_qr_code(current_user)
    render(conn, "qr_code.html", qr_code: qr_code)
  end

  def merchant_profile(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")
    current_user_details = Loanmanagementsystem.Accounts.get_details(conn.assigns.user.id)
    IO.inspect(current_user_details, label: "Am here man!")
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    users = Accounts.get_system_admin()

    loans = Accounts.get_customer_account(conn.assigns.user.id)

    companys = Merchants.get_merchant!(conn.assigns.user.company_id)

    loan_details = Loan.get_loan_by_userId(conn.assigns.user.id)

    render(conn, "merchant_profile.html", system_users: system_users, get_bio_datas: get_bio_datas, users: users, current_user_details: current_user_details, loans: loans, companys: companys, loan_details: loan_details)
  end

  def edit_merchant_my_profile_details(conn, params) do

    user = Loanmanagementsystem.Accounts.get_user!(String.to_integer(params["id"]))

    employee = Loanmanagementsystem.Accounts.get_user_bio_data!(String.to_integer(params["id"]))

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_user, User.changeset(user, %{username: params["emailAddress"]}))
    |> Ecto.Multi.run(:update_merchant_details, fn _repo, %{update_user: _update_user} ->
      UserBioData.changeset(employee, %{
        emailAddress: params["emailAddress"],
        mobileNumber: params["mobileNumber"],
        title: params["title"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_user: _update_user, update_merchant_details: update_merchant_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Successfully Updated #{update_merchant_details.emailAddress} Info!!!!",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You Have Succeffully Updated Your Data")
        |> redirect(to: Routes.merchant_path(conn, :merchant_profile))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        activity = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, activity)
        |> redirect(to: Routes.merchant_path(conn, :merchant_profile))
    end
  end

  def merchant_mini_statement(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")
    current_user_details = Accounts.get_details(currentUserRole.userId)
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    users = Accounts.get_system_admin()
    loans = Accounts.get_customer_account(conn.assigns.user.id)
    loan_details = Loan.get_loan_by_userId(conn.assigns.user.id)
    # roles = Accounts.list_tbl_user_role()
    render(conn, "loans_mini_statement.html", system_users: system_users, get_bio_datas: get_bio_datas, users: users, current_user_details: current_user_details, loans: loans, loan_details: loan_details
    )
  end

  def merchant_full_statement(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    current_user_details = Accounts.get_details(currentUserRole.userId)
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    users = Accounts.get_system_admin()
    loans = Accounts.get_customer_account(conn.assigns.user.id)
    loan_details = Loan.get_loan_by_userId(conn.assigns.user.id)
    # roles = Accounts.list_tbl_user_role()
    render(conn, "loans_full_statement.html", system_users: system_users, get_bio_datas: get_bio_datas, users: users, current_user_details: current_user_details, loans: loans, loan_details: loan_details)
  end

  def merchant_employee_disbursed_loans(conn, _params) do
    loans = Loanmanagementsystem.Loan.list_tbl_loans_all() |> Enum.reject(&(&1.status != "APPROVED"))
    render(conn, "merchant_disbursed_loan.html", loans: loans)
  end

  def loan_products(conn, _params) do
    products = Loanmanagementsystem.Products.list_tbl_products() |> Enum.reject(&(&1.status != "ACTIVE"))
    render(conn, "loan_products.html", products: products)
  end

  def merchant_document(conn, %{"userID" => userID}) do
    documents = Loanmanagementsystem.Merchants.get_merchant_documents(userID)
    render(conn, "merchant_documents.html", documents: documents)
  end

  def staff_all_loans(conn, _params) do
    products = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "staff_all_loans.html", products: products)
  end

  def all_staffs(conn, _params) do
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details(conn.assigns.user.company_id)
    users = Loanmanagementsystem.Accounts.get_system_admin()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    branches = Loanmanagementsystem.Maintenance.list_tbl_qfin_branches()
    classifications = Loanmanagementsystem.Maintenance.list_tbl_classification()
    provinces = Loanmanagementsystem.Maintenance.list_tbl_province()

    render(conn, "merchant_staff_mgt.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users,
      banks: banks,
      branches: branches,
      classifications: classifications,
      provinces: provinces
    )
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
    render(conn, "merchant_admin_mgt.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users,
      banks: banks,
      branches: branches,
      classifications: classifications,
      provinces: provinces
    )
  end

  def merchant_transaction_reports(conn, params) do
    IO.inspect("#############")
    IO.inspect(params)
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    curencies = Loanmanagementsystem.Maintenance.list_tbl_currency()
    products = Loanmanagementsystem.Products.list_tbl_products()
    i1 = 1

    reports = nil

    render(conn, "merchant_transaction_reports.html",
      reports: reports,
      curencies: curencies,
      branches: branches,
      params: params,
      products: products,
      i1: i1
    )
  end

  def merchant_create_admin_employee(conn, params) do
    IO.inspect(params, label: "image params")
    image = params["nrc_image"]
    otp = to_string(Enum.random(1111..9999))
    company_id = conn.assigns.user.company_id
    company = Merchants.get_merchant!(company_id)

    employee_account_number = LoanmanagementsystemWeb.ClientManagementController.init_acc_no_generation(params["product_name"])

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_user,
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["mobileNumber"],
        pin: otp,
        company_id: company_id,
        auto_password: "Y"
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
    |> Ecto.Multi.run(:add_emplee_values, fn _repo,%{add_user: add_user, add_user_role: add_user_role, userBioDate: _userBioDate} ->
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
    |> Ecto.Multi.run(:add_address_address, fn _repo, %{add_user: add_user, add_user_role: _add_user_role, userBioDate: _userBioDate, add_emplee_values: _add_emplee_values} ->
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
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_user: _add_user, add_user_role: _add_user_role, userBioDate: userBioDate, add_emplee_values: _add_emplee_values, add_address_address: _add_address_address} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Added #{userBioDate.firstName} #{userBioDate.lastName} as a Staff #{company.companyName}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{userBioDate: userBioDate}} ->
        conn
        |> put_flash(:info, "You have Successfully Added #{userBioDate.firstName} #{userBioDate.lastName} as a Staff of #{company.companyName}")
        |> redirect(to: Routes.employer_path(conn, :user_mgt))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.employer_path(conn, :user_mgt))
    end
  end

  def parse_image(path) do
    path
    |> File.read!()
    |> Base.encode64()
  end

  def display_pdf(conn, %{"path" => path}), do: send_file( put_resp_header(conn, "content-type", "application/pdf"), 200, path)

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end
end
