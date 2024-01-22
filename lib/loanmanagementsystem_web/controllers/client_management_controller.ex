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
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.Nextofkin
  alias Loanmanagementsystem.Notifications.Sms
  # alias Loanmanagementsystem.Accounts.Client_Documents
  alias Loanmanagementsystem.Employment.Income_Details
  # alias Loanmanagementsystem.OperationsServices
  alias Loanmanagementsystem.Accounts.Customer_account
  alias Loanmanagementsystem.Companies.Employee
  alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Companies.Client_company_details
  alias Loanmanagementsystem.Employment.Personal_Bank_Details
  require Logger
  require Xlsxir


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
        :add_individual_client,
        :client_onboarding_upload,
        :handle_client_bulk_upload,
        :validate_records_then_process
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

  def add_individual_client(conn, _request) do
    companies = Loanmanagementsystem.Companies.list_all_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "add_individual_client.html", companies: companies, departments: departments, banks: banks, town: town, province: province)
  end

  def edit_individual(conn, %{"userid" => userid}) do
    employee = Loanmanagementsystem.OperationsServices.get_client_individual_details(userid)
    companies = Loanmanagementsystem.Companies.list_tbl_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "edit_individual.html", companies: companies, departments: departments, banks: banks, employee: employee)
  end

  def create_client_user(conn, params) do

    client_employer = try do Loanmanagementsystem.Companies.Company.find_by(id: params["company_id"]).companyName rescue _-> "" end
    username = params["emailAddress"]
    get_username = Repo.get_by(User, username: username)
    generate_otp = to_string(Enum.random(1111..9999))

    user_identification_no = params["meansOfIdentificationNumber"]
    user_mobile_line = params["mobileNumber"]
    get_user_mobile_line = Repo.get_by(UserBioData, mobileNumber: user_mobile_line)
    get_user_identification_no = Repo.get_by(UserBioData, meansOfIdentificationNumber: user_identification_no)
      case is_nil(get_user_identification_no) do
        true ->
            case is_nil(get_username) do
              true ->
                case is_nil(get_user_mobile_line) do
                  true ->

                        IO.inspect(params, label: "QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ")
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


                          Ecto.Multi.new()
                          |> Ecto.Multi.insert(
                            :add_employer_user,
                            User.changeset(%User{}, %{
                              password: password,
                              status: "INACTIVE",
                              username: params["emailAddress"],
                              auto_password: "Y",
                              company_id: if is_integer(params["company_id"]) do params["company_id"] else String.to_integer(params["company_id"]) end,
                              pin: otp
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
                              applicant_signature_image: params["applicant_signature_image"]
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
                              companyId: if is_integer(params["company_id"]) do params["company_id"] else String.to_integer(params["company_id"]) end,
                              employerId: if is_integer(params["company_id"]) do params["company_id"] else String.to_integer(params["company_id"]) end,
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
                              employer: client_employer,
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
                              contract_end_date: params["contract_end_date"],
                              company_id: if is_integer(params["company_id"]) do params["company_id"] else String.to_integer(params["company_id"]) end,

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

                          |> Ecto.Multi.run(:client_document, fn _repo, %{add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: add_employer_user,add_user_bio_data: add_user_bio_data } ->
                            Loanmanagementsystem.Services.ClientUploads.client_upload(%{ "process_documents" => params, "conn" => conn, "company_id" => String.to_integer(params["company_id"]), "individualId" => add_employer_user.id, "nrc" => add_user_bio_data.meansOfIdentificationNumber })
                          end)

                          |> Ecto.Multi.run(:user_logs, fn _repo, %{add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: _add_employer_user,add_user_bio_data: _add_user_bio_data, client_document: _client_document} ->
                            UserLogs.changeset(%UserLogs{}, %{
                              activity: "Added User Successfully",
                              user_id: conn.assigns.user.id
                            })
                            |> Repo.insert()
                          end)

                          |> Ecto.Multi.run(:sms, fn _, %{add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: _add_employer_user,add_user_bio_data: add_user_bio_data, client_document: _client_document} ->
                            sms = %{
                              mobile: add_user_bio_data.mobileNumber,
                              msg:
                              "Dear #{params["firstName"]}, Your Login Credentials. username: #{params["emailAddress"]}, password: #{params["password"]}, OTP: #{generate_otp}",
                              status: "READY",
                              type: "SMS",
                              msg_count: "1"
                            }

                            Sms.changeset(%Sms{}, sms)
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
                    _ ->
                      conn
                      |> put_flash(:error, "User with phone number #{user_mobile_line} Already Exists")
                      |> redirect(to: Routes.client_management_path(conn, :client_maintainence))
                  end

                _ ->
                  conn
                  |> put_flash(:error, "User with email address #{username} Already Exists")
                  |> redirect(to: Routes.client_management_path(conn, :client_maintainence))
            end

          _ ->
            conn
            |> put_flash(:error, "User with ID number #{user_identification_no} Already Exists")
            |> redirect(to: Routes.client_management_path(conn, :client_maintainence))
      end


  end


  def edit_client_employee(conn, params) do
    IO.inspect(params["id"], label: "ppppppppppppppppppppppppppppppppppppppppppppppp")

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

        company_id: params["company_id"]

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

    IO.inspect(params, label: "params here *********")
    userbiodate = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["user_id"])

    employment_details =Loanmanagementsystem.Employment.get_employment__details_by_userId(params["user_id"])

    personal_bank_details = Loanmanagementsystem.Employment.get_personal__bank__details_by_userId(params["user_id"])

    employee = Loanmanagementsystem.Companies.get_employee_by_userId(params["user_id"])

    client_company = Loanmanagementsystem.Companies.get_client_company_details_by_user_id!(params["user_id"])

    address_details = Loanmanagementsystem.Accounts.get_address__details_by_userId(params["user_id"])

    update_companyId = Loanmanagementsystem.Accounts.get_user!(params["user_id"])

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

        company_id: params["company_id"],
        username: params["emailAddress"]

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
        year_at_current_address: params["year_at_current_address"]
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
    IO.inspect "TRYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"
    IO.inspect employee
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

  def create_individual_user(conn, params) do
    IO.inspect "YYyyyyyyyyyyyyyyyyyyYY"
    IO.inspect params
    mail = params["emailAddress"]

    myemail = Repo.all(from m in UserBioData, where: m.emailAddress == ^mail)

    if Enum.count(myemail) == 0 do

        password = "pass-#{Enum.random(1_000_000_000..9_999_999_999)}"

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
                bank_id: params["bank_id"],
                bank_account_number: params["bank_account_number"],
                marital_status: params["marital_status"],
                nationality: "ZAMBIAN",
                number_of_dependants: params["number_of_dependants"],
                disability_status: params["disability_status"],
                disability_detail: params["disability_detail"]
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
              Client_company_details.changeset(%Client_company_details{}, %{
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
              })
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
                year_at_current_address: params["year_at_current_address"]

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
                bankName: params["bankName"],
                branchName: params["branchName"],
                upload_bank_statement: nil,
                userId: add_employer_user.id
              })
              |> Repo.insert()
            end)
            |> Ecto.Multi.run(:user_logs, fn _repo, %{add_employer_user: _add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details} ->
              UserLogs.changeset(%UserLogs{}, %{
                activity: "#{conn.assigns.user.username} added an Individual client #{params["firstName"]}(#{params["meansOfIdentificationNumber"]}) Successfully",
                user_id: conn.assigns.user.id
              })
              |> Repo.insert()
            end)

            |> Ecto.Multi.run(:push_to_income, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details, user_logs: _user_logs}  ->
              Income_Details.changeset(%Income_Details{}, %{
                  pay_day: params["pay_day"],
                  gross_pay: params["gross_pay"],
                  total_deductions: params["total_deductions"],
                  net_pay: params["net_pay"],
                  total_expenses: "0.0",
                  upload_payslip: params["upload_payslip"],
                  userId: add_employer_user.id,

              })
              |> Repo.insert()
            end)
            |> Ecto.Multi.run(:client_document, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details, user_logs: _user_logs, push_to_income: _push_to_income} ->
              Loanmanagementsystem.Services.IndividualUploads.client_upload(%{"process_documents" => params, "conn" => conn, "individualId" => add_employer_user.id, "nrc" => add_user_bio_data.meansOfIdentificationNumber })
            end)

            |> Repo.transaction()
            |> case do
              {:ok, %{add_employer_user: _add_employer_user, add_user_bio_data: add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details, user_logs: _user_logs, client_document: _client_document, push_to_income: _push_to_income}} ->
                Email.send_email(params["emailAddress"], password, params["password"])
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

  def display_pdf(conn, %{"path" => path}), do: send_file( put_resp_header(conn, "content-type", "application/pdf"), 200, path)

  def client_onboarding_upload(conn, _request) do
    render(conn, "client_bulkupload.html")
  end






  # @headers ~w/ title	firstName	lastName	otherName	gender	marital_status	dateOfBirth	idNumber	idType	mobileNumber	emailAddress	nationality	number_of_dependants	accomodation_status	year_at_current_address	area	house_number	street_name	town	province	land_mark	companyName	company_phone	company_registration_date	contact_email	registration_number	company_bank_name	company_account_name	employement_type	employer_industry_type	employer_office_building_name	employer_officer_street_name	hr_supervisor_email	hr_supervisor_mobile_number	hr_supervisor_name	occupation	kin_ID_number	kin_first_name	kin_last_name	kin_other_name	kin_gender	kin_mobile_number	kin_personal_email	kin_relationship	accountName	accountNumber	bankName	branchName	loan_limit	roleType  /a
  @headers ~w/ title firstName	lastName otherName gender marital_status dateOfBirth idType	idNumber mobileNumber emailAddress	nationality	number_of_dependants accomodation_status year_at_current_address area house_number street_name town	province land_mark companyName company_phone company_registration_date	contact_email registration_number company_bank_name	company_account_name employement_type employer_industry_type employer_office_building_name	employer_officer_street_name hr_supervisor_email hr_supervisor_mobile_number hr_supervisor_name	occupation	kin_ID_number kin_first_name kin_last_name	kin_other_name	kin_gender	kin_mobile_number	kin_personal_email	kin_relationship accountName accountNumber	bankName branchName	loan_limit	with_mou roleType pay_day gross_pay total_deductions net_pay total_expenses	/a

  @headers_list  ["title", "firstName", "lastName", "otherName", "gender", "marital_status",
                  "dateOfBirth", "idType", "idNumber", "mobileNumber", "emailAddress",
                  "nationality", "number_of_dependants", "accomodation_status",
                  "year_at_current_address", "area", "house_number", "street_name", "town",
                  "province", "land_mark", "companyName", "company_phone",
                  "company_registration_date", "contact_email", "registration_number",
                  "company_bank_name", "company_account_name", "employement_type",
                  "employer_industry_type", "employer_office_building_name",
                  "employer_officer_street_name", "hr_supervisor_email",
                  "hr_supervisor_mobile_number", "hr_supervisor_name", "occupation",
                  "kin_ID_number", "kin_first_name", "kin_last_name", "kin_other_name",
                  "kin_gender", "kin_mobile_number", "kin_personal_email", "kin_relationship",
                  "accountName", "accountNumber", "bankName", "branchName", "loan_limit",
                  "with_mou", "roleType", "pay_day", "gross_pay", "total_deductions", "net_pay",
                  "total_expenses"]

  def handle_client_bulk_upload(conn, params) do
    user = conn.assigns.user
    # {key, msg, _invalid} = handle_client_file_upload(user, params)
    {key, msg, _invalid} = validate_records_then_process(conn, user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.client_management_path(conn, :client_onboarding_upload))
    end
  end

  defp handle_client_file_upload(user, params) do
    IO.inspect(params, label: "check header inspections")
    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do

      user
      |> process_client_bulk_upload(filename, destin_path)
      |> case do
        {:ok, {invalid, _valid}} ->
          {:info, "Clients Uploaded Successful ", invalid}
          # {:info, "#{valid} Successful entrie(s) and #{invalid} invalid entrie(s)", valid}

        {:error, reason} ->
          {:error, reason, 0}
      end
    else
      {:error, reason} ->
        {:error, reason, 0}
    end
  end

  # def process_client_bulk_upload(user, filename, path) do
  #   {:ok, items} = extract_xlsx(path)
  #   prepare_client_bulk_params(user, filename, items)
  #   |> Repo.transaction(timeout: :infinity)
  #   |> case do
  #     {:ok, multi_records} ->
  #       {invalid, valid} =
  #         multi_records
  #         |> Map.values()
  #         |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->
  #           case item do
  #             %{uploafile_name: _src} -> {invalid, valid + 1}
  #             %{col_index: _index} -> {invalid + 1, valid}
  #             _ -> {invalid, valid}
  #           end
  #         end)

  #       {:ok, {invalid, valid}}

  #     {:error, _, changeset, _} ->
  #       reason = traverse_errors(changeset.errors) |> Enum.join("\r\n")
  #       {:error, reason}

  #     {:error, reason} ->
  #         {:error, reason}
  #   end
  # end

  # def process_client_bulk_upload(user, filename, path) do

  #     {:ok, items} = parse_file(filename, path)
  #     filename = Path.rootname(filename) |> Path.basename()

  #     # user
  #     prepare_client_bulk_params(user, filename, items)
  #     |> Repo.transaction(timeout: :infinity)
  #     |> case do
  #       {:ok, multi_records} ->
  #         handle_suc_upload_resp(multi_records)

  #         {:error, reason} ->
  #           {:error, reason, 0}
  #     end
  # end


  def process_client_bulk_upload(user, filename, path) do
    {:ok, items} = extract_xlsx(path)
    prepare_client_bulk_params(user, filename, items)
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

  defp parse_file(file, path) do
    case Path.extname(file) do
      ext when ext in ~w(.xlsx .XLSX .xls .XLS) ->
        extract_xlsx(path)

      _ ->
        extract_csv(path)
    end
  end

  def prepare_error_log(changeset, filename) do
    errors = Enum.join(traverse_errors(changeset.errors), "\r\n")
    IO.inspect(" Hello Master Teddy")

    item =
      changeset.params
      |> Map.to_list()
      |> Enum.map(fn {k, v} -> "#{k}: #{strgfy_value(v)}" end)
      |> Enum.join(" | ")

    error_dir = errors_path() |> Path.absname()
    content = "\r\nSTUDENT DETAILS\r\nSUBMITTED DATA ==>\t#{item}\r\nERRORS\r\n#{errors}"

    File.write!("#{error_dir}/#{filename}.txt", content, [:append])
  end

  def extract_csv(path) do
    path
    |> File.stream!()
    |> CSV.decode!()
    |> Stream.drop(1)
    |> Stream.reject(&(Enum.join(&1) == ""))
    |> Stream.map(&Enum.into(Stream.zip(@headers, &1), %{}))
    |> Enum.reject(
      &(&1.firstName == "" or &1.firstName == nil)
    )
    |> (&{:ok, Enum.to_list(&1)}).()
  end

  defp strgfy_value(val) do
    case is_binary(val) do
      true -> val
      false -> inspect(val)
    end
  end

  def errors_path do
    # dir = Repo.one(SystemDirectory)
    # (dir && dir.errors) || "/root/pangea/errors" |> default_dir()
    "F:/Pangaea docs/errors" |> default_dir()


  end

  defp prepare_client_bulk_params(user, filename, items) do
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
          |> prepare_client_user_bulk_params(filename, items)
          |> prepare_client_userbio_bulk_params(user, filename, items)
          |> prepare_client_address_detail_bulk_params(user, filename, items)
          |> prepare_client_userrole_bulk_params(user, filename, items)
          |> prepare_Client_company_details_bulk_params(user, filename, items)
          |> prepare_client_customer_account_bulk_params(user, filename, items)
          |> prepare_client_employee_bulk_params(user, filename, items)
          |> prepare_client_employment_details_bulk_params(user, filename, items)
          |> prepare_client_nextofkin_bulk_params(user, filename, items)
          |> prepare_client_Personal_Bank_Details_bulk_params(user, filename, items)
          |> prepare_client_logs_bulk_params(user, filename, items)
          |> prepare_client_income_Details_bulk_params(user, filename, items)
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



  defp prepare_client_userbio_bulk_params(user_bio_resp, _user, _ , _) when not is_nil(user_bio_resp), do: user_bio_resp
  defp prepare_client_userbio_bulk_params(_user_bio_resp, user, _filename, items) do
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

  defp prepare_client_address_detail_bulk_params(address_resp, _user, _, _) when not is_nil(address_resp), do: address_resp
  defp prepare_client_address_detail_bulk_params(_address_resp, user, _filename, items) do
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

  defp prepare_client_userrole_bulk_params(role_resp, _user, _, _) when not is_nil(role_resp), do: role_resp
  defp prepare_client_userrole_bulk_params(_role_resp, user, _filename, items) do
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

  defp prepare_client_user_bulk_params(user, _filename, items) do
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

  defp prepare_client_customer_account_bulk_params(acc_resp, _user, _, _) when not is_nil(acc_resp), do: acc_resp
  defp prepare_client_customer_account_bulk_params(_acc_resp, user, _filename, items) do
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

  defp prepare_client_employee_bulk_params(emplo_resp, _user, _, _) when not is_nil(emplo_resp), do: emplo_resp
  defp prepare_client_employee_bulk_params(_emplo_resp, user, _filename, items) do
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

  defp prepare_client_employment_details_bulk_params(emplo_details_resp, _user, _, _) when not is_nil(emplo_details_resp), do: emplo_details_resp
  defp prepare_client_employment_details_bulk_params(_emplo_details_resp, user, _filename, items) do
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


  defp prepare_client_nextofkin_bulk_params(nextofkin_resp, _user, _, _) when not is_nil(nextofkin_resp), do: nextofkin_resp
  defp prepare_client_nextofkin_bulk_params(_nextofkin_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      maintenance_params = prepare_client_nextofkin_params(item, user)
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

  defp prepare_client_Personal_Bank_Details_bulk_params(bank_details_resp, _user, _, _) when not is_nil(bank_details_resp), do: bank_details_resp
  defp prepare_client_Personal_Bank_Details_bulk_params(_bank_details_resp, user, _filename, items) do
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

  defp prepare_client_logs_bulk_params(logs_resp, _user, _, _) when not is_nil(logs_resp), do: logs_resp
  defp prepare_client_logs_bulk_params(_logs_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      user_logs_params = prepare_client_user_logs_params(item, user)
      changeset_userlogs = UserLogs.changeset(%UserLogs{}, user_logs_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_userlogs)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp prepare_client_income_Details_bulk_params(bank_details_resp, _user, _, _) when not is_nil(bank_details_resp), do: bank_details_resp
  defp prepare_client_income_Details_bulk_params(_bank_details_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      maintenance_params = prepare_client_income_Details_params(item, user)
      maintenance_employee = Income_Details.changeset(%Income_Details{}, maintenance_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)
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
      mobileNumber: String.replace(item.mobileNumber, ~r"[a-z /]", ""),
      otherName: item.otherName,
      title: item.title,
      userId: User.find_by(username: item.emailAddress).id,
      marital_status: item.marital_status,
      nationality: item.nationality,
      number_of_dependants: if  item.number_of_dependants == "" do 0 else String.to_integer(item.number_of_dependants) end,
      # age: item.age,
    }
  end

  defp prepare_address_details_params(item, _user) do
    IO.inspect item.year_at_current_address, label: "item.year_at_current_address, ---#{item.lastName}---------------------"
    IO.inspect(item.year_at_current_address, label: "CHeck here")

    %{
      accomodation_status: item.accomodation_status,
      year_at_current_address: if item.year_at_current_address == "" do 0 else String.to_integer(item.year_at_current_address) end,
      area: item.area,
      house_number: item.house_number,
      street_name: item.street_name,
      town: item.town,
      userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
      province: item.province,
    }
  end

  defp prepare_userrole_params(item, _user, otp) do
    %{
      roleType: if (String.upcase(item.roleType) == "INDIVIDUAL") do "INDIVIDUALS" else "INDIVIDUALS" end,
      status: "ACTIVE",
      userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
      otp: otp,
      isStaff: false,
      client_type: if (String.upcase(item.roleType) == "INDIVIDUAL") do "INDIVIDUALS" else "INDIVIDUALS" end,
    }
  end

  defp prepare_user_params(item, _user, otp) do
    # mou = if  String.upcase(item.with_mou) == "YES" do true else false end
    %{
      password: "Password123",
      status: "ACTIVE",
      username: item.emailAddress,
      pin: otp,
      #company_id: if item.companyName == "" do nil else Company.find_by(companyName: item.companyName).id end,
      auto_password: "Y",
      # with_mou: mou
    }
  end

  defp prepare_customer_account_params(item, _user) do
    %{
      account_number: "accno-#{Enum.random(1_000_000_000..9_999_999_999)}",
      user_id: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
      status: "INACTIVE"
    }
  end

  defp prepare_employee_params(item, _user) do
    %{
      status: "INACTIVE",
      userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
      userRoleId: UserRole.find_by(userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId).id,
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
      userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
    }
  end

  defp prepare_client_nextofkin_params(item, _user) do
    %{
      applicant_nrc: item.idNumber,
      kin_ID_number: item.kin_ID_number,
      kin_first_name: item.kin_first_name,
      kin_gender: item.kin_gender,
      kin_last_name: item.kin_last_name,
      kin_mobile_number: String.replace(item.kin_mobile_number, ~r"[a-z /]", ""),
      kin_other_name: item.kin_other_name,
      kin_personal_email: item.kin_personal_email,
      kin_relationship: item.kin_relationship,
      kin_status: "ACTIVE",
      userID: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
    }
  end

  defp prepare_Client_company_details_params(item, _user) do
    %{
      company_name: String.upcase(item.companyName),
      company_phone: String.replace(item.company_phone, ~r"[a-z /]", ""),
      company_registration_date: item.company_registration_date,
      contact_email: item.contact_email,
      registration_number: item.registration_number,
      company_bank_name: item.company_bank_name,
      company_account_name: item.company_account_name,
      # taxno: item.taxno,
      status: "INACTIVE",
      createdByUserId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
      createdByUserRoleId: UserRole.find_by(userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId).id,
    }
  end

  defp prepare_Personal_Bank_Details_params(item, _user) do
    %{
      accountName: item.accountName,
      accountNumber: item.accountNumber,
      bankName: item.bankName,
      branchName: item.branchName,
      mobile_number: item.mobileNumber,
      userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
    }
  end

  defp prepare_client_user_logs_params(item, user) do
    %{
      activity: "You have Successfully Added #{item.firstName} #{item.lastName} has a client",
      user_id: user.id
    }
  end

  defp prepare_client_income_Details_params(item, user) do
    %{
          pay_day: item.pay_day,
          gross_pay: item.gross_pay,
          total_deductions: item.total_deductions,
          net_pay: item.net_pay,
          total_expenses: item.total_expenses,
          # upload_payslip: item.upload_payslip,
          userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
    }
  end

  # ---------------------- file persistence --------------------------------------

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

  # ---------------------- file persistence --------------------------------------
def is_valide_file(%{"uploafile_name" => params}) do
  if upload = params do
    # IO.inspect(upload.filename, label: "CHeck my filename")
    case Path.extname(upload.filename) do
      ext when ext in ~w(.xlsx .XLSX .xls .XLS .csv .CSV) ->
        with {:ok, destin_path} <- persist(upload) do
          case ext not in ~w(.csv .CSV) do
            true ->
              # LoanmanagementsystemWeb.ClientManagementController.check_header(destin_path)
              case Xlsxir.multi_extract(destin_path, 0, false, extract_to: :memory) do
                {:ok, table_id} ->
                  row_count = Xlsxir.get_info(table_id, :rows)

                  first_row = Xlsxir.get_row(table_id, 1)
                  IO.inspect(first_row, limit: :infinity, label: "check first_row")
                  case @headers_list == first_row do
                    true ->
                          row_count = Xlsxir.get_info(table_id, :rows)
                          Xlsxir.close(table_id)
                          {:ok, upload.filename, destin_path, row_count - 1}

                        {:error, reason} ->
                          {:error, reason}
                    false ->

                      {:error, "Headers do not match. Please ensure the selected file is an individual client bulk file."}
                  end
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

  def extract_xlsx(path) do
    case Xlsxir.multi_extract(path, 0, false, extract_to: :memory) do
      {:ok, id} ->
        items =
          Xlsxir.get_list(id)
          |> Stream.reject(&Enum.empty?/1)
          |> Stream.reject(&Enum.all?(&1, fn item -> is_nil(item) end))
          |> Stream.drop(1)
          |> Stream.map(
            &Stream.zip(
              Stream.map(@headers, fn h -> h end),
              Stream.map(&1, fn v -> strgfy_term(v) end)
            )
          )
          |> Enum.map(&Enum.into(&1, %{}))
          # |> Enum.reject(&(Enum.join(Map.values(&1)) == ""))
          |> Enum.reject(&(&1.firstName == "" or &1.firstName == nil))

        Xlsxir.close(id)
        {:ok, items}

      {:error, reason} ->
        {:error, reason}
    end
  end



  # def extract_xlsx(path) do
  #   case Xlsxir.multi_extract(path, 0, false, extract_to: :memory) do
  #     {:ok, id} ->
  #       items =
  #         Xlsxir.get_list(id)
  #         |> Enum.reject(&Enum.empty?/1)
  #         |> Enum.reject(&Enum.all?(&1, fn item -> is_nil(item) end))
  #         |> List.delete_at(0)
  #         |> Enum.map(
  #           &Enum.zip(
  #             Enum.map(@headers, fn h -> h end),
  #             Enum.map(&1, fn v -> strgfy_term(v) end)
  #           )
  #         )
  #         |> Enum.map(&Enum.into(&1, %{}))
  #         |> Enum.reject(&(Enum.join(Map.values(&1)) == ""))

  #       Xlsxir.close(id)
  #       {:ok, items}

  #     {:error, reason} ->
  #       {:error, reason}
  #   end
  # end

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

  defp strgfy_term(term) when is_tuple(term), do: term
  defp strgfy_term(term) when not is_tuple(term), do: String.trim("#{term}")



  defp handle_suc_upload_resp(multi_records) do
    {invalid, valid} =
      multi_records
      |> Map.values()
      |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->


        IO.inspect(item)

        case item do
          # IO.inspect(meansOfIdentificationType, label: "item   TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT")
          %{meansOfIdentificationType: _src} -> {invalid, valid + 1}
          %{col_index: _index} -> {invalid + 1, valid}
          _ -> {invalid, valid}
        end
      end)

    {:ok, {invalid, valid}}
  end


  def check_header(destin_path) do

    case Xlsxir.multi_extract(destin_path, 0, false, extract_to: :memory) do
          {:ok, row} ->
            headers = Xlsxir.get_info(row)
            IO.inspect(headers, label: "Header headers headers")
            if (headers) == (@headers) do
              IO.inspect(headers, label: "Header matches!")
            else
              IO.inspect(headers, label: "Header does not match.")
            end
          _ ->

      {:error, "Failed to get header row."}
    end




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



  # def validate_records_then_process(conn, path) do
  #   {:ok, items} = extract_xlsx(path)
  #   IO.inspect(items, label: "CHeck Validation Params")

  # end


  defp validate_records_then_process(conn, user, params) do
    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
      {:ok, items} = extract_xlsx(destin_path)

        receiver_email = Loanmanagementsystem.Accounts.UserBioData.find_by(userId: user.id).emailAddress
      {valid_emails, invalid_emails} =
        Enum.partition(items, fn record ->
          UserBioData.exists?(emailAddress: record.emailAddress)
        end)

      {valid_id_number, invalid_id_number} =
        Enum.partition(items, fn record ->
          UserBioData.exists?(meansOfIdentificationNumber: record.idNumber)
        end)

      existing_email_addresses =
        valid_emails
        |> Enum.map(fn record -> record.emailAddress end)

        existing_id_number =
          valid_id_number
          |> Enum.map(fn record -> record.emailAddress end)

      case valid_id_number do
        [] ->
              case valid_emails do
                [] ->
                  user
                  |> process_client_bulk_upload(filename, destin_path)
                  |> case do
                    {:ok, {invalid, _valid}} ->
                      {:info, "Clients Uploaded Successfully", invalid}
                    {:error, reason} ->
                      {:error, reason, 0}
                  end

                _ ->
                  existing_email_addresses_string =
                    Enum.reduce(existing_email_addresses, "", fn email, acc ->
                      acc <> email <> ", "
                    end)

                  existing_email_addresses_string = String.trim_trailing(existing_email_addresses_string, ", ")

                  msg = "Some Users uploaded already exist. List has been sent to your email address."
                  conn
                  |> put_flash(:error, msg)
                  |> redirect(to: Routes.client_management_path(conn, :client_onboarding_upload))
                  Loanmanagementsystem.Emails.Email.send_emails_for_existing_users(receiver_email, "#{existing_email_addresses_string}")
              end
              _ ->
                existing_id_number_string =
            Enum.reduce(existing_id_number, "", fn email, acc ->
              acc <> email <> ", "
            end)

            existing_id_number_string = String.trim_trailing(existing_id_number_string, ", ")

          msg = "Some Users uploaded already exist. List has been sent to your email address."
          conn
          |> put_flash(:error, msg)
          |> redirect(to: Routes.client_management_path(conn, :client_onboarding_upload))
          Loanmanagementsystem.Emails.Email.send_emails_for_existing_users(receiver_email, "#{existing_id_number}")
      end
    else
      {:error, reason} ->
        {:error, reason, 0}
    end
  end




  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
