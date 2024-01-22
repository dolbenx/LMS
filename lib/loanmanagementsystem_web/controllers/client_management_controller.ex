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
  alias Loanmanagementsystem.Companies.{Employee, Client_company_details, Employee_account}
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
  alias Loanmanagementsystem.Accounts.Customer_account
  # alias Loanmanagementsystem.OperationsServices



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
        :oct_currency_lookup,
        :update_client_employee
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

  def update_client_employee(conn, %{"userid" => userid}) do
    employee = Loanmanagementsystem.OperationsServices.get_individual_details_by_id(userid)
    companies = Loanmanagementsystem.Companies.list_tbl_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "edit_client_employee.html", companies: companies, departments: departments, banks: banks, employee: employee, town: town, province: province)
  end

  def create_client_user(conn, params) do

    client_employer = try do Loanmanagementsystem.Companies.Company.find_by(id: params["company_id"]).companyName rescue _-> "" end
    username = params["emailAddress"]
    get_username = Repo.get_by(User, username: username)
    generate_otp = to_string(Enum.random(1111..9999))

    # employee_account_number = LoanmanagementsystemWeb.ClientManagementController.init_acc_no_generation(params["product_name"])

    employee_account_number = to_string(Enum.random(11111111..99999999))

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

                          password = "#{Enum.random(10_000_000..90_999_999)}"

                          bank_name = try do Bank.find_by(id: params["bank_id"]).bankName rescue _-> "" end

                          IO.inspect(bank_name, label: "BANK_NAME")


                          branch_name = try do Bank.find_by(id: params["bank_id"]).process_branch rescue _-> "" end

                          employee_number = "A-#{Enum.random(10000..99999)}"




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
                          |> Ecto.Multi.run(:customer_account, fn _repo, %{add_employer_user: add_employer_user} ->
                            Customer_account.changeset(%Customer_account{}, %{
                              account_number: employee_account_number,
                              user_id: add_employer_user.id,
                              status: "ACTIVE"
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

                          |> Ecto.Multi.run(:employee_account, fn _repo, %{add_employer_user: add_employer_user} ->
                            Employee_account.changeset(%Employee_account{}, %{

                              employee_id: add_employer_user.id,
                              employee_number: employee_number,
                              limit_balance: params["loan_limit"],
                              limit: params["loan_limit"],
                              status: "ACTIVE"
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

                          |> Ecto.Multi.run(:sms, fn _, %{add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: add_employer_user,add_user_bio_data: add_user_bio_data, client_document: _client_document} ->
                            sms = %{
                              mobile: add_user_bio_data.mobileNumber,
                              msg:
                              "Dear #{params["firstName"]}, Your Login Credentials. username: #{params["emailAddress"]}, password: #{password}, OTP: #{generate_otp}",
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

  @spec edit_client_individual(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def edit_client_individual(conn, params) do

    userbiodate = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])

    employment_details =Loanmanagementsystem.Employment.get_employment__details_by_userId(params["id"])

    personal_bank_details = Loanmanagementsystem.Employment.get_personal__bank__details_by_userId(params["id"])

    employee = Loanmanagementsystem.Companies.get_employee_by_userId(params["id"])

    client_company = Loanmanagementsystem.Companies.get_client_company_details_by_user_id!(params["id"])

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
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    agent_merchant_list = Loanmanagementsystem.Merchants.list_merchants_agent()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "merchant_maintenance.html", banks: banks, agent_merchant_list: agent_merchant_list, province: province, town: town)
  end

  def oct_company_lookup(conn, %{"company_id" => company_id}) do
    company_details = Loanmanagementsystem.Companies.otc_company_details_lookup(company_id)
    json(conn, %{"data" => List.wrap(company_details)})
  end

  def oct_currency_lookup(conn, %{"id" => id}) do
    currency_details = Loanmanagementsystem.Companies.otc_currency_details_lookup(id)
    json(conn, %{"data" => List.wrap(currency_details)})
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

  # LoanmanagementsystemWeb.ClientManagementController.init_acc_no_generation("1")
  def init_acc_no_generation(product_id) do
    "#{product_id |> String.pad_leading(2, "0")}#{sequence_no()}#{to_string(Timex.day(Timex.now())) |> String.pad_leading(3, "0")}"

    # "#{sequence_no()}#{Timex.now().year}#{(Timex.day(Timex.now())) |> String.pad_leading(3, "0")}"
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

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
