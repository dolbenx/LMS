defmodule LoanmanagementsystemWeb.ClientManagementController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false

  # alias Loanmanagementsystem.Maintenance.{Currency, Country, Province, District, Security_questions, Branch, Bank, Classification}
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole}
  alias Loanmanagementsystem.Emails.Email
  # alias Loanmanagementsystem.Charges.Charge
  # alias Loanmanagementsystem.Loan.Customer_Balance
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Companies.{Employee, Client_company_details}
  alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Employment.Personal_Bank_Details
  alias Loanmanagementsystem.Maintenance.{Classification, Bank}
  alias Loanmanagementsystem.Merchants.Merchant
  alias Loanmanagementsystem.Merchants.Merchant_director
  alias Loanmanagementsystem.Merchants.Merchants_device
  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Accounts.Nextofkin
  alias Loanmanagementsystem.Accounts.Client_Documents
  alias Loanmanagementsystem.Employment.Income_Details
  alias Loanmanagementsystem.Accounts.Client_reference
  alias Loanmanagementsystem.Loan.Loan_market_info
  alias Loanmanagementsystem.Loan.Customer_Balance
  alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Accounts.Customer_account

  # alias Loanmanagementsystem.OperationsServices

# LoanmanagementsystemWeb.ClientManagementController.push_to_reference_table

  plug LoanmanagementsystemWeb.Plugs.Authenticate,
       [module_callback: &LoanmanagementsystemWeb.ClientManagementController.authorize_role/1]
       when action not in [
        :client_maintainence,
        :add_client,
        :edit_individual,
        :create_client_user,
        :edit_client_employee,
        :edit_client_individual,
        :activate_client,
        :deactivate_client,
        :mobile_money_argents,
        :employer_maintainence,
        :client_managers_relationship,
        :blacklisted_clients,
        :fuel_importer_maintenance,
        :merchant_maintenance,
        :oct_company_lookup,
        :admin_activate_classification,
        :admin_edit_employer_employee,
        :admin_activate_user,
        :admin_deactivate_user,
        :admin_update_employer_maintainence,
        :init_acc_no_generation,
        :sequence_no,
        :reset_sequence,
        :admin_create_merchant,
        :admin_create_momo_agent,
        :push_to_director_details,
        :push_to_userlog,
        :push_to_device,
        :push_to_users,
        :push_to_user_role,
        :push_to_user_bio_data,
        :client_relationship_manager_item_lookup,
        :total_entries,
        :entries,
        :search_options,
        :calculate_page_num,
        :calculate_page_size,
        :client_manager_item_lookup,
        :change_client_manager,
        :individual_maintainence,
        :add_individual,
        :create_individual_user,
        :view_individual_details,
        :display_pdf,
        :deactivate_client_document,
        :activate_client_document,
        :edit_employee,
        :client_onboarding_upload,
        :handle_client_bulk_upload,
        :customer_360_view,
        :employer_item_lookup,
        :create_reference,
        :update_reference
            ]

  use PipeTo.Override



  def client_maintainence(conn, _request) do
    employee = Loanmanagementsystem.OperationsServices.get_client_details()
    companies = Loanmanagementsystem.Companies.list_tbl_company()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()

    render(conn, "client_maintainence.html", employee: employee, banks: banks, branches: branches, departments: departments, companies: companies)
  end

  def add_client(conn, _request) do
    companies = Loanmanagementsystem.Companies.list_all_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "add_client.html", companies: companies, departments: departments, banks: banks, town: town, province: province)
  end

  def edit_employee(conn, %{"userid" => userid, "company_id" => company_id}) do
    company = if company_id == "" do 0 else company_id end
    companies = Loanmanagementsystem.Companies.list_all_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    employee = Loanmanagementsystem.OperationsServices.get_client_individual_details(userid)
    user_doc = Loanmanagementsystem.OperationsServices.get_individual_docs(userid)
    employer = Loanmanagementsystem.OperationsServices.get_client_employer_by_user_id(company)
    user_bank_details =  Loanmanagementsystem.Employment.get_user_bank_details_by_user_id(userid)
    render(conn, "edit_employee.html", user_doc: user_doc, employer: employer, user_bank_details: user_bank_details, employee: employee, companies: companies, departments: departments, banks: banks, town: town, province: province)
  end

  def edit_individual(conn, %{"userid" => userid}) do
    market_details = Loanmanagementsystem.OperationsServices.get_client_market_details_by_user_id(userid)
    business_details = Loanmanagementsystem.OperationsServices.get_client_business_details_by_user_id(userid)
    client_ref = Loanmanagementsystem.OperationsServices.get_client_referes_by_user_id(userid)
    user_doc = Loanmanagementsystem.OperationsServices.get_individual_docs(userid)
    employee = Loanmanagementsystem.OperationsServices.get_client_individual_details(userid)
    companies = Loanmanagementsystem.Companies.list_tbl_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    user_bank_details =  Loanmanagementsystem.Employment.get_user_bank_details_by_user_id(userid)
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "edit_individual.html", town: town, province: province, user_bank_details: user_bank_details, business_details: business_details, market_details: market_details, client_ref: client_ref, user_doc: user_doc, companies: companies, departments: departments, banks: banks, employee: employee)
  end

  def create_client_user(conn, params) do
    IO.inspect(params["bank_id"], label: "BANK_ID")
    IO.inspect(params["company_id"], label: "COMPANY_ID")

    if params["company_id"] == nil do
      conn
      |> put_flash(:error, "Please select a company The employee Belongs to.")
      |> redirect(to: Routes.client_management_path(conn, :client_maintainence))
    else

      param =
      if params["employee_confirmation"] == "on" do
        true
      else
        false
      end

      params = Map.merge(params, %{"employee_confirmation" => param})


      param =
        if params["applicant_declaration"] == "on" do
          true
        else
          false
        end

      params = Map.merge(params, %{"applicant_declaration" => param})

      password = "pass-#{Enum.random(1_000_000_000..9_999_999_999)}"

      bank_name = try do Bank.find_by(id: params["bank_id"]).bankName rescue _-> "" end

      IO.inspect(bank_name, label: "BANK_NAME")


      branch_name = try do Bank.find_by(id: params["bank_id"]).process_branch rescue _-> "" end

      # company_id = String.length(params, "company_id", params["client_company_id"])



      IO.inspect("Pushing For Employee")
      otp = to_string(Enum.random(1111..9999))
      account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"


      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :add_employer_user,
        User.changeset(%User{}, %{
          password: password,
          status: "INACTIVE",
          username: params["emailAddress"],
          auto_password: "Y",
          company_id: params["company_id"],
          pin: otp,
          with_mou: true
        }))
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
          bank_account_number: params["bank_account_number"],
          marital_status: params["marital_status"],
          nationality: params["nationality"],
          number_of_dependants: params["number_of_dependants"],
          disability_status: params["disability_status"],
          disability_detail: params["disability_detail"],
          employee_confirmation: params["employee_confirmation"],
          applicant_declaration: params["applicant_declaration"],
          employee_number: params["employee_number"],
        })
        |> Repo.insert()
      end)

      |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data } ->
        UserRole.changeset(%UserRole{}, %{
          roleType: "EMPLOYEE",
          status: "INACTIVE",
          client_type: params["client_type"],
          userId: add_employer_user.id,
          otp: otp
        })
        |> Repo.insert()
      end)

      |> Ecto.Multi.run(:add_employer_employee, fn _repo,%{add_user_role: add_user_role, add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data} ->
        Employee.changeset(%Employee{}, %{
          companyId: params["company_id"],
          employerId: params["company_id"],
          status: "INACTIVE",
          userId: add_employer_user.id,
          userRoleId: add_user_role.id,
          loan_limit: params["loan_limit"],
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_user_role: _add_user_role, add_employer_user: add_employer_user,add_user_bio_data: _add_user_bio_data, add_employer_employee: _add_employer_employee } ->
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

      |> Ecto.Multi.run(:add_employment_details, fn _repo,%{add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data} ->
        Employment_Details.changeset(%Employment_Details{}, %{
          area: params["area"],
          date_of_joining: params["date_of_joining"],
          employee_number: params["employee_number"],
          employer: params["employer",],
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
          departmentId: params["departmentId"],
          contract_start_date: params["contract_start_date"],
          contract_end_date: params["contract_end_date"]
        })
        |> Repo.insert()
      end)

      |> Ecto.Multi.run(:add_Personal_details, fn _repo, %{add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data} ->
        Personal_Bank_Details.changeset(%Personal_Bank_Details{}, %{
          accountName: params["accountName"],
          accountNumber: params["bank_account_number"],
          bankName: bank_name,
          branchName: branch_name,
          upload_bank_statement: nil,
          userId: add_employer_user.id,
          bank_id: params["bank_id"],
          mobile_number: params["mobile_number"],
        })
        |> Repo.insert()
      end)


      |> Ecto.Multi.run(:push_to_income, fn _repo, %{add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data} ->
        Income_Details.changeset(%Income_Details{}, %{
            pay_day: params["pay_day"],
            gross_pay: params["gross_pay"],
            total_deductions: params["total_deductions"],
            net_pay: params["net_pay"],
            total_expenses: params["total_expenses"],
            upload_payslip: params["upload_payslip"],
            userId: add_employer_user.id,

        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:customer_balance, fn _repo, %{ add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: add_employer_user,add_user_bio_data: _add_user_bio_data} ->
        customer_balance = %{
          account_number: account_number,
          user_id: add_employer_user.id
        }
        case Repo.insert(Customer_Balance.changeset(%Customer_Balance{}, customer_balance)) do
          {:ok, message} -> {:ok, message}
          {:error, response} -> {:error, response}
        end
      end)
      |> Ecto.Multi.run(:client_document, fn _repo, %{ add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: add_employer_user,add_user_bio_data: add_user_bio_data } ->
        Loanmanagementsystem.Services.ClientUploads.client_upload(%{ "process_documents" => params, "conn" => conn, "company_id" => params["company_id"], "individualId" => add_employer_user.id, "nrc" => add_user_bio_data.meansOfIdentificationNumber })
      end)

      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: _add_employer_user,add_user_bio_data: _add_user_bio_data, client_document: _client_document} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Added User Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)


      |> Repo.transaction()
      |> case do
        {:ok, %{add_user_bio_data: add_user_bio_data}} ->
          Email.send_email(params["emailAddress"], password, params["password"])
          conn
          |> put_flash(:info,"You have Successfully Created #{add_user_bio_data.firstName} #{add_user_bio_data.lastName} As An Employee")
          |> redirect(to: Routes.client_management_path(conn, :client_maintainence))

        {:error, _failed_operations, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.client_management_path(conn, :client_maintainence))
        end
      end
  end


  def edit_client_employee(conn, params) do

    get_company_id = if params["company_id"] == "" do params["current_company_id"] else params["company_id"] end
    # applicant_signature = image_data_applicant_signature(params)
    # applicant_signature_encode_img = if applicant_signature != false  do parse_image(applicant_signature.path) else userbiodate.applicant_signature_image end

    userbiodate = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])

    employment_details =Loanmanagementsystem.Employment.get_employment__details_by_userId(params["id"])

    personal_bank_details = Loanmanagementsystem.Employment.get_personal__bank__details_by_userId(params["id"])

    employee = Loanmanagementsystem.Companies.get_employee_by_userId(params["id"])

    address_details = Loanmanagementsystem.Accounts.get_address__details_by_userId(params["id"])

    update_companyId = Loanmanagementsystem.Accounts.get_user!(params["id"])

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

    |> Ecto.Multi.run(:update_client_id, fn _repo, %{update_userbiodate: _update_userbiodate} ->


      User.changeset(update_companyId, %{

          company_id: get_company_id

      })
      |> Repo.update()
    end)

    |> Ecto.Multi.run(:update_employment_details, fn _repo, %{update_userbiodate: _update_userbiodate, update_client_id: _update_client_id} ->
      Employment_Details.changeset(employment_details, %{

        area: params["employment_area"],
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
        province: params["employer_province"],
        town: params["employer_town"]
      })
      |> Repo.update()
    end)

    |> Ecto.Multi.run(:update_address_details, fn _repo, %{ update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_client_id: _update_client_id} ->
      Address_Details.changeset(address_details, %{

        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        # year_at_current_address: params["year_at_current_address"]
      })
      |> Repo.update()
    end)

    |> Ecto.Multi.run(:update_personal_bank, fn _repo, %{update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_address_details: _update_address_details, update_client_id: _update_client_id} ->
      Personal_Bank_Details.changeset(personal_bank_details, %{

        accountName: params["accountName"],
        accountNumber: params["bank_account_number"],
        bankName: params["bankName"],
        branchName: params["branchName"],
        upload_bank_statement: params["upload_bank_statement"]
      })
      |> Repo.update()
    end)

    |> Ecto.Multi.run(:update_employee, fn _repo, %{update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_address_details: _update_address_details, update_personal_bank: _update_personal_bank, update_client_id: _update_client_id} ->
      Employee.changeset(employee, %{

        companyId: params["company_id"],
        employerId: params["company_id"]

      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_employment_details: _update_employment_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated Client Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated Client Details")
        |> redirect(to: Routes.client_management_path(conn, :client_maintainence))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :client_maintainence))
    end
  end

  def edit_client_individual(conn, params) do

    applicant_signature = image_data_applicant_signature(params)
    # IO.inspect(params, label: "Check my params")



    userbiodate = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])

    applicant_signature_encode_img = if applicant_signature != false  do parse_image(applicant_signature.path) else userbiodate.applicant_signature_image end

    employment_details =Loanmanagementsystem.Employment.get_employment__details_by_userId(params["id"])

    personal_bank_details = Loanmanagementsystem.Employment.get_personal__bank__details_by_userId(params["id"])

    employee = Loanmanagementsystem.Companies.get_employee_by_userId(params["id"])

    client_company = Loanmanagementsystem.Companies.get_client_company_details_by_user_id!(params["id"])

    address_details = Loanmanagementsystem.Accounts.get_address__details_by_userId(params["id"])

    update_companyId = Loanmanagementsystem.Accounts.get_user!(params["id"])

    nextofkin_details =Loanmanagementsystem.Accounts.Nextofkin.find_by(id: params["kin_id"])
    # if Enum.dedup(params["filename"]) != [""] do
          client_userID = String.to_integer(params["user_id"])
          IO.inspect(client_company.id, label: " !!!!!! Check my Client User Id !!!!!!!!")
          params = Map.merge(params, %{"userID" => client_userID, "company_id" => 28})

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
              marital_status: params["marital_status"],
              applicant_signature_image: applicant_signature_encode_img,
              partners_full_names: params["partners_full_names"],
              partners_mobile_num: params["partners_mobile_num"]

          }))

          |> Ecto.Multi.run(:update_client_id, fn _repo, %{update_userbiodate: _update_userbiodate} ->
            User.changeset(update_companyId, %{

              company_id: params["company_id"],
              username: params["emailAddress"]

            })
            |> Repo.update()
          end)


          |> Ecto.Multi.run(:update_client_nextofkin, fn _repo, %{update_userbiodate: _update_userbiodate} ->
            Nextofkin.changeset(nextofkin_details, %{
              kin_ID_number: params["kin_ID_number"],
              kin_first_name: params["kin_first_name"],
              kin_gender: params["kin_gender"],
              kin_last_name: params["kin_last_name"],
              kin_mobile_number: params["kin_mobile_number"],
              kin_other_name: params["kin_other_name"],
              kin_personal_email: params["kin_personal_email"],
              kin_relationship: params["kin_relationship"],

            })
            |> Repo.update()
          end)


          |> Ecto.Multi.run(:update_employment_details, fn _repo, %{update_userbiodate: _update_userbiodate, update_client_id: _update_client_id} ->
            Employment_Details.changeset(employment_details, %{

              area: params["employment_area"],
              date_of_joining: params["date_of_joining"],
              employee_number: params["employee_number"],
              employer: params["company_name"],
              employer_industry_type: params["employer_industry_type"],
              employer_office_building_name: params["employer_office_building_name"],
              employer_officer_street_name: params["employer_officer_street_name"],
              employment_type: params["employment_type"],
              hr_supervisor_email: params["hr_supervisor_email"],
              hr_supervisor_mobile_number: params["hr_supervisor_mobile_number"],
              hr_supervisor_name: params["hr_supervisor_name"],
              job_title: params["job_title"],
              occupation: params["occupation"],
              province: params["employer_province"],
              town: params["employer_town"]
            })
            |> Repo.update()
          end)

          |> Ecto.Multi.run(:update_address_details, fn _repo, %{ update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_client_id: _update_client_id} ->
            Address_Details.changeset(address_details, %{

              accomodation_status: params["accomodation_status"],
              area: params["area"],
              house_number: params["house_number"],
              street_name: params["street_name"],
              town: params["town"],
              year_at_current_address: params["year_at_current_address"],
              land_mark: params["land_mark"]
            })
            |> Repo.update()
          end)

          |> Ecto.Multi.run(:update_personal_bank, fn _repo, %{update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_address_details: _update_address_details, update_client_id: _update_client_id} ->
            Personal_Bank_Details.changeset(personal_bank_details, %{

              accountName: params["accountName"],
              accountNumber: params["bank_account_number"],
              bankName: params["bankName"],
              branchName: params["branchName"],
              upload_bank_statement: params["upload_bank_statement"]
            })
            |> Repo.update()
          end)

          |> Ecto.Multi.run(:update_client_company, fn _repo, %{update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_address_details: _update_address_details, update_client_id: _update_client_id} ->
            Client_company_details.changeset(client_company, %{

              company_name: params["company_name"],
              company_phone: params["company_phone"],
              contact_email: params["contact_email"],
              taxno: params["taxno"],
              company_account_number: params["company_account_number"],
              company_bank_name: params["company_bank_name"],
              company_account_name: params["company_account_name"]

            })
            |> Repo.update()
          end)

          |> Ecto.Multi.run(:update_employee, fn _repo, %{update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_address_details: _update_address_details, update_personal_bank: _update_personal_bank, update_client_id: _update_client_id, update_client_company: update_client_company} ->
            Employee.changeset(employee, %{

              companyId: update_client_company.id,
              employerId: update_client_company.id

            })
            |> Repo.update()
          end)
          |> Ecto.Multi.run(:user_logs, fn _repo, %{update_employment_details: _update_employment_details} ->
            UserLogs.changeset(%UserLogs{}, %{
              activity: "Updated Client Successfully",
              user_id: conn.assigns.user.id
            })
            |> Repo.insert()
          end)
          |> Repo.transaction()
          |> case do
            {:ok, _} ->

              if Enum.dedup(params["filename"]) != [""] do

                IO.inspect client_userID, label: "client_userID ----------------------------------------"
                Loanmanagementsystem.Services.IndividualUploads.client_upload(%{"process_documents" => params, "conn" => conn, "individualId" => client_userID, "nrc" => params["meansOfIdentificationNumber"], "company_id" => 0})
              else
                "No document attached"
              end
              conn
              |> put_flash(:info, "You have Successfully Updated Client Details")
              |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))

            {:error, _failed_operations, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors)
              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
          end

  end

  def activate_client(conn, params) do

    Ecto.Multi.new()
    |> Ecto.Multi.update(:activate_user, User.changeset(Loanmanagementsystem.Accounts.get_user!(params["id"]), Map.merge(params, %{"status" => "ACTIVE"})))

    |> Ecto.Multi.run(:activate_user_role, fn _repo, %{activate_user: _activate_user} ->
    user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    UserRole.changeset(user_role, %{

      status: "ACTIVE"

    })|>Repo.update()

    end)

    |> Ecto.Multi.run(:user_logs, fn (_,%{activate_user: _activate_user, activate_user_role: _activate_user_role}) ->

      UserLogs.changeset(%UserLogs{}, %{

        activity: "Activated Client Successfully ",
        user_id: conn.assigns.user.id,
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Client activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first
        json(conn, %{error: reason})
    end
  end

  def deactivate_client(conn, params) do

    Ecto.Multi.new()
    |> Ecto.Multi.update(:activate_user, User.changeset(Loanmanagementsystem.Accounts.get_user!(params["id"]), Map.merge(params, %{"status" => "INACTIVE"})))

    |> Ecto.Multi.run(:activate_user_role, fn _repo, %{activate_user: _activate_user} ->
    user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    UserRole.changeset(user_role, %{

      status: "INACTIVE"

    })|>Repo.update()

    end)

    |> Ecto.Multi.run(:user_logs, fn (_,%{activate_user: _activate_user, activate_user_role: _activate_user_role}) ->

      UserLogs.changeset(%UserLogs{}, %{

        activity: "Deactivated Client Successfully ",
        user_id: conn.assigns.user.id,
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Client Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first
        json(conn, %{error: reason})
    end
  end

  def mobile_money_argents(conn, _params) do
    render(conn, "mobile_money_agents.html",
      banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
      momo_list: Loanmanagementsystem.Merchants.list_all_momo_merchants()
    )
  end

  @spec employer_maintainence(Plug.Conn.t(), any) :: Plug.Conn.t()
  def employer_maintainence(conn, _params) do
    IO.inspect(conn, label: "issgejwgsjagsjaja")

    render(conn, "employer_maintainence.html",
      companies:
        Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isEmployer != true)),
      banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
      branches: Loanmanagementsystem.Maintenance.list_tbl_branch(),
      classifications: Loanmanagementsystem.Maintenance.list_tbl_classification()
    )
  end

  def client_managers_relationship(conn, _params) do
    render(conn, "client_managers_relationship.html",
      client_relationship_managers: Loanmanagementsystem.Accounts.client_relationship_managers()
    )
  end

  def blacklisted_clients(conn, _params) do
    users = Loanmanagementsystem.OperationsServices.get_blacklisted_clients()
    render(conn, "blacklisted_clients.html", users: users)
  end

  def fuel_importer_maintenance(conn, _params) do
    render(conn, "fuel_importer_maintenance.html")
  end

  def merchant_maintenance(conn, _params) do
    render(conn, "merchant_maintenance.html",
      banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
      agent_merchant_list: Loanmanagementsystem.Merchants.list_merchants_agent()
    )
  end

  def oct_company_lookup(conn, %{"company_id" => company_id}) do
    company_details = Loanmanagementsystem.Companies.otc_company_details_lookup(company_id)
    json(conn, %{"data" => List.wrap(company_details)})
  end

  def admin_activate_classification(conn, params) do
    classification = Loanmanagementsystem.Maintenance.get_classification!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_class,
      Classification.changeset(classification, Map.merge(params, %{"status" => "ACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_class: activate_class} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated #{activate_class.classification} Classification Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_class: activate_class}} ->
        json(conn, %{
          data: "#{activate_class.classification} Classification activated successfully"
        })

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_edit_employer_employee(conn, params) do
    userbiodate = Loanmanagementsystem.Accounts.get_user_boi_data_by_user_id(params["id"])
    # userrole = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])

    employment_details =
      Loanmanagementsystem.Employment.get_employment__details_by_userId(params["id"])

    personal_bank_details =
      Loanmanagementsystem.Employment.get_personal__bank__details_by_userId(params["id"])

    employee = Loanmanagementsystem.Companies.get_employee_by_userId(params["id"])
    address_details = Loanmanagementsystem.Accounts.get_address__details_by_userId(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:userbiodate, UserBioData.changeset(userbiodate, params))
    |> Ecto.Multi.run(:employment_details, fn _repo, %{userbiodate: _userbiodate} ->
      Employment_Details.changeset(employment_details, %{
        area: params["employment_area"],
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
        province: params["employer_province"],
        town: params["employer_town"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_address_details, fn _repo,
                                                  %{
                                                    userbiodate: _userbiodate,
                                                    employment_details: _employment_details
                                                  } ->
      Address_Details.changeset(address_details, %{
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        year_at_current_address: params["year_at_current_address"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_personal_bank, fn _repo,
                                                %{
                                                  userbiodate: _userbiodate,
                                                  employment_details: _employment_details,
                                                  update_address_details: _update_address_details
                                                } ->
      Personal_Bank_Details.changeset(personal_bank_details, %{
        accountName: params["accountName"],
        accountNumber: params["bank_account_number"],
        bankName: params["bankName"],
        branchName: params["branchName"],
        upload_bank_statement: params["upload_bank_statement"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_employee, fn _repo,
                                           %{
                                             userbiodate: _userbiodate,
                                             employment_details: _employment_details,
                                             update_address_details: _update_address_details,
                                             update_personal_bank: _update_personal_bank
                                           } ->
      Employee.changeset(employee, %{
        companyId: params["company_id"],
        employerId: params["company_id"]
      })
      |> Repo.update()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated Employee details")
        |> redirect(to: Routes.client_management_path(conn, :employee_maintainence))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :employee_maintainence))
    end
  end

  def admin_activate_user(conn, params) do
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(user, Map.merge(params, %{"status" => "ACTIVE"}))
    )
    |> Ecto.Multi.run(:activate_user_role, fn _repo, %{activate_user: _activate_user} ->
      user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])

      UserRole.changeset(user_role, %{
        status: "ACTIVE"
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _,
                                     %{
                                       activate_user: _activate_user,
                                       activate_user_role: _activate_user_role
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "User Activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_deactivate_user(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(
        Loanmanagementsystem.Accounts.get_user!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:activate_user_role, fn _repo, %{activate_user: _activate_user} ->
      user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])

      UserRole.changeset(user_role, %{
        status: "INACTIVE"
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _,
                                     %{
                                       activate_user: _activate_user,
                                       activate_user_role: _activate_user_role
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "User Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_update_employer_maintainence(conn, params) do
    bank_id = String.to_integer(params["bank_id"])
    company = Loanmanagementsystem.Companies.get_company!(params["id"])

    params =
      Map.merge(params, %{
        "status" => "INACTIVE",
        "bank_id" => bank_id
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :add_company,
      Company.changeset(company, %{
        approval_trail: params["approval_trail"],
        auth_level: params["auth_level"],
        companyName: params["companyName"],
        companyPhone: params["companyPhone"],
        contactEmail: params["contactEmail"],
        registrationNumber: params["registrationNumber"],
        status: "INACTIVE",
        taxno: params["taxno"],
        companyRegistrationDate: params["companyRegistrationDate"],
        companyAccountNumber: params["companyAccountNumber"],
        bank_id: bank_id
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_company: _add_company
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Updated Company Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    # |>Ecto.Multi.run(:document, fn (_REPO_, %{add_company: add_company}) ->
    #     upload_documents(add_company, params["document"])
    #   end)
    |> Repo.transaction()
    |> case do
      {:ok,
       %{
         add_company: _add_company,
         user_logs: _user_logs
       }} ->
        conn
        |> put_flash(:info, "You Have Successfully Updated A Company ")
        |> redirect(to: Routes.client_management_path(conn, :employer_maintainence))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :employer_maintainence))
    end
  end

  # LoanmanagementsystemWeb.ClientManagementController.init_acc_no_generation("10")
  # LoanmanagementsystemWeb.ClientManagementController.reset_sequence()

  #################################### RUSSELL ##############################################
  def init_acc_no_generation(product_id) do
    "#{product_id |> String.pad_leading(2, "0")}#{sequence_no()}#{to_string(Timex.day(Timex.now())) |> String.pad_leading(3, "0")}"

    # "#{sequence_no()}#{Timex.now().year}#{to_string(Timex.day(Timex.now())) |> String.pad_leading(3, "0")}"
  end

  def sequence_no() do
    query = """
    SELECT nextval('GenSequenceNumber');
    """

    {:ok, %{columns: _columns, rows: rows}} = Loanmanagementsystem.Repo.query(query, [])
    rows |> List.flatten() |> List.first() |> to_string() |> String.pad_leading(8, "0")
  end

  def reset_sequence() do
    query = """
    ALTER SEQUENCE GenSequenceNumber RESTART WITH 1
    """

    {:ok, %{columns: _columns, rows: _rows}} = Repo.query(query, [])
  end

  def admin_create_merchant(conn, params) do
    IO.inspect(params, label: "Param print out")
    # otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_mobile_money_agent,
      Merchant.changeset(
        %Merchant{},
        %{
          companyName: params["companyName"],
          status: "INACTIVE",
          businessName: params["businessName"],
          merchantType: params["merchantType"],
          companyPhone: params["companyPhone"],
          registrationNumber: params["registrationNumber"],
          taxno: params["taxno"],
          contactEmail: params["contactEmail"],
          companyRegistrationDate: params["companyRegistrationDate"],
          companyAccountNumber: params["companyAccountNumber"],
          bankId: params["bankId"],
          businessNature: params["businessNature"],
          createdByUserId: conn.assigns.user.id
        }
      )
    )
    |> push_to_director_details(params)
    |> push_to_users(params)
    |> push_to_user_role(params)
    |> push_to_user_bio_data(params)
    # |> push_to_merchant_doc(conn, params)
    # |> push_to_device(params)
    # |> LoanmanagementsystemWeb.ClientManagementController.push_to_device(params)
    |> push_to_userlog(conn)
    |> Ecto.Multi.run(:merchants_document, fn _repo,
                                              %{
                                                user_logs: _user_logs
                                              } ->
      Loanmanagementsystem.Services.MerchantsUploads.merchant_document_upload(%{
        "process_documents" => params,
        "conn" => conn
      })
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_mobile_money_agent: add_mobile_money_agent}} ->
        LoanmanagementsystemWeb.ClientManagementController.push_to_device(params, %{
          "merchantId" => add_mobile_money_agent.id
        })

        conn
        |> put_flash(
          :info,
          "You have Successfully Created #{add_mobile_money_agent.companyName} AS Merchant"
        )
        |> redirect(to: Routes.client_management_path(conn, :merchant_maintenance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :merchant_maintenance))
    end
  end

  def admin_create_momo_agent(conn, params) do
    IO.inspect(params, label: "Param print out")
    # otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_mobile_money_agent,
      Merchant.changeset(
        %Merchant{},
        %{
          companyName: params["companyName"],
          status: "INACTIVE",
          businessName: params["businessName"],
          merchantType: params["merchantType"],
          companyPhone: params["companyPhone"],
          registrationNumber: params["registrationNumber"],
          taxno: params["taxno"],
          contactEmail: params["contactEmail"],
          companyRegistrationDate: params["companyRegistrationDate"],
          companyAccountNumber: params["companyAccountNumber"],
          bankId: params["bankId"],
          businessNature: params["businessNature"],
          createdByUserId: conn.assigns.user.id
        }
      )
    )
    |> push_to_director_details(params)
    |> push_to_users(params)
    |> push_to_user_role(params)
    |> push_to_user_bio_data(params)
    # |> push_to_merchant_doc(conn, params)
    # |> push_to_device(params)
    # |> LoanmanagementsystemWeb.ClientManagementController.push_to_device(params)
    |> push_to_userlog(conn)
    |> Ecto.Multi.run(:merchants_document, fn _repo,
                                              %{
                                                user_logs: _user_logs
                                              } ->
      Loanmanagementsystem.Services.MerchantsUploads.merchant_document_upload(%{
        "process_documents" => params,
        "conn" => conn
      })
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_mobile_money_agent: add_mobile_money_agent}} ->
        LoanmanagementsystemWeb.ClientManagementController.push_to_device(params, %{
          "merchantId" => add_mobile_money_agent.id
        })

        conn
        |> put_flash(
          :info,
          "You have Successfully Created #{add_mobile_money_agent.companyName} AS MOMO Agent"
        )
        |> redirect(to: Routes.client_management_path(conn, :mobile_money_argents))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :mobile_money_argents))
    end
  end

  def push_to_director_details(multi, params) do
    multi
    |> Ecto.Multi.run(:merchant_director, fn _repo,
     %{add_mobile_money_agent: add_mobile_money_agent} ->
      Merchant_director.changeset(%Merchant_director{}, %{
        firstName: params["dirFirstName"],
        lastName: params["dirLastName"],
        otherName: params["dirOtherName"],
        directorIdentificationnNumber: params["dirDirectorIdentificationnNumber"],
        directorIdType: params["dirDirectorIdType"],
        mobileNumber: params["dirMobileNumber"],
        emailAddress: params["dirEmailAddress"],
        status: "ACTIVE",
        merchantType: add_mobile_money_agent.merchantType,
        merchantId: add_mobile_money_agent.id,
        companyAccountNumber: params["companyAccountNumber"],
        businessNature: params["businessNature"]
      })
      |> Repo.insert()
    end)
  end

  # alias Loanmanagementsystem.Merchants.Merchants_document

  def push_to_userlog(multi, conn) do
    multi
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_mobile_money_agent: _add_mobile_money_agent} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Successfully added Mobile Money Agent",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)

    # |> Ecto.Multi.run(:merchants_document, fn _repo,
    #                                           %{
    #                                             user_logs: _user_logs
    #                                           } ->
    #   Loanmanagementsystem.Services.MerchantsUploads.merchant_document_upload(%{
    #     "process_documents" => params,
    #     "conn" => conn
    #   })
    # end)
    # |> Repo.insert()
    # |> case do
    #   {:ok, user_logs, user_logs} ->
    #     IO.inspect(user_logs)

    #   {:error, _failed_operation, failed_value, _changes_so_far} ->
    #     IO.inspect(failed_value)
    # end
  end

  def push_to_device(params, %{"merchantId" => merchantId}) do
    for x <- 0..(Enum.count(params["deviceAgentLine"]) - 1) do
      IO.inspect(">>>>>>++++++++++++++++++>>>>>>")
      IO.inspect(merchantId, label: "CHeck merchantId here")

      notifications = %{
        deviceType: params["deviceType"],
        deviceModel: params["deviceModel"],
        deviceAgentLine: Enum.at(params["deviceAgentLine"], x),
        deviceIMEI: Enum.at(params["deviceIMEI"], x),
        merchantId: merchantId,
        status: "ACTIVE"
      }

      Merchants_device.changeset(%Merchants_device{}, notifications)
      |> Repo.insert()
    end

    # agent_lines = Enum.with_index(params["deviceAgentLine"], 0)
    # agent_device = Enum.with_index(params["deviceIMEI"], 1)

    # Ecto.Multi.merge(multi, fn %{:add_mobile_money_agent => %{id: merchantId}} = _changes ->
    #   # Enum.reduce(agent_lines, Ecto.Multi.new(), fn {line, index}, multi ->
    #   Enum.reduce([agent_device, agent_lines], Ecto.Multi.new(), fn [
    #                                                                   %{
    #                                                                     agent_device:
    #                                                                       agent_device,
    #                                                                     agent_lines: agent_lines
    #                                                                   }
    #                                                                 ],
    #                                                                 multi ->
    #     IO.inspect(agent_device, label: "Line here")
    #     IO.inspect(agent_lines, label: "Lines  Lines Lines")

    #     params = %{
    #       deviceType: params["deviceType"],
    #       deviceModel: params["deviceModel"],
    #       # deviceAgentLine: line,
    #       deviceIMEI: agent_device,
    #       status: "ACTIVE",
    #       merchantId: merchantId
    #     }

    #     Ecto.Multi.insert(
    #       multi,
    #       {:agent_lines, :agent_device, agent_lines, agent_device},
    #       Merchants_device.changeset(%Merchants_device{}, params)
    #     )
    #   end)

    #   # end)
    # end)
  end

  def push_to_users(multi, params) do
    otp = to_string(Enum.random(1111..9999))

    multi
    |> Ecto.Multi.run(:add_user, fn _repo, %{add_mobile_money_agent: _add_mobile_money_agent} ->
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y",
        pin: otp
      })
      |> Repo.insert()
    end)
  end

  def push_to_user_role(multi, _params) do
    multi
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_mobile_money_agent: _add_mobile_money_agent,
                                           add_user: add_user
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: "Merchant",
        status: "INACTIVE",
        userId: add_user.id,
        otp: add_user.pin
      })
      |> Repo.insert()
    end)
  end

  def push_to_user_bio_data(multi, params) do
    multi
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                             %{
                                               add_mobile_money_agent: _add_mobile_money_agent,
                                               add_user: add_user
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
  end

  def client_relationship_manager_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Accounts.get_client_and_rm(search_params, start, length)
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

  def client_manager_item_lookup(conn, %{
        "userId" => userId
      }) do
    user_details = Loanmanagementsystem.Accounts.client_relationship_manager_lookup(userId)

    json(conn, %{"data" => List.wrap(user_details)})
  end

  def change_client_manager(conn, params) do


    IO.inspect(params, label: "CHeck Params here #####\n")
    client_account = Loanmanagementsystem.Accounts.get_customer_account!(params["id"])

    new_params =
      Map.merge(params, %{
        "loan_officer_id" => params["loan_officer_id"],
        "assignment_date" => params["assignment_date"]
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :client_account,
      Loanmanagementsystem.Accounts.Customer_account.changeset(client_account, new_params)
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{client_account: client_account} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "Client Transfered to CRM with User ID #{client_account.loan_officer_id} successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{client_account: _client_account}} ->
        json(conn, %{data: "Client Transfered successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
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


  ################################### RUSSELL ##############################################

  def individual_maintainence(conn, _request) do
    employee = Loanmanagementsystem.OperationsServices.get_individual_details()
    companies = Loanmanagementsystem.Companies.list_tbl_company()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    # doc = Loanmanagementsystem.OperationsServices.get_individual_docs()
    render(conn, "individual_maintainence.html", employee: employee, banks: banks, branches: branches, departments: departments, companies: companies)
  end

  def add_individual(conn, _request) do
    companies = Loanmanagementsystem.Companies.list_tbl_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "add_individual.html", companies: companies, departments: departments, banks: banks, town: town, province: province)
  end

  # import Plug.Upload
  # import Mime

  def parse_image(path) do
    path
    |> File.read!()
    |> Base.encode64()
  end

  def image_data_applicant_signature(params) do
    case Map.has_key?(params, "applicant_signature_image") do
      true -> %{filename: _img_name, path: _img_path} = params["applicant_signature_image"]
      false -> false
    end
  end


  def create_individual_user(conn, params) do
            # IO.inspect "YYyyyyyyyyyyyyyyyyyyYY"
            IO.inspect(params, label: "yyyyyyyyyyyyyyyyyyyyy")
            mail = params["emailAddress"]
            IO.inspect(params["company_name"], label: "Check check company_name ++++++++++")
            IO.inspect(params["business_name"], label: "Check check business_name ^^^^^^^^^^^")
            IO.inspect(params["name_of_market"], label: "Check check name_of_market ?????????")

            applicant_signature = image_data_applicant_signature(params)
            applicant_signature_encode_img = if applicant_signature != false  do parse_image(applicant_signature.path) else "" end
            bank_details = if params["bank_id"] == "" do nil else Loanmanagementsystem.Maintenance.get_bank!(params["bank_id"]) end
            # case Path.extname(params["file"]) do
            #   ext when ext in ~w(.pdf) ->
            #     IO.inspect("valid format")

            #   _ ->
            #     IO.inspect("invalid format")
            # end

        # if Enum.dedup(params["filename"]) != [""] do
            myemail = Repo.all(from m in UserBioData, where: m.emailAddress == ^mail)

              if Enum.count(myemail) == 0 do

                  password = "pass-#{Enum.random(1_000_000_000..9_999_999_999)}"
                  account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"

                  IO.inspect(params, label: "Param print out")
                  otp = to_string(Enum.random(1111..9999))

                  client_type = "INDIVIDUAL"
                  employment_type = params["employment_type"]

                  params = Map.put(params, "status", "INACTIVE")
                  params = Map.put(params, "password", password)
                  params = Map.put(params, "username", params["emailAddress"])
                  params = Map.put(params, "auto_password", "Y")
                  params = Map.put(params, "pin", otp)

                      Ecto.Multi.new()
                      |> Ecto.Multi.insert(:add_employer_user, User.changeset(%User{}, params))
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
                          bank_id: if params["bank_id"] == "" do nil else params["bank_id"] end,
                          bank_account_number: params["bank_account_number"],
                          marital_status: params["marital_status"],
                          nationality: "ZAMBIAN",
                          number_of_dependants: params["number_of_dependants"],
                          disability_status: params["disability_status"],
                          disability_detail: params["disability_detail"],
                          applicant_signature_image: applicant_signature_encode_img
                        })
                        |> Repo.insert()
                      end)

                      |> Ecto.Multi.run(:add_kin_data, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data} ->
                        Nextofkin.changeset(%Nextofkin{}, %{
                          applicant_nrc: params["meansOfIdentificationNumber"],
                          kin_ID_number: params["kin_ID_number"],
                          kin_first_name: params["kin_first_name"],
                          kin_gender: params["kin_gender"],
                          kin_last_name: params["kin_last_name"],
                          kin_mobile_number: params["kin_mobile_number"],
                          kin_other_name: params["kin_other_name"],
                          kin_personal_email: params["kin_personal_email"],
                          kin_relationship: params["kin_relationship"],
                          kin_status: "ACTIVE",
                          userID: add_employer_user.id,
                        })
                        |> Repo.insert()
                      end)

                      |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data} ->
                        UserRole.changeset(%UserRole{}, %{
                          roleType: "INDIVIDUALS",
                          status: "INACTIVE",
                          client_type: client_type,
                          userId: add_employer_user.id,
                          otp: otp
                        })
                        |> Repo.insert()
                      end)
                      |> Ecto.Multi.run(:add_client_company, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: add_user_role} ->
                        Client_company_details.changeset(%Client_company_details{},
                          if params["company_name"] == "" do
                                %{
                                  company_name: params["business_name"],
                                  company_account_number: params["company_account_number"],
                                  company_phone: params["company_phone"],
                                  company_registration_date: params["company_registration_date"],
                                  contact_email: params["contact_email"],
                                  registration_number: params["registration_number"],
                                  company_bank_name: params["company_bank_name"],
                                  company_account_name: params["company_account_name"],
                                  taxno: params["taxno"],
                                  bank_id: params["bank_id"],
                                  company_department: params["company_department"],
                                  status: "INACTIVE",
                                  createdByUserId: add_employer_user.id,
                                  createdByUserRoleId: add_user_role.id,
                                }
                          else
                            %{
                              company_name: params["company_name"],
                              company_account_number: params["company_account_number"],
                              company_phone: params["company_phone"],
                              company_registration_date: params["company_registration_date"],
                              contact_email: params["contact_email"],
                              registration_number: params["registration_number"],
                              company_bank_name: params["company_bank_name"],
                              company_account_name: params["company_account_name"],
                              taxno: params["taxno"],
                              bank_id: params["bank_id"],
                              company_department: params["company_department"],
                              status: "INACTIVE",
                              createdByUserId: add_employer_user.id,
                              createdByUserRoleId: add_user_role.id,
                            }

                          end
                        )
                        |> Repo.insert()
                      end)
                      |> Ecto.Multi.run(:add_employer_employee, fn _repo,%{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: add_user_role, add_client_company: add_client_company} ->
                        Employee.changeset(%Employee{}, %{
                          companyId: add_client_company.id,
                          employerId: add_client_company.id,
                          status: "INACTIVE",
                          userId: add_employer_user.id,
                          userRoleId: add_user_role.id,
                          loan_limit: nil
                        })
                        |> Repo.insert()
                      end)
                      |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee} ->
                        Address_Details.changeset(%Address_Details{}, %{

                          accomodation_status: params["rdio"],
                          area: params["area"],
                          house_number: params["house_number"],
                          street_name: params["street_name"],
                          town: params["town"],
                          province: params["province"],
                          userId: add_employer_user.id,
                          year_at_current_address: params["year_at_current_address"],
                          land_mark: params["land_mark"],

                        })
                        |> Repo.insert()
                      end)

                      |> Ecto.Multi.run(:add_employment_details, fn _repo,%{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details} ->
                        Employment_Details.changeset(%Employment_Details{}, %{
                          area: params["area"],
                          date_of_joining: params["date_of_joining"],
                          employee_number: params["employee_number"],
                          employement_type: params["employement_type"],
                          employer: add_client_company.company_name,
                          employer_industry_type: params["employer_industry_type"],
                          employer_office_building_name: params["employer_office_building_name"],
                          employer_officer_street_name: params["employer_officer_street_name"],
                          employment_type: employment_type,
                          hr_supervisor_email: params["hr_supervisor_email"],
                          hr_supervisor_mobile_number: params["hr_supervisor_mobile_number"],
                          hr_supervisor_name: params["hr_supervisor_name"],
                          job_title: params["job_title"],
                          occupation: params["occupation"],
                          province: params["province"],
                          town: params["town"],
                          userId: add_employer_user.id,
                          departmentId: params["departmentId"],
                        })
                        |> Repo.insert()
                      end)

                      |> Ecto.Multi.run(:add_Personal_details, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details} ->
                        Personal_Bank_Details.changeset(%Personal_Bank_Details{}, %{
                          accountName: params["accountName"],
                          accountNumber: params["bank_account_number"],
                          bankName: if bank_details == nil do "" else  bank_details.bankName end,
                          branchName: if bank_details == nil do "" else bank_details.process_branch end,
                          upload_bank_statement: nil,
                          bank_id: if bank_details == nil do "" else bank_details.id end,
                          mobile_number: params["mobileNumber"],
                          userId: add_employer_user.id
                        })
                        |> Repo.insert()
                      end)
                      |> Ecto.Multi.run(:customer_balance, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details} ->
                        customer_balance = %{
                          account_number: account_number,
                          user_id: add_employer_user.id
                        }
                        case Repo.insert(Customer_Balance.changeset(%Customer_Balance{}, customer_balance)) do
                          {:ok, message} -> {:ok, message}
                          {:error, response} -> {:error, response}
                        end
                      end)
                      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_employer_user: _add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details, customer_balance: _customer_balance} ->
                        UserLogs.changeset(%UserLogs{}, %{
                          activity: "#{conn.assigns.user.username} added an Individual client #{params["firstName"]}(#{params["meansOfIdentificationNumber"]}) Successfully",
                          user_id: conn.assigns.user.id
                        })
                        |> Repo.insert()
                      end)

                      |> Ecto.Multi.run(:client_document, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details, user_logs: _user_logs} ->
                        Loanmanagementsystem.Services.IndividualUploads.client_upload(%{"process_documents" => params, "conn" => conn, "individualId" => add_employer_user.id, "nrc" => add_user_bio_data.meansOfIdentificationNumber , "company_id"=> add_employer_user.company_id })
                      end)



                      |> Repo.transaction()
                      |> case do
                        {:ok, %{add_employer_user: _add_employer_user, add_user_bio_data: add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details, user_logs: _user_logs, client_document: _client_document}} ->
                          Email.send_email(params["emailAddress"], password, params["password"])
                            LoanmanagementsystemWeb.ClientManagementController.push_to_reference_table(params, %{
                              "customer_id" => add_user_bio_data.userId
                            })
                            if (params["name_of_market"] != "") do
                              LoanmanagementsystemWeb.ClientManagementController.push_to_Loan_market_info_table(params, %{
                                "customer_id" => add_user_bio_data.userId
                              })
                              IO.inspect(params, label: "push_to_Loan_market_info_table")
                            end

                          conn
                          |> put_flash(:info,"You have Successfully Created #{add_user_bio_data.firstName} #{add_user_bio_data.lastName} As An Individual")
                          |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))

                        {:error, _failed_operations, failed_value, _changes_so_far} ->
                          reason = traverse_errors(failed_value.errors)

                          conn
                          |> put_flash(:error, reason)
                          |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
                        end
                else
                  conn
                  |> put_flash(:error,"Another User with the email address #{mail} already exists.")
                  |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
                end

          # else
          #   conn
          #   |> put_flash(:error,"Kindly attach document(s) and Try again")
          #   |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
          # end

    end

    def push_to_Loan_market_info_table(params, %{"customer_id" => customer_id}) do

        markert_info = %{
          customer_id: customer_id,
          name_of_market: params["name_of_market"],
          location_of_market: params["location_of_market"],
          duration_at_market: params["duration_at_market"],
          type_of_business: params["type_of_business"],
          name_of_market_leader: params["name_of_market_leader"],
          mobile_of_market_leader: params["mobile_of_market_leader"],
          name_of_market_vice: params["name_of_market_vice"],
          mobile_of_market_vice: params["mobile_of_market_vice"],
          stand_number: params["stand_number"],
        }

        Loan_market_info.changeset(%Loan_market_info{}, markert_info)
        |> Repo.insert()
    end





    def push_to_reference_table(params, %{"customer_id" => customer_id}) do
        for x <- 0..(Enum.count(params["ref_full_name"]) - 1) do
          IO.inspect(">>>>>>++++++++++++++++++>>>>>>")
          IO.inspect(customer_id, label: "CHeck merchantId here")

          reference = %{
            name: Enum.at(params["ref_full_name"], x),
            contact_no: Enum.at(params["ref_full_phone_no"], x),
            status: "ACTIVE",
            customer_id: customer_id
          }

          Client_reference.changeset(%Client_reference{}, reference)
          |> Repo.insert()
        end
    end




    # LoanmanagementsystemWeb.ClientManagementController.testmail("mam000000qqqq090@gmail.com")
    def testmail(mail) do
      myemail = Repo.all(from m in UserBioData, where: m.emailAddress == ^mail)
      IO.inspect myemail
    end

  def view_individual_details(conn, %{"userid" => userid}) do
    employee = Loanmanagementsystem.OperationsServices.get_individual_docs(userid)
    getdetails = Loanmanagementsystem.OperationsServices.get_individual_details_by_id(userid)
    render(conn, "view_individual_doc.html", employee: employee, getdetails: getdetails)
  end

  def customer_360_view(conn, params) do
    userid = String.to_integer(params["userid"])
    current_user_details = Loanmanagementsystem.Accounts.get_details(userid)
    loan_details = Loan.get_loan_by_userId_individual360view_loan_tracking(userid)
    employee = Loanmanagementsystem.OperationsServices.get_individual_docs(userid)
    render(conn, "client_360_view.html", current_user_details: current_user_details, loan_details: loan_details, employee: employee)
  end



  def display_pdf(conn, %{"path" => path}), do: send_file( put_resp_header(conn, "content-type", "application/pdf"), 200, path)

  def create_reference(conn, params) do
    new_params = Map.merge(params, %{
      "status" => "ACTIVE",
      "customer_id" => params["userid"]
    })
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_reference, Client_reference.changeset(%Client_reference{}, new_params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_reference: _add_reference} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully created Client reference #{params["name"]}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Created Reference")
        |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
    end
  end

  def update_reference(conn, params) do
    reference_details = Accounts.get_client_reference!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:reference_details, Client_reference.changeset(reference_details, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{reference_details: _reference_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Updated reference for #{params["name"]}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated reference")
        |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
    end
  end



  def deactivate_client_document(conn, params) do

    Ecto.Multi.new()
    |> Ecto.Multi.update(:deactivate_client_doc, Client_Documents.changeset(Loanmanagementsystem.Accounts.get_client_details!(params["id"]), Map.merge(params, %{"status" => "DEACTIVE"})))


    |> Ecto.Multi.run(:user_logs, fn (_,%{deactivate_client_doc: _deactivate_client_doc}) ->

      UserLogs.changeset(%UserLogs{}, %{

        activity: "deactivated Client Document Successfully ",
        user_id: conn.assigns.user.id,
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Client document deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first
        json(conn, %{error: reason})
    end
  end

  def activate_client_document(conn, params) do

    Ecto.Multi.new()
    |> Ecto.Multi.update(:deactivate_client_doc, Client_Documents.changeset(Loanmanagementsystem.Accounts.get_client_details!(params["id"]), Map.merge(params, %{"status" => "ACTIVE"})))


    |> Ecto.Multi.run(:user_logs, fn (_,%{deactivate_client_doc: _deactivate_client_doc}) ->

      UserLogs.changeset(%UserLogs{}, %{

        activity: "Activated Client Document Successfully ",
        user_id: conn.assigns.user.id,
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Client document activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first
        json(conn, %{error: reason})
    end
  end

  def client_onboarding_upload(conn, _params) do
    render(conn, "client_bulkupload.html")
  end


  def employer_item_lookup(conn, %{"company_id" => company_id}) do
      Loanmanagementsystem.Companies.get_company_details(String.to_integer(company_id))
      |> case do
        nil -> json(conn, %{error: "Company not found!"})
        params ->
          json(conn, %{"data" => List.wrap(params)})
      end
  end


  @headers ~w/ title	firstName	lastName	otherName	gender	marital_status	dateOfBirth	idNumber	idType	mobileNumber	emailAddress	nationality	number_of_dependants	accomodation_status	year_at_current_address	area	house_number	street_name	town	province	land_mark	companyName	company_phone	company_registration_date	contact_email	registration_number	company_bank_name	company_account_name	employement_type	employer_industry_type	employer_office_building_name	employer_officer_street_name	hr_supervisor_email	hr_supervisor_mobile_number	hr_supervisor_name	occupation	kin_ID_number	kin_first_name	kin_last_name	kin_other_name	kin_gender	kin_mobile_number	kin_personal_email	kin_relationship	accountName	accountNumber	bankName	branchName	loan_limit	with_mou	roleType  /a

  def handle_client_bulk_upload(conn, params) do
    user = conn.assigns.user
    {key, msg, _invalid} = handle_file_upload(user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
    end
  end

  defp handle_file_upload(user, params) do
    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
      user
      |> process_bulk_upload(filename, destin_path)
      |> case do
        {:ok, {invalid, _valid}} ->
          {:info, "Clients Uploaded Successful ", invalid}

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
    |> Repo.transaction(timeout: :infinity)
    |> case do
      {:ok, multi_records} ->
        {invalid, valid} =
          multi_records
          |> Map.values()
          |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->
            case item do
              %{uploafile_name: _src} -> {invalid, valid + 1}
              %{col_index: _index} -> {invalid + 1, valid}
              _ -> {invalid, valid}
            end
          end)

        {:ok, {invalid, valid}}

      {:error, _, changeset, _} ->
        reason = traverse_errors(changeset.errors) |> Enum.join("\r\n")
        {:error, reason}

      {:error, reason} ->
          {:error, reason}
    end
  end

  defp prepare_bulk_params(user, filename, items) do
    # validate_email = items |> Enum.map(fn records -> if UserBioData.exists?(emailAddress: records.emailAddress) == true do  "EXIST" else "PROCEED" end end)
    # validate_idNumber = items |> Enum.map(fn records -> if UserBioData.exists?(meansOfIdentificationNumber: records.idNumber) == true do "EXIST" else "PROCEED" end end)
    # validate_mobileNumber = items |> Enum.map(fn records -> if UserBioData.exists?(mobileNumber: records.mobileNumber) == true do "EXIST" else "PROCEED" end end)
    # case  Enum.member?(validate_email, "EXIST") do
    #   false ->
    #  case  Enum.member?(validate_idNumber, "EXIST") do
    #   false ->
    #  case  Enum.member?(validate_mobileNumber, "EXIST") do
    #   false ->
      Ecto.Multi.new()
      |> Ecto.Multi.run(:upload_entries, fn _repo, _changes_so_far ->
         user
         |> prepare_user_bulk_params(filename, items)
         |> prepare_address_detail_bulk_params(user, filename, items)
         |> prepare_userbio_bulk_params(user, filename, items)
         |> prepare_userrole_bulk_params(user, filename, items)
         |> prepare_Client_company_details_bulk_params(user, filename, items)
         |> prepare_customer_account_bulk_params(user, filename, items)
         |> prepare_employee_bulk_params(user, filename, items)
         |> prepare_employment_details_bulk_params(user, filename, items)
         |> prepare_nextofkin_bulk_params(user, filename, items)
         |> prepare_Personal_Bank_Details_bulk_params(user, filename, items)
         |> prepare_logs_bulk_params(user, filename, items)
          |> case do
            nil ->
              {:ok, "UPLOAD COMPLETE"}
            error ->
              error
          end
      end)
      # true ->
      #   {:error, "emailAddress already exists!"}
      #   Ecto.Multi.new()
      # end
      # true ->
      #   {:error, "emailAddress already exists!"}
      #   Ecto.Multi.new()
      # end
      # true ->
      # {:error, "emailAddress already exists!"}
      # Ecto.Multi.new()

      # end
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

  defp prepare_userbio_bulk_params(user_bio_resp, _user, _ , _) when not is_nil(user_bio_resp), do: user_bio_resp
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

  defp prepare_address_detail_bulk_params(address_resp, _user, _, _) when not is_nil(address_resp), do: address_resp
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

  defp prepare_userrole_bulk_params(role_resp, _user, _, _) when not is_nil(role_resp), do: role_resp
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

  defp prepare_customer_account_bulk_params(acc_resp, _user, _, _) when not is_nil(acc_resp), do: acc_resp
  defp prepare_customer_account_bulk_params(_acc_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->

      customer_account_params = prepare_customer_account_params(item, user)
      changeset_customer_acc = Customer_account.changeset(%Customer_account{}, customer_account_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_customer_acc)

    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp prepare_employee_bulk_params(emplo_resp, _user, _, _) when not is_nil(emplo_resp), do: emplo_resp
  defp prepare_employee_bulk_params(_emplo_resp, user, _filename, items) do
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

  defp prepare_employment_details_bulk_params(emplo_details_resp, _user, _, _) when not is_nil(emplo_details_resp), do: emplo_details_resp
  defp prepare_employment_details_bulk_params(_emplo_details_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      maintenance_params = prepare_employment_details_params(item, user)
      maintenance_employee = Employment_Details.changeset(%Employment_Details{}, maintenance_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)

    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end


  defp prepare_nextofkin_bulk_params(nextofkin_resp, _user, _, _) when not is_nil(nextofkin_resp), do: nextofkin_resp
  defp prepare_nextofkin_bulk_params(_nextofkin_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      maintenance_params = prepare_nextofkin_params(item, user)
      maintenance_employee = Nextofkin.changeset(%Nextofkin{}, maintenance_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)

    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp prepare_Client_company_details_bulk_params(client_comp_resp, _user, _, _) when not is_nil(client_comp_resp), do: client_comp_resp
  defp prepare_Client_company_details_bulk_params(_client_comp_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      maintenance_params = prepare_Client_company_details_params(item, user)
      maintenance_employee = Client_company_details.changeset(%Client_company_details{}, maintenance_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)

    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp prepare_Personal_Bank_Details_bulk_params(bank_details_resp, _user, _, _) when not is_nil(bank_details_resp), do: bank_details_resp
  defp prepare_Personal_Bank_Details_bulk_params(_bank_details_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      maintenance_params = prepare_Personal_Bank_Details_params(item, user)
      maintenance_employee = Personal_Bank_Details.changeset(%Personal_Bank_Details{}, maintenance_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp prepare_logs_bulk_params(logs_resp, _user, _, _) when not is_nil(logs_resp), do: logs_resp
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
      marital_status: item.marital_status,
      nationality: item.nationality,
      number_of_dependants: if  item.number_of_dependants == "" do 0 else String.to_integer(item.number_of_dependants) end,
      # age: item.age,
    }
  end

  defp prepare_address_details_params(item, _user) do
    IO.inspect item.firstName, label: "item., ---#{item.lastName}---------------------"
    %{
      accomodation_status: item.accomodation_status,
      year_at_current_address: if item.year_at_current_address == "" do 0 else String.to_integer(item.year_at_current_address) end,
      area: item.area,
      house_number: item.house_number,
      street_name: item.street_name,
      town: item.town,
      userId: User.find_by(username: item.mobileNumber).id,
      province: item.province,
      land_mark: item.land_mark
    }
  end

  defp prepare_userrole_params(item, _user, otp) do
    %{
      roleType: String.upcase(item.roleType),
      status: "INACTIVE",
      userId: User.find_by(username: item.mobileNumber).id,
      otp: otp,
      isStaff: false,
      client_type: String.upcase(item.roleType),
    }
  end

  defp prepare_user_params(item, _user, otp) do
    mou = if  String.upcase(item.with_mou) == "YES" do true else false end
    %{
      password: "Password123",
      status: "INACTIVE",
      username: item.mobileNumber,
      pin: otp,
      #company_id: if item.companyName == "" do nil else Company.find_by(companyName: item.companyName).id end,
      auto_password: "Y",
      with_mou: mou
    }
  end

  defp prepare_customer_account_params(item, _user) do
    %{
      account_number: "accno-#{Enum.random(1_000_000_000..9_999_999_999)}",
      user_id: User.find_by(username: item.mobileNumber).id,
      status: "INACTIVE"
    }
  end

  defp prepare_employee_params(item, _user) do
    %{
      status: "INACTIVE",
      userId: User.find_by(username: item.mobileNumber).id,
      userRoleId: UserRole.find_by(userId: User.find_by(username: item.mobileNumber).id).id,
      loan_limit: Decimal.new(item.loan_limit),
      # companyId: if item.companyName == "" do nil else Company.find_by(companyName: item.companyName).id end,
      # employerId: if item.companyName == "" do nil else Company.find_by(companyName: item.companyName).id end,
    }
  end

  defp prepare_employment_details_params(item, _user) do
    %{
      area: item.area,
      # date_of_joining: item.date_of_joining,
      employee_number: item.mobileNumber,
      employement_type: item.employement_type,
      employer: String.upcase(item.companyName),
      employer_industry_type: item.employer_industry_type,
      employer_office_building_name: item.employer_office_building_name,
      employer_officer_street_name: item.employer_officer_street_name,
      hr_supervisor_email: item.hr_supervisor_email,
      hr_supervisor_mobile_number: item.hr_supervisor_mobile_number,
      hr_supervisor_name: item.hr_supervisor_name,
      # job_title: item.job_title,
      occupation: item.occupation,
      province: item.province,
      town: item.town,
      userId: User.find_by(username: item.mobileNumber).id,
    }
  end

  defp prepare_nextofkin_params(item, _user) do
    %{
      applicant_nrc: item.idNumber,
      kin_ID_number: item.kin_ID_number,
      kin_first_name: item.kin_first_name,
      kin_gender: item.kin_gender,
      kin_last_name: item.kin_last_name,
      kin_mobile_number: item.kin_mobile_number,
      kin_other_name: item.kin_other_name,
      kin_personal_email: item.kin_personal_email,
      kin_relationship: item.kin_relationship,
      kin_status: "ACTIVE",
      userID: User.find_by(username: item.mobileNumber).id,
    }
  end

  defp prepare_Client_company_details_params(item, _user) do
    %{
      company_name: String.upcase(item.companyName),
      company_phone: item.company_phone,
      company_registration_date: item.company_registration_date,
      contact_email: item.contact_email,
      registration_number: item.registration_number,
      company_bank_name: item.company_bank_name,
      company_account_name: item.company_account_name,
      # taxno: item.taxno,
      status: "INACTIVE",
      createdByUserId: User.find_by(username: item.mobileNumber).id,
      createdByUserRoleId: UserRole.find_by(userId: User.find_by(username: item.mobileNumber).id).id,
    }
  end

  defp prepare_Personal_Bank_Details_params(item, _user) do
    %{
      accountName: item.accountName,
      accountNumber: item.accountNumber,
      bankName: item.bankName,
      branchName: item.branchName,
      mobile_number: item.mobileNumber,
      userId: User.find_by(username: item.mobileNumber).id,
    }
  end

  defp prepare_user_logs_params(item, user) do
    %{
      activity: "You have Successfully Added #{item.firstName} #{item.lastName} has a client",
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
    destin_path = "C:/clientonboarding/file" |> default_dir()
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
