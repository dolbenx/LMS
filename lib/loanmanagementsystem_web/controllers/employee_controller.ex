defmodule LoanmanagementsystemWeb.EmployeeController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false

  alias Loanmanagementsystem.Logs.UserLogs
  # alias Loanmanagementsystem.Companies.Company
  # alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Products
  alias Loanmanagementsystem.Accounts.{UserBioData, User, UserRole}
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Loan.LoanRepayment
  alias Loanmanagementsystem.Loan.LoanTransaction
  alias Loanmanagementsystem.Notifications.Sms
  # alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Loan.Loan_applicant_collateral
  alias Loanmanagementsystem.Accounts.Nextofkin
  alias Loanmanagementsystem.Loan.Loan_applicant_reference
  alias Loanmanagementsystem.Loan.Loan_customer_details
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Loan.Loan_employment_info


  plug LoanmanagementsystemWeb.Plugs.Authenticate,
	       [module_callback: &LoanmanagementsystemWeb.EmployeeController.authorize_role/1]
	       when action not in [
            :all_loans,
            :all_staffs,
            :calculate_interest_and_repaymnent_amt,
            :client_loan_application,
            :create_quick_loan_employee_application,
            :disbursed_loans,
            :employee_edit_my_profile_details,
            :employee_full_statement,
            :employee_mini_statement,
            :employee_profile,
            :get_otp,
            :individual_loan_products,
            :loan_products,
            :loan_tracking,
            :make_payements_employee,
            :make_payment_view,
            :make_payment_view_view,
            :otp_validation,
            :pending_loans,
            :quick_advance_application_employee,
            :quick_loan_application_employee,
            :quick_loan_capturing,
            :sample,
            :selected_loan_product,
            :send_otp,
            :test_run,
            :traverse_errors,
            :user_mgt,
            :validate_otp,
	            ]

	  use PipeTo.Override

  def all_loans(conn, _params),
    do:
      render(conn, "all_loans.html", products: Loanmanagementsystem.Products.list_tbl_products())

  def get_otp(conn, %{"product_id" => product_id}) do
    render(conn, "get_otp.html", product_id: product_id)
  end

  def otp_validation(conn, %{"client_line" => client_line, "product_id" => product_id}) do
    IO.inspect(conn, label: "------------")
    render(conn, "otp_validation.html", client_line: client_line, product_id: product_id)
  end


  def employee_loan_application(conn, %{"product_id" => product_id}) do
    user_id = conn.assigns.user.id
    get_bio_datas = Accounts.get_details(user_id)
    product_details = Loanmanagementsystem.Products.otc_product_details_lookup(product_id)
    address_details = Loanmanagementsystem.Operations.get_individual_address_details(user_id)
    reference_details = Loanmanagementsystem.Loan.list_customer_reference_details(user_id)
    client_data = Loanmanagementsystem.Operations.get_client_by_userid(user_id)

    nextofkin = try do  Loanmanagementsystem.Loan.list_customer_nextofkin_details(user_id) ||
    %{
      applicant_nrc: "",
      kin_ID_number: "",
      kin_first_name: "",
      kin_gender: "",
      kin_last_name: "",
      kin_mobile_number: "",
      kin_other_name: "",
      kin_personal_email: "",
      kin_relationship: "",
      kin_status: "",
      userID: "",
      reference_no: "",
    }
    rescue _-> nil end

    render(conn, "employee_loan_application.html",
    product_details: product_details ,
    get_bio_datas: get_bio_datas,
    address_details: address_details,
    reference_details: reference_details,
    nextofkin: nextofkin,
    client_data: client_data,
    employment_details: Loanmanagementsystem.Employment.list_customer_reference_details_validation(client_data.userId),
    relationship_officer: Loanmanagementsystem.Loan.list_customer_relationship_officer()
    )
  end



  def employee_loan_initiation(conn, params) do
    customer_id = conn.assigns.user.id
    reference_no = LoanmanagementsystemWeb.IndividualController.generate_reference_no(Integer.to_string(customer_id))
    employee_datails = Loanmanagementsystem.Operations.get_employmentdetails_by_userId(customer_id)
    company_details = Loanmanagementsystem.Operations.get_employmentdetails_by_company_id(conn.assigns.user.company_id)

    employee_user_bio_data = Loanmanagementsystem.Accounts.UserBioData.find_by(userId: customer_id)
    monthly_installment =
      if is_float(params["monthly_installment"]) do
        params["monthly_installment"]
      else
        String.to_float(params["monthly_installment"])
      end

      principle_amount = if is_float(params["requested_amount"]) do params["requested_amount"] else String.to_float(params["requested_amount"]) end

    loan_duration_month = Loanmanagementsystem.SmallOperations.change_datatype(params["loan_duration_month"])

    balance = (monthly_installment * loan_duration_month)

    IO.inspect(params, label: "---------------------------- params")

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :laon_details,
      Loans.changeset(%Loans{}, %{
        product_id: params["product_id"],
        customer_id: customer_id,
        loan_type: params["loan_type"],
        principal_amount: params["requested_amount"],
        principal_amount_proposed: params["requested_amount"],
        loan_status: "PENDING_CREDIT_ANALYST",
        status: "PENDING_CREDIT_ANALYST",
        loan_userroleid: conn.private.plug_session["current_user_role"].id,
        reference_no: reference_no,
        requested_amount: params["requested_amount"],
        loan_duration_month: params["loan_duration_month"],
        monthly_installment: params["monthly_installment"],
        proposed_repayment_date: params["proposed_repayment_date"],
        loan_purpose: params["loan_purpose"],
        application_date: Date.utc_today(),
        cro_id: params["cro_id"],
        term_frequency: params["term_frequency"],
        balance: balance,
        company_id: conn.assigns.user.company_id,
        interest_amount: (balance - principle_amount )
      })
    )
    |> Ecto.Multi.run(:address_update, fn _repo, %{laon_details: laon_details} ->
      address = Loanmanagementsystem.Operations.get_address_by_userId(conn.assigns.user.id)

      address_details = %{
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        province: params["province"],
        land_mark: params["land_mark"],
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        userId: laon_details.customer_id,
        year_at_current_address: params["year_at_current_address"],
        company_id: laon_details.company_id
      }

      case Repo.update(Address_Details.changeset(address, address_details)) do
        {:ok, message} -> {:ok, message}
        {:error, reason} -> {:error, reason}
      end
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{laon_details: laon_details, address_update: address_update} ->
      #    # ----------------------------------- Collateral
      collateral = params["name_of_collateral"]

      if collateral == nil || collateral == [] || collateral == ["undefined"] do
        IO.puts("No Reference Attachment Detected")
      else
        for x <- 0..(Enum.count(collateral) - 1) do
          collateral_params = %{
            customer_id: laon_details.customer_id,
            reference_no: laon_details.reference_no,
            asset_value: Enum.at(params["asset_value"], x),
            color: Enum.at(params["color"], x),
            id_number: Enum.at(params["id_number_collateral"], x),
            name_of_collateral: Enum.at(params["name_of_collateral"], x),
            #  applicant_signature: applicant_signature_encode_img,
            name_of_witness: params["name_of_witness"],
            #  witness_signature: witness_signature_encode_img,
            cro_staff_name: params["cro_staff_name"]
            #  cro_staff_signature:  cro_staff_signature_encode_img,
          }

          Loan_applicant_collateral.changeset(%Loan_applicant_collateral{}, collateral_params)
          |> Repo.insert()
        end
      end

      # -------------------------------------Next of Kin
      Nextofkin.changeset(%Nextofkin{}, %{
        userID: laon_details.customer_id,
        reference_no: laon_details.reference_no,
        kin_first_name: params["kin_first_name"],
        kin_last_name: params["kin_last_name"],
        kin_other_name: params["kin_other_name"],
        kin_status: params["kin_status"],
        kin_relationship: params["kin_relationship"],
        kin_gender: params["kin_gender"],
        kin_mobile_number: params["kin_mobile_number"]
      })
      |> Repo.insert()
      Loan_employment_info.changeset(%Loan_employment_info{}, %{
        address: "House_no #{address_update.house_number}, off #{address_update.street_name}, #{address_update.area} area #{address_update.town} town, #{address_update.province} province",
        applicant_name: "#{employee_user_bio_data.firstName} #{employee_user_bio_data.otherName} #{employee_user_bio_data.lastName}",
        company_name: employee_datails.employer,
        contact_no: "#{employee_user_bio_data.mobileNumber}",
        customer_id: laon_details.customer_id,
        date: Date.utc_today,
        date_to: employee_datails.contract_end_date,
        employer: employee_datails.employer,
        employer_email_address: employee_datails.hr_supervisor_email,
        employer_phone: employee_datails.hr_supervisor_mobile_number,
        employment_date: employee_datails.contract_start_date,
        employment_status: employee_datails.employment_type,
        job_title: employee_datails.job_title,
        province: params["province"],
        reference_no: laon_details.reference_no,
        supervisor_name: employee_datails.hr_supervisor_name,
        town: address_update.town
      })|> Repo.insert()
      # ----------------------------------- Reference
      reference_name = params["name"]

      if reference_name == nil || reference_name == [] || reference_name == ["undefined"] do
        IO.puts("No Reference Attachment Detected")
      else
        for x <- 0..(Enum.count(reference_name) - 1) do
          reference_params = %{
            customer_id: laon_details.customer_id,
            reference_no: laon_details.reference_no,
            name: Enum.at(reference_name, x),
            contact_no: Enum.at(params["contact_no"], x)
          }

          Loan_applicant_reference.changeset(%Loan_applicant_reference{}, reference_params)
          |> Repo.insert()
        end
      end

      Loan_customer_details.changeset(%Loan_customer_details{}, %{
        customer_id: laon_details.customer_id,
        reference_no: laon_details.reference_no,
        firstname: params["firstname"],
        surname: params["surname"],
        othername: params["othername"],
        id_type: params["id_type"],
        id_number: params["id_number"],
        gender: params["gender"],
        marital_status: params["marital_status"],
        cell_number: params["cell_number"],
        email: params["email"],
        dob: params["dob"],
        residential_address: params["house_number"],
        landmark: params["landmark"],
        town: params["town"],
        province: params["province"],
        company_name: employee_datails.employer,
        company_phone_no: params["employer_phone_info"],
        company_email: params["employer_email_address_info"],
        company_tpin: company_details.taxno,
        sector: params["sector"],
        employee_number: employee_datails.employee_number,
      })
      |> Repo.insert()
    end)
    |> IO.inspect(label: "---------------------------- all records")
    |> Repo.transaction()
    |> case do
      {:ok, %{laon_details: laon_details}} ->
        loan_detail = Loans.find_by(reference_no: laon_details.reference_no)

        nrc =
          try do
            Loanmanagementsystem.Accounts.UserBioData.find_by(userId: laon_details.customer_id).meansOfIdentificationNumber
          rescue
            _ -> ""
          end

          Loanmanagementsystem.Services.LoanDocumentsUploads.client_upload(%{
          "process_documents" => params,
          "conn" => conn,
          "nrc" => nrc,
          "loan_id" => loan_detail.id,
          "file_category" => "LOAN_DOCUMENTS"
        })

        conn
        |> put_flash(:info, "Loan Application Submitted")
        |> redirect(to: Routes.employee_path(conn, :pending_loans))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.employee_path(conn, :pending_loans))
    end
  end
  @spec validate_otp(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def validate_otp(conn, params) do

    client_line = params["client_line"]
    product_id = params["product_id"]

    # generate_otp = to_string(Enum.random(1111..9999))

    otp1 = params["otp1"]
    otp2 = params["otp2"]
    otp3 = params["otp3"]
    otp4 = params["otp4"]
    user_otp = "#{otp1}#{otp2}#{otp3}#{otp4}"

    client_role = Loanmanagementsystem.Accounts.get_client_by_line(client_line)

    my_client_role = Loanmanagementsystem.Accounts.get_user_role!(client_role.role_id)

    if my_client_role.otp == user_otp do


          Ecto.Multi.new()
          |> Ecto.Multi.update(
            :otp_validate,
            UserRole.changeset(
              my_client_role,
              Map.merge(params, %{"otp" => ""})
            )
          )
          |> Ecto.Multi.run(:user_logs, fn _, %{otp_validate: _otp_validate} ->
            UserLogs.changeset(%UserLogs{}, %{
              activity: "OTP Validated Successfully ",
              user_id: conn.assigns.user.id
            })
            |> Repo.insert()
          end)
          |> Repo.transaction()
          |> case do
            {:ok, %{otp_validate: _otp_validate, user_logs: _user_logs}} ->
              conn
              |> put_flash(:info, "OTP Validated Successfully Proceed With Your Loan Application")
              |> redirect(to: Routes.employee_path(conn, :quick_loan_capturing, client_line: "#{client_line}", product_id: "#{product_id}"))
          end
    else

    conn
      |> put_flash(:error, "OTP does not match")
      |> redirect(to: Routes.employee_path(conn, :otp_validation, client_line: "#{client_line}", product_id: "#{product_id}"))


    end
  end

  def send_otp(conn, params) do
    IO.inspect(params, label: "Hello SADC")

    product_id = params["product_id"]
    client_line = params["client_line"]
    generate_otp = to_string(Enum.random(1111..9999))

    text = "To verify your loan initiation, please provide the OTP - #{generate_otp}"

    params = Map.put(params, "mobile", client_line)
    params = Map.put(params, "msg", text)
    params = Map.put(params, "status", "READY")
    params = Map.put(params, "type", "SMS")
    params = Map.put(params, "msg_count", "1")

    if Loanmanagementsystem.Accounts.UserBioData.exists?(mobileNumber: "#{client_line}") == true do

    client_role = Loanmanagementsystem.Accounts.get_client_by_line(client_line)

     my_client_role = Loanmanagementsystem.Accounts.get_user_role!(client_role.role_id)

     Loanmanagementsystem.Accounts.update_user_role(my_client_role, %{otp: generate_otp})



      Ecto.Multi.new()
      |> Ecto.Multi.insert(:loan_otp, Sms.changeset(%Sms{}, params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_otp: _loan_otp} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Add send loan OTP Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{loan_otp: _loan_otp, user_logs: _user_logs}} ->
          Loanmanagementsystem.Workers.Sms.send()
          conn
          |> put_flash(:info, "OTP has been sent to your Mobile Number")
          |> redirect(to: Routes.employee_path(conn, :otp_validation, client_line: "#{client_line}", product_id: "#{product_id}"))

        {:error, _failed_operation, _failed_value, _changes_so_far} -> IO.inspect("------------------")

      end

        else
          conn
          |> put_flash(:error, "The number you entered is not registered: Check the number and try again.")
          |> redirect(to: Routes.employee_path(conn, :get_otp, product_id: "#{product_id}"))

    end


  end

  def disbursed_loans(conn, _params),
    do:
      render(conn, "disbursed_loan.html",
        products:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "DISABLED"))
      )

  def pending_loans(conn, _params) do
    current_user = conn.assigns.user.id
    loan_details =
    Loanmanagementsystem.Operations.get_pending_loan_by_userId(current_user)
    render(conn, "pending_loans.html", loan_details: loan_details)
  end


  def pending_loans_item_lookup(conn, params) do
    user_id = conn.assigns.user.id
    {draw, start, length, search_params} = search_options(params)

    results = Loanmanagementsystem.Operations.pending_loan_list(search_params, start, length, user_id)

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



  def tracking_loans_item_lookup(conn, params) do
    user_id = conn.assigns.user.id
    {draw, start, length, search_params} = search_options(params)

    results = Loanmanagementsystem.Operations.tracking_loan_list(search_params, start, length, user_id)

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

  def loan_tracking(conn, _params) do
    current_user = conn.assigns.user.id

    render(conn, "loan_tracker.html",
      loan_details: Loanmanagementsystem.Loan.get_loan_by_userId(current_user)
    )
  end

  def loan_products(conn, _params) do
    products =
      Loanmanagementsystem.Products.list_tbl_products() |> Enum.reject(&(&1.status != "ACTIVE"))

    IO.inspect(products, label: "Am here man!")
    render(conn, "loan_products.html", products: products)
  end

  def individual_loan_products(conn, _params),
    do:
      render(conn, "individual_loan_products.html",
        products:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "PENDING"))
      )

  def employee_mini_statement(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")
    current_user_details = Accounts.get_details(currentUserRole.userId)
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    users = Loanmanagementsystem.Accounts.get_system_admin()
    loans = Loanmanagementsystem.Accounts.get_customer_account(conn.assigns.user.id)
    loan_details = Loanmanagementsystem.Loan.get_loan_by_userId(conn.assigns.user.id)
    # roles = Accounts.list_tbl_user_role()
    render(conn, "loans_mini_statement.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users,
      current_user_details: current_user_details,
      loans: loans,
      loan_details: loan_details
    )
  end

  def employee_full_statement(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")
    current_user_details = Accounts.get_details(currentUserRole.userId)
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    users = Loanmanagementsystem.Accounts.get_system_admin()
    loans = Loanmanagementsystem.Accounts.get_customer_account(conn.assigns.user.id)
    loan_details = Loanmanagementsystem.Loan.get_loan_by_userId(conn.assigns.user.id)
    # roles = Accounts.list_tbl_user_role()
    render(conn, "loans_full_statement.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users,
      current_user_details: current_user_details,
      loans: loans,
      loan_details: loan_details
    )
  end

  def make_payment_view(conn, _params) do
    current_user = conn.assigns.user.id

    render(conn, "make_repayment.html",
      loan_details: Loanmanagementsystem.Loan.get_loan_by_userId(current_user)
    )
  end

  def make_payment_view_view(conn, params) do
    current_user = conn.assigns.user.id

    render(conn, "make_payment_view_view.html",
      loan_details: Loanmanagementsystem.Loan.get_loan_by_userId(current_user),
      products: Loanmanagementsystem.Products.get_product!(params["product_id"]),
      loans: Loanmanagementsystem.Loan.get_loans!(params["loan_id"]),
      loan_id: params["loan_id"]
    )
  end

  def user_mgt(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")
    # current_user_details = Accounts.get_details(currentUserRole.userId)
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    users = Loanmanagementsystem.Accounts.get_system_admin()
    # roles = Accounts.list_tbl_user_role()
    render(conn, "user_mgt.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users
    )
  end

  def all_staffs(conn, _params) do
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    users = Loanmanagementsystem.Accounts.get_system_admin()

    render(conn, "staff_mgt.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users
    )
  end

  def selected_loan_product(conn, %{"product_id" => product_id}) do
    current_user = conn.assigns.user.id

    IO.inspect(current_user, label: "DDDDDDDDDDDDDDDDDD")
    get_bio_datas = Accounts.get_details(current_user)

    product_details = Products.otc_product_details_lookup(product_id)

    render(conn, "loan_application.html",
      product_details: product_details,
      get_bio_datas: get_bio_datas
    )
  end

  def employee_edit_my_profile_details(conn, params) do
    IO.inspect("DDDDDDDDDDDDDDDDDDDDD")
    IO.inspect(params)
    IO.inspect("DDDDDDDDDDDDDDDDDDDDD")
    user = Loanmanagementsystem.Accounts.get_user!(String.to_integer(params["id"]))
    employee = Loanmanagementsystem.Accounts.get_user_bio_data!(String.to_integer(params["id"]))

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_user, User.changeset(user, %{username: params["mobileNumber"]}))
    |> Ecto.Multi.run(:update_employee_details, fn _repo, %{update_user: _update_user} ->
      UserBioData.changeset(employee, %{
        emailAddress: params["emailAddress"],
        mobileNumber: params["mobileNumber"],
        title: params["title"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       update_employee_details: _update_employee_details,
                                       update_user: _update_user
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Successfully Updated Employee Info!!!!",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You Have Succeffully Updated Your Data")
        |> redirect(to: Routes.employee_path(conn, :employee_profile))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        activity = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, activity)
        |> redirect(to: Routes.employee_path(conn, :employee_profile))
    end
  end

  def client_loan_application(conn, params) do
    current_user = conn.assigns.user.id
    # get_bio_datas = Accounts.get_details(current_user)

    new_params =
      Map.merge(params, %{
        "customer_id" => current_user,
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
        |> redirect(to: Routes.employee_path(conn, :pending_loans))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.employee_path(conn, :pending_loans))
    end
  end

  # ------------------------------------------------MIZ---------------------------------------------------------------------
  def employee_profile(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")
    current_user_details = Loanmanagementsystem.Accounts.get_details(conn.assigns.user.id)
    IO.inspect(current_user_details, label: "Am here man!")
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    users = Loanmanagementsystem.Accounts.get_system_admin()

    loans = Loanmanagementsystem.Accounts.get_customer_account(conn.assigns.user.id)

    companys = Loanmanagementsystem.Companies.get_company!(conn.assigns.user.company_id)

    loan_details = Loanmanagementsystem.Loan.get_loan_by_userId(conn.assigns.user.id)

    render(conn, "employee_profile.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users,
      current_user_details: current_user_details,
      loans: loans,
      companys: companys,
      loan_details: loan_details
    )
  end

  def quick_advance_application_employee(conn, _params),
    do: render(conn, "quick_advance_application.html")

  def quick_loan_application_employee(conn, _params),
    do: render(conn, "quick_loan_application.html")

  def quick_loan_capturing(conn, params),
    do:
      render(conn, "loan_capturing.html",
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details:
          Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        frequencies: Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]).repayment,
        users: Loanmanagementsystem.Accounts.get_user_by_bio_data(conn.assigns.user.id)
      )

  def create_quick_loan_employee_application(conn, params) do
    loan_calculations = calculate_interest_and_repaymnent_amt(params)
    otp = to_string(Enum.random(1111..9999))

    if params["customer_id"] != "" || params["customer_id"] != nil do
      new_params =
        Map.merge(params, %{
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => loan_calculations.currency_code,
          "loan_type" => params["product_type"],
          "tenor" => loan_calculations.tenor,
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
          |> redirect(to: Routes.employee_path(conn, :loan_tracking))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.employee_path(conn, :loan_tracking))
      end
    else
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
                                              %{add_user: _add_user, add_user_role: _add_user_role} ->
        id = to_string(Enum.random(1111..9999))
        ref_id = "Ref_#{id}"
        loan_id = "Loan#{id}"

        Loans.changeset(%Loans{}, %{
          "customer_id" => params["customer_id"],
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => params["currency_code"],
          "loan_type" => params["product_type"],
          "principal_amount" => params["amount"],
          "reference_no" => ref_id,
          "loan_identity_number" => loan_id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_user: _add_user}} ->
          conn
          |> put_flash(:info, "Loan Application Submitted")
          |> redirect(to: Routes.employee_path(conn, :loan_tracking))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.employee_path(conn, :loan_tracking))
      end
    end
  end

  # LoanmanagementsystemWeb.EmployeeController.calculate_interest_and_repaymnent_amt(%{"product_id" => "1", "tenor_log" => "30", "amount" => "500"})
  def calculate_interest_and_repaymnent_amt(params) do
    with(false <- params["product_id"] == "" || params["tenor_log"] == "") do
      repayment_frequency =
        Loanmanagementsystem.Products.Product_rates.find_by(
          product_id: params["product_id"],
          tenor: params["tenor_log"]
        ).repayment

      rate =
        Loanmanagementsystem.Products.Product_rates.find_by(
          product_id: params["product_id"],
          tenor: params["tenor_log"]
        ).interest_rates

      processing_fee =
        Loanmanagementsystem.Products.Product_rates.find_by(
          product_id: params["product_id"],
          tenor: params["tenor_log"]
        ).processing_fee

      currency =
        Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).currencyName

      principle_amt =
        try do
          String.to_integer(params["amount"])
        rescue
          _ -> String.to_float(params["amount"])
        end

      tenor =
        try do
          String.to_integer(params["tenor_log"])
        rescue
          _ -> String.to_float(params["tenor_log"])
        end

      case repayment_frequency do
        "Daily" ->
          days = 1
          interest_rate = rate + processing_fee
          interest = days / tenor * principle_amt * interest_rate / 100
          repayment = principle_amt + interest

          %{
            interest_amt: Float.round(interest, 2),
            repayement_amt: Float.round(repayment, 2),
            tenor: tenor,
            currency_code: currency
          }

        "Weekly" ->
          days = 7
          interest_rate = rate + processing_fee
          interest = days / tenor * principle_amt * interest_rate / 100
          repayment = principle_amt + interest

          %{
            interest_amt: Float.round(interest, 2),
            repayement_amt: Float.round(repayment, 2),
            tenor: tenor,
            currency_code: currency
          }

        "Monthly" ->
          days = 30
          interest_rate = rate
          interest = days / tenor * principle_amt * interest_rate / 100
          repayment = principle_amt + interest

          %{
            interest_amt: Float.round(interest, 2),
            repayement_amt: Float.round(repayment, 2),
            tenor: tenor,
            currency_code: currency
          }
      end
    else
      _ ->
        %{
          interest_amt: "",
          repayement_amt: "",
          tenor: "",
          currency_code: ""
        }
    end
  end

  # LoanmanagementsystemWeb.EmployeeController.test_run
  def test_run do
    days = 1
    tenor = 30
    # processing_fee = 50
    interest_rate = 15
    principle_amt = 500
    # interest_rate = rate + processing_fee
    # interest = principle_amt * interest_rate / 12 * tenor / 100
    interest = days / tenor * principle_amt * interest_rate / 100

    IO.inspect("INTEREST --------------------")
    IO.inspect(Float.round(interest, 2))
    # repayment = principle_amt + interest
  end

  def make_payements_employee(conn, params) do
    bank_account_no =
      if params["bank_account_no"] == nil || params["bank_account_no"] == "" do
        nil
      else
        params["bank_account_no"]
      end

    mode_of_repayment =
      if params["bank_account_no"] == nil || params["bank_account_no"] == "" do
        params["disbursement_method"]
      else
        "BANK TRANSFER"
      end

    account_name =
      if params["account_name"] == nil || params["account_name"] == "" do
        nil
      else
        params["account_name"]
      end

    # expiry_month = if params["expiry_month"] == nil || params["expiry_month"] == "" do
    #   nil
    # else
    #   params["expiry_month"]
    # end

    # expiry_year = if params["expiry_year"] == nil || params["expiry_year"] == "" do
    #   nil
    # else
    #   params["expiry_year"]
    # end
    cvv =
      if params["cvv"] == nil || params["cvv"] == "" do
        nil
      else
        params["cvv"]
      end

    receipt_no = to_string(Enum.random(11_111_111..99_999_999))

    balance = Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"]).balance

    # repayment_amount =
    #   Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"]).repayment_amount

    total_repaid = Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"]).total_repaid

    total_repayment_derived =
      Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"]).total_repayment_derived

    penalty_charges_charged_derived =
      Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"]).penalty_charges_charged_derived

    principal_amount =
      Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"]).principal_amount

    expected_maturity_date =
      Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"]).expected_maturity_date

    total_repaid =
      if total_repaid == nil do
        0
      else
        total_repaid
      end

    total_repayment_derived =
      if total_repayment_derived == nil do
        0
      else
        total_repayment_derived
      end

    payable_amount =
      try do
        String.to_integer(params["payable_amount"])
      rescue
        _ -> String.to_float(params["payable_amount"])
      end

    balance = balance - payable_amount

    total_repaid1 = payable_amount + total_repaid

    total_repayment_derived1 = payable_amount + total_repayment_derived

    laon = Loanmanagementsystem.Loan.get_loan_by_userId(conn.assigns.user.id)
    loan = Loanmanagementsystem.Loan.get_loans_by_loan_id(params["loan_id"])

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :make_repayments,
      LoanRepayment.changeset(%LoanRepayment{}, %{
        amountRepaid: params["payable_amount"],
        chequeNo: nil,
        dateOfRepayment: Timex.today() |> Date.to_string(),
        modeOfRepayment: mode_of_repayment,
        receiptNo: receipt_no,
        recipientUserRoleId:
          Enum.map(laon, fn map -> map end) |> Enum.at(0) |> Map.fetch!(:user_role_id),
        registeredByUserId: conn.assigns.user.id,
        repayment: params["payable_amount"],
        company_id: Enum.map(laon, fn map -> map end) |> Enum.at(0) |> Map.fetch!(:company_id),
        loan_product:
          Enum.map(laon, fn map -> map end) |> Enum.at(0) |> Map.fetch!(:product_name),
        repayment_type: params["repayment_type"],
        repayment_method: params["repayment_method"],
        bank_name: params["bank_name"],
        branch_name: params["branch_name"],
        swift_code: params["swift_code"],
        expiry_date: expected_maturity_date,
        cvc: cvv,
        bank_account_no: bank_account_no,
        account_name: account_name,
        bevura_wallet_no: nil,
        receipient_number: params["receipient_number"],
        mno_mobile_no: params["receipient_number"],
        reference_no:
          Enum.map(laon, fn map -> map end) |> Enum.at(0) |> Map.fetch!(:reference_no),
        status: "PENDING",
        loan_id: Enum.map(laon, fn map -> map end) |> Enum.at(0) |> Map.fetch!(:id)
      })
    )
    |> Ecto.Multi.update(
      :update_loan_balance,
      Loans.changeset(loan, %{
        balance: balance,
        repayment_amount: balance,
        total_repaid: total_repaid1,
        total_repayment_derived: total_repayment_derived1
      })
    )
    |> Ecto.Multi.run(:add_transaction, fn _repo,
                                           %{
                                             make_repayments: make_repayments,
                                             update_loan_balance: update_loan_balance
                                           } ->
      LoanTransaction.changeset(%LoanTransaction{}, %{
        amount: params["payable_amount"],
        branch_id: params["branch_id"],
        external_id: params["external_id"],
        fee_charges_portion_derived: params["fee_charges_portion_derived"],
        interest_portion_derived: params["interest_portion_derived"],
        is_reversed: false,
        loan_id: update_loan_balance.id,
        manually_adjusted_or_reversed: false,
        manually_created_by_userid: nil,
        outstanding_loan_balance_derived: balance,
        overpayment_portion_derived: params["overpayment_portion_derived"],
        payment_detail_id: make_repayments.id,
        penalty_charges_portion_derived: penalty_charges_charged_derived,
        principal_portion_derived: principal_amount,
        submitted_on_date: Timex.today(),
        transaction_date: Timex.today(),
        transaction_type_enum: params["transaction_type_enum"],
        unrecognized_income_portion: params["unrecognized_income_portion"],
        transaction_ref: receipt_no,
        settlementStatus: "PENDING",
        momoProvider: params["momoProvider"],
        debit_account_number: params["debit_account_number"],
        debit_amount: params["debit_amount"],
        credit_account_number: params[""],
        credit_amount: params["payable_amount"],
        bank_name: nil,
        bank_branch: nil,
        bank_account_no: bank_account_no,
        bank_account_name: account_name,
        bank_swift_code: nil,
        mno_type: params["disbursement_method"],
        mno_mobile_no: params["receipient_number"],
        customer_id: conn.assigns.user.id,
        narration: params["narration"],
        drcr_ind: params["drcr_ind"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       make_repayments: _make_repayments,
                                       update_loan_balance: _update_loan_balance,
                                       add_transaction: _add_transaction
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You Have Successfully done Loan Repayment",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You Have Successfully done Loan Repayment")
        |> redirect(to: Routes.employee_path(conn, :make_payment_view))

      {:error, _failed_operations, faile_value, _changes_so_far} ->
        reason = traverse_errors(faile_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.employee_path(conn, :make_payment_view))
    end
  end







  # def sample(conn, params) do
  #   json(conn, payloads: Loanmanagementsystem.get_loan_info())
  # end




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


  # ------------------------------------------------MIZ END-----------------------------------------------------------------

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end

  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:employee_client, :create}
      act when act in ~w(index view)a -> {:employee_client, :view}
      act when act in ~w(update edit)a -> {:employee_client, :edit}
      act when act in ~w(change_status)a -> {:employee_client, :change_status}
      _ -> {:employee_client, :unknown}
    end
  end


end
