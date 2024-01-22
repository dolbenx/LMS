defmodule LoanmanagementsystemWeb.Api.ApiController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  require Logger

  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole, Address_Details, Customer_account}
  alias Loanmanagementsystem.Companies.{Company, Employee, Employee_account}
  alias Loanmanagementsystem.Notifications.Sms
  alias Loanmanagementsystem.Emails.Email
  alias Loanmanagementsystem.Merchants.{Merchants_device, Merchant, Merchant_account, Merchant_director}
  alias Loanmanagementsystem.Loan.{Loans, Loan_customer_details, Customer_Balance, Payments_transaction}
  alias Loanmanagementsystem.Employment.{Employment_Details, Personal_Bank_Details, Income_Details}
  alias Loanmanagementsystem.Maintenance.Bank


  def api_create_employer(conn, params) do
    comp_email_address = params["contactEmail"]
    comp_mobile_line = params["companyPhone"]
    comp_identification_no = params["registrationNumber"]
    get_comp_email_address = Repo.get_by(Company, contactEmail: comp_email_address)
    get_comp_mobile_line = Repo.get_by(Company, companyPhone: comp_mobile_line)
    get_comp_identification_no = Repo.get_by(Company, registrationNumber: comp_identification_no)

    account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"
    otp = to_string(Enum.random(1111..9999))
    bank_id = String.to_integer(params["bank_id"])
    reg_number = params["registrationNumber"]
      case is_nil(get_comp_email_address) do
        true ->
          case is_nil(get_comp_mobile_line) do
            true ->
              case is_nil(get_comp_identification_no) do


                true ->
                  password = "#{Enum.random(10_000_000..90_999_999)}"
                          Ecto.Multi.new()
                          |> Ecto.Multi.insert(:add_user,
                            User.changeset(%User{}, %{
                              password: password,
                              status: "INACTIVE",
                              username: params["emailAddress"],
                              auto_password: "Y",
                              pin: otp,
                              username_mobile: params["mobileNumber"]
                            })
                          )
                          |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
                            UserRole.changeset(%UserRole{}, %{
                              roleType: "EMPLOYER",
                              status: "INACTIVE",
                              userId: add_user.id,
                              otp: add_user.pin
                            })
                            |> Repo.insert()
                          end)
                          |> Ecto.Multi.run(:add_user_bio_data, fn _repo, %{add_user_role: _add_user_role, add_user: add_user} ->
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
                          |> Ecto.Multi.run(:add_company, fn _repo, %{add_user: add_user, add_user_role: add_user_role, add_user_bio_data: add_user_bio_data} ->
                            Company.changeset(%Company{}, %{
                              companyName: params["companyName"],
                              companyPhone: params["companyPhone"],
                              contactEmail: params["contactEmail"],
                              registrationNumber: reg_number,
                              taxno: params["taxno"],
                              status: "INACTIVE",
                              companyRegistrationDate: params["companyRegistrationDate"],
                              companyAccountNumber: params["companyAccountNumber"],
                              bank_id: bank_id,
                              user_bio_id: add_user_bio_data.id,
                              createdByUserId: add_user.id,
                              createdByUserRoleId: add_user_role.id,
                              isEmployer: true,
                              isOfftaker: false,
                              isSme: false
                            })
                            |> Repo.insert()
                          end)
                          |> Ecto.Multi.run(:update_company, fn (_repo, %{add_user: user_data, add_company: company_data}) ->
                            Repo.update(User.changeset(user_data, %{company_id: company_data.id}))
                          end)
                          |> Ecto.Multi.run(:customer_balance, fn _repo, %{add_user_role: _add_user_role, add_company: _add_company, add_user: add_user} ->
                            Customer_Balance.changeset(%Customer_Balance{}, %{
                              account_number: account_number,
                              user_id: add_user.id
                            })
                            |> Repo.insert()
                          end)

                          |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_user_role: _add_user_role, add_company: _add_company, add_user: add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance} ->
                            Address_Details.changeset(%Address_Details{}, %{
                              accomodation_status: params["accomodation_status"],
                              area: params["area"],
                              house_number: params["house_number"],
                              street_name: params["street_name"],
                              town: params["town"],
                              province: params["province"],
                              userId: add_user.id,
                              year_at_current_address: params["year_at_current_address"]
                            })
                            |> Repo.insert()
                          end)

                          |> Ecto.Multi.run(:sms, fn _, %{add_user_bio_data: add_user_bio_data, add_user: add_user} ->
                            sms = %{
                              mobile: add_user_bio_data.mobileNumber,
                              msg:
                              "Hello #{params["firstName"]}, Your login credentials are as follows, and the Company has been created. Password: #{password}, OTP: #{add_user.pin}, username: #{params["emailAddress"]}.",
                              status: "READY",
                              type: "SMS",
                              msg_count: "1"
                            }

                            Sms.changeset(%Sms{}, sms)
                            |> Repo.insert()
                          end)

                          |> Ecto.Multi.run(:user_logs, fn _repo,%{add_user_role: add_user_role, add_company: _add_company, add_user: add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
                            UserLogs.changeset(%UserLogs{}, %{
                              activity: "Added #{add_user_role.roleType} Successfully",
                              user_id: add_user.id
                            })
                            |> Repo.insert()
                          end)
                          |> Ecto.Multi.run(:document, fn _repo, %{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
                            Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => add_company.id})
                          end)
                          |> Repo.transaction()
                          |> case do
                            {:ok, %{add_user_role: add_user_role, add_company: _add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, user_logs: _user_logs}} ->
                              Email.send_email(params["emailAddress"], password, params["firstName"])

                              conn
                              |> put_status(:ok)
                              |> json(%{data: [], status: true, message: "You Have Successfully added #{add_user_role.roleType}"})

                            {:error, _failed_operation, failed_value, _changes_so_far} ->
                              reason = traverse_errors(failed_value.errors) |> List.first()

                              conn
                              |> put_status(:bad_request)
                              |> json(%{data: "Failed, #{reason}", status: false, message: "FAILED"})
                          end
                        _ ->
                          conn

                          |> put_status(:bad_request)
                          |> json(%{data: [], status: false, message: "Corporate with registration number #{comp_identification_no} already exists"})
                    end
                      _ ->
                        conn

                        |> put_status(:bad_request)
                        |> json(%{data: [], status: false, message: "Corporate with phone number #{comp_mobile_line} already exists"})
                  end
          _ ->
            conn

            |> put_status(:bad_request)
            |> json(%{data: [], status: true, message: "Corporate with email address #{comp_email_address} already exists"})
      end
  end

  def api_create_employee(conn, params) do

    client_employer = try do Loanmanagementsystem.Companies.Company.find_by(id: params["company_id"]).companyName rescue _-> "" end
    username = params["emailAddress"]
    get_username = Repo.get_by(User, username: username)
    generate_otp = to_string(Enum.random(1111..9999))

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

                          password = "#{Enum.random(10_000_000..90_999_999)}"

                          bank_name = try do Bank.find_by(id: params["bank_id"]).bankName rescue _-> "" end


                          branch_name = try do Bank.find_by(id: params["bank_id"]).process_branch rescue _-> "" end

                          employee_number = "A-#{Enum.random(10000..99999)}"

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
                              pin: otp,
                              username_mobile: params["mobileNumber"]
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
                              number_of_dependants: params["number_of_dependants"],
                            })
                            |> Repo.insert()
                          end)

                          |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data } ->
                            UserRole.changeset(%UserRole{}, %{
                              roleType: "EMPLOYEE",
                              status: "INACTIVE",
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
                              area: params["addr_area"],
                              house_number: params["house_number"],
                              street_name: params["street_name"],
                              town: params["addr_town"],
                              province: params["addr_province"],
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

                          # |> Ecto.Multi.run(:client_document, fn _repo, %{add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: add_employer_user,add_user_bio_data: add_user_bio_data } ->
                          #   Loanmanagementsystem.Services.ClientUploads.client_upload(%{ "process_documents" => params, "conn" => conn, "company_id" => String.to_integer(params["company_id"]), "individualId" => add_employer_user.id, "nrc" => add_user_bio_data.meansOfIdentificationNumber })
                          # end)

                          |> Ecto.Multi.run(:user_logs, fn _repo, %{add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: add_employer_user,add_user_bio_data: _add_user_bio_data, client_document: _client_document} ->
                            UserLogs.changeset(%UserLogs{}, %{
                              activity: "Added User Successfully",
                              user_id: add_employer_user.id
                            })
                            |> Repo.insert()
                          end)

                          |> Ecto.Multi.run(:sms, fn _, %{add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: _add_employer_user,add_user_bio_data: add_user_bio_data, client_document: _client_document} ->
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
                              Loanmanagementsystem.Workers.Sms.send()

                              conn
                              |> put_status(:ok)
                              |> json(%{data: [], status: true, message: "You have Successfully Created #{add_user_bio_data.firstName} #{add_user_bio_data.lastName} As An Employee"})

                            {:error, _failed_operations, _failed_value, _changes_so_far} ->

                              conn
                              |> put_status(:bad_request)
                              |> json(%{data: [], status: false, message: "DECLINED"})
                            end
                          end
                    _ ->
                      conn
                      |> put_status(:bad_request)
                      |> json(%{data: [], status: false, message: "User with phone number #{user_mobile_line} Already Exists"})
                  end

                _ ->
                  conn
                  |> put_status(:bad_request)
                  |> json(%{data: [], status: false, message: "User with email address #{username} Already Exists"})
            end

          _ ->
            conn
            |> put_status(:bad_request)
            |> json(%{data: [], status: false, message: "User with ID number #{user_identification_no} Already Exists"})
      end


  end

  def api_create_merchant_maintenance(conn, params) do

    get_comp_email_address = params["contactEmail"]
    get_comp_mobile_line = params["companyPhone"]
    get_comp_identification_no = params["registrationNumber"]

    mobileNumber = params["mobileNumber"]
    emailAddress = params["emailAddress"]
    meansOfIdentificationNumber = params["meansOfIdentificationNumber"]

    comp_email_address = Repo.get_by(Merchant, contactEmail: get_comp_email_address)
    comp_mobile_line = Repo.get_by(Merchant, companyPhone: get_comp_mobile_line)
    comp_registration_no = Repo.get_by(Merchant, registrationNumber: get_comp_identification_no)

    get_mobile_number = Repo.get_by(UserBioData, mobileNumber: mobileNumber)

    get_email_address = Repo.get_by(UserBioData, emailAddress: emailAddress)

    get_nrc_number = Repo.get_by(UserBioData, meansOfIdentificationNumber: meansOfIdentificationNumber)

    case is_nil(comp_registration_no) do
      true ->
      case is_nil(comp_mobile_line) do
        true ->
        case is_nil(comp_email_address) do
          true ->
          case is_nil(get_mobile_number  || get_email_address || get_nrc_number) do
            true ->
              otp = to_string(Enum.random(1111..9999))
              password = LoanmanagementsystemWeb.UserController.random_string()

              Ecto.Multi.new()
              |> Ecto.Multi.insert(
                :add_user,
                User.changeset(%User{}, %{
                  password: password,
                  status: "ACTIVE",
                  username: params["contactEmail"],
                  auto_password: "Y",
                  pin: otp,
                  username_mobile: params["mobileNumber"],

                })
              )

              |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
                UserRole.changeset(%UserRole{}, %{
                  roleType: "MERCHANT",
                  status: "ACTIVE",
                  userId: add_user.id,
                  otp: otp,
                  client_type: params["client_type"]

                })
                |> Repo.insert()
              end)

              |> Ecto.Multi.run(:add_user_bio_data, fn _repo,%{ add_user: add_user, add_user_role: _add_user_role} ->
                UserBioData.changeset(%UserBioData{}, %{

                  firstName: params["firstName"],
                  lastName: params["lastName"],
                  mobileNumber: params["mobileNumber"],
                  userId: add_user.id,
                  dateOfBirth: params["dateOfBirth"],
                  emailAddress: params["emailAddress"],
                  gender: params["gender"],
                  meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
                  meansOfIdentificationType: params["meansOfIdentificationType"],
                  otherName: params["otherName"],
                  title: params["title"],
                  bank_account_number: params["bank_account_number"],
                  number_of_dependants: params["number_of_dependants"],
                })
                |> Repo.insert()
              end)

              |> Ecto.Multi.run(:update_address_details, fn _repo, %{add_user: add_user, add_user_role: _add_user_role, add_user_bio_data: _add_user_bio_data} ->
                Address_Details.changeset(%Address_Details{}, %{

                  accomodation_status: params["accomodation_status"],
                  area: params["area"],
                  house_number: params["house_number"],
                  street_name: params["street_name"],
                  town: params["town"],
                  province: params["province"],
                  userId: add_user.id,
                  year_at_current_address: params["year_at_current_address"]

                })
                |> Repo.insert()
              end)

              |> Ecto.Multi.run(:customer_account, fn _repo, %{add_user: add_user, add_user_role: _add_user_role, add_user_bio_data: _add_user_bio_data, update_address_details: _update_address_details} ->
                Customer_account.changeset(%Customer_account{}, %{
                  account_number: "01",
                  status: "ACTIVE",
                  user_id: add_user.id,
                  assignment_date: Date.utc_today(),
                })
                |> Repo.insert()
              end)

              |> Ecto.Multi.run(:sms, fn _repo,%{add_user: add_user, add_user_role: _add_user_role, add_user_bio_data: add_user_bio_data, update_address_details: _update_address_details, customer_account: _customer_account} ->
                my_otp = add_user.pin

                sms = %{
                  mobile: add_user_bio_data.mobileNumber,
                  msg: "Dear #{params["companyName"]}, Your Login Credentials. username: #{params["contactEmail"]}, password: #{password}, OTP: #{my_otp}",
                  status: "READY",
                  type: "SMS",
                  msg_count: "1"}

                  Loanmanagementsystem.Notifications.Sms.changeset(%Loanmanagementsystem.Notifications.Sms{}, sms)
                |> Repo.insert()
              end)

              |> Ecto.Multi.run(:merchant, fn _repo,%{add_user: add_user, add_user_role: _add_user_role, add_user_bio_data: _add_user_bio_data, update_address_details: _update_address_details, customer_account: _customer_account, sms: _sms} ->


                  merchant_number = "A-#{Enum.random(10000..99999)}"


                  barcodeval = Integer.to_string(Enum.random(100000000000..999999999999))

                  settings = %QRCode.SvgSettings{qrcode_color: {17, 170, 136}}
                  file_name = "qrcode_#{barcodeval}.svg"
                  file_path = File.cwd! <> "D:/Work/Projects/Pekesho/qrcodes/#{file_name}"
                  _qrpath =

                    """
                    Qr code: #{barcodeval}
                    Merchant Number: #{merchant_number}
                    Company Name: #{params["companyName"]}
                    Company Phone: #{params["companyPhone"]}
                    Registration Number: #{params["registrationNumber"]}
                    Contact Email: #{params["contactEmail"]}
                    """
                    |> QRCode.create(:low)
                    |> Result.and_then(&QRCode.Svg.save_as(&1, File.cwd! <> file_path, settings))

                  merchant = %{
                  bankId: params["bank_id"],
                  companyAccountNumber: params["companyAccountNumber"],
                  companyName: params["companyName"],
                  companyPhone: params["companyPhone"],
                  companyRegistrationDate: params["companyRegistrationDate"],
                  contactEmail: params["contactEmail"],
                  registrationNumber: params["registrationNumber"],
                  status: "ACTIVE",
                  merchantType: params["merchantType"],
                  businessName: params["businessName"],
                  taxno: params["taxno"],
                  qr_code_name: file_name,
                  merchant_number: merchant_number,
                  qr_code_path: file_path,
                  user_id: add_user.id}

                  Merchant.changeset(%Merchant{}, merchant)
                |> Repo.insert()
              end)

              |> Ecto.Multi.run(:update_merchant, fn _repo, %{add_user: add_user, merchant: merchant} ->
                User.changeset(add_user, %{company_id: merchant.id})
                |> Repo.update()
              end)

              |> Ecto.Multi.run(:merchant_device, fn _repo, %{ add_user_bio_data: _add_user_bio_data, add_user: _add_user, add_user_role: _add_user_role, sms: _sms, merchant: merchant} ->
                Merchants_device.changeset(%Merchants_device{}, %{

                  "merchantId" => merchant.id,
                  "deviceIMEI" => params["deviceIMEI"],
                  "deviceAgentLine" => params["deviceAgentLine"],
                  "deviceModel" => params["deviceModel"],
                  "deviceType" => params["deviceType"],
                  "deviceName" => params["deviceName"],
                  "status" => "ACTIVE"
                })
                |> Repo.insert()
              end)


              |> Ecto.Multi.run(:merchant_account, fn _repo, %{ add_user_bio_data: _add_user_bio_data, add_user: _add_user, add_user_role: _add_user_role, sms: _sms, merchant: merchant} ->
                Merchant_account.changeset(%Merchant_account{}, %{

                  merchant_id: merchant.id,
                  merchant_number: merchant.merchant_number,
                  status: "ACTIVE"
                })
                |> Repo.insert()
              end)

              |> Ecto.Multi.run(:merchant_director, fn _repo, %{add_user_bio_data: _add_user_bio_data, add_user: _add_user, add_user_role: _add_user_role, sms: _sms, merchant: merchant} ->
                Merchant_director.changeset(%Merchant_director{}, %{

                  firstName: params["dr_firstName"],
                  lastName: params["dr_lastName"],
                  mobileNumber: params["dr_mobileNumber"],
                  status: "ACTIVE",
                  date_of_birth: params["dr_dateOfBirth"],
                  emailAddress: params["dr_emailAddress"],
                  gender: params["dr_gender"],
                  directorIdentificationnNumber: params["dr_meansOfIdentificationNumber"],
                  directorIdType: "National Registration Card",
                  otherName: params["dr_otherName"],
                  title: params["dr_title"],
                  house_number: params["dr_house_number"],
                  street_name: params["dr_street_name"],
                  area: params["dr_area"],
                  town: params["dr_town"],
                  province: params["dr_province"],
                  accomodation_status: params["dr_accomodation_status"],
                  years_at_current_address: params["dr_year_at_current_address"],
                  merchantId: merchant.id,
                  merchantType: params["merchantType"],
                  businessNature: params["businessNature"]

                })
                |> Repo.insert()
              end)

              |> Ecto.Multi.run(:client_document, fn _repo, %{add_user_bio_data: _add_user_bio_data, add_user: add_user, add_user_role: _add_user_role, sms: _sms, merchant: merchant} ->
                Loanmanagementsystem.Services.MerchantUploads.merchant_upload(%{ "process_documents" => params, "conn" => conn, "company_id" => merchant.id, "individualId" => add_user.id, "tax" => merchant.taxno })
              end)

              |> Ecto.Multi.run(:user_logs, fn _repo, %{ add_user: add_user, add_user_role: _add_user_role} ->
                UserLogs.changeset(%UserLogs{}, %{
                  activity: "Successfuly created the user #{add_user.username}",
                  user_id: add_user.id
                })
                |> Repo.insert()
              end)

              |> Repo.transaction()
              |> case do
                {:ok, add_user: add_user} ->
                  Loanmanagementsystem.Workers.Sms.send()
                  Email.send_email(params["emailAddress"], password, params["companyName"])

                  conn
                  |> put_status(:ok)
                  |> json(%{data: [], status: true, message: "You have successfuly created the user #{add_user.username}"})

                {:error, _failed_operations, failed_value, _changes_so_far} ->
                  reason = traverse_errors(failed_value.errors)

                  conn
                  |> put_status(:bad_request)
                  |> json(%{data: [], status: true, message: "FAILED #{reason}"})
              end
              _ ->
              conn
              |> put_status(:bad_request)
              |> json(%{data: [], status: false, message: "User already exists"})
          end
          _ ->
          conn
          |> put_status(:bad_request)
          |> json(%{data: [], status: false, message: "Merchant with email address #{get_comp_email_address} already exists"})
        end
        _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{data: [], status: false, message: "Merchant with phone number #{get_comp_mobile_line} already exists"})
      end
      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{data: [], status: false, message: "Corporate with registration number #{get_comp_identification_no} already exists"})
    end
  end


  def initiate_loan_application(conn, params) do

    get_bio_data = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]) rescue _-> nil end

      new_params =
        Map.merge(params, %{
          "principal_amount_proposed" => params["requested_amount"],
          "principal_amount" => params["requested_amount"],
          "interest_amount" => params["total_interest"],
          "arrangement_fee" => params["arrangement_fee"],
          "finance_cost" => params["finance_cost"],
          "repayment_amount" => params["totalPayment"],
          "requested_amount" => params["requested_amount"],
          "application_date" => Timex.today(),
          "monthly_installment" => params["monthly_installment"],
          "balance" => params["totalPayment"],
          "company_id" => params["company_id"],
          "tenor" => params["repayment"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "reference_no" =>  generate_reference_no(params["customer_id"]),
          # "loan_officer_id" => conn.assigns.user.id
        })

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:add_loan, Loans.changeset(%Loans{}, new_params))
      # |> Ecto.Multi.insert(:invoice_loan, Sms.changeset(%Sms{}, params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Loan Application Successfully Submitted",
          user_id: conn.assigns.current_user.user.id
        })
        |> Repo.insert()
      end)


      |> Ecto.Multi.run(:loan_customer_details, fn _repo, %{add_loan: add_loan} ->
        Loan_customer_details.changeset(%Loan_customer_details{}, %{
            "cell_number" => get_bio_data.mobileNumber,
            "customer_id" => get_bio_data.userId,
            "dob" => get_bio_data.dateOfBirth,
            "email" => get_bio_data.emailAddress,
            "firstname" => get_bio_data.firstName,
            "surname" => get_bio_data.lastName,
            "id_type" => get_bio_data.meansOfIdentificationType,
            "gender" => get_bio_data.gender,
            "id_number" => get_bio_data.meansOfIdentificationNumber,
            "othername" => get_bio_data.otherName,
            "reference_no" => add_loan.reference_no,
            "loan_id" => add_loan.id,
        })
        |> Repo.insert()
      end)

      |> Ecto.Multi.run(:document, fn _repo, %{add_loan: add_loan, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.ApiApplicationUploads.api_loan_application_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id}, params)
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_loan: _add_loan, user_logs: _user_logs}} ->
          # Email.confirm_approval(email_address)
          # Loanmanagementsystem.Workers.Sms.send()
          conn
          |> put_status(:ok)
          |> json(%{data: [], status: true, message: "Loan application has successfully been submitted"})

        {:error, _failed_operation, _failed_value, _changes_so_far} ->

          conn
          |> put_status(:bad_request)
          |> json(%{data: [], status: false, message: "DECLINED"})
      end
  end

  def api_send_otp(conn, params) do
    IO.inspect(params, label: "Hello SADC")
    client_line = conn.assigns.current_user.user.username_mobile

    # product_id = params["product_id"]
    client_line = client_line
    generate_otp = to_string(Enum.random(1111..9999))

    text = "To verify your loan initiation, please provide the OTP - #{generate_otp}"

    params = Map.put(params, "mobile", client_line)
    params = Map.put(params, "msg", text)
    params = Map.put(params, "status", "READY")
    params = Map.put(params, "type", "SMS")
    params = Map.put(params, "msg_count", "1")

    if Loanmanagementsystem.Accounts.UserBioData.exists?(mobileNumber: "#{client_line}") == true do

    client_role = Loanmanagementsystem.Accounts.get_client_loan_by_line(client_line)

     my_client_role = Loanmanagementsystem.Accounts.get_user_role!(client_role.role_id)

     Loanmanagementsystem.Accounts.update_user_role(my_client_role, %{otp: generate_otp})

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:loan_otp, Sms.changeset(%Sms{}, params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_otp: _loan_otp} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Add send loan OTP Successfully",
          user_id: conn.assigns.current_user.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{loan_otp: _loan_otp, user_logs: _user_logs}} ->
          Loanmanagementsystem.Workers.Sms.send()

          conn
          |> put_status(:ok)
          |> json(%{data: client_line, status: true, message: "OTP has been sent to your Mobile Number"})

        {:error, _failed_operation, _failed_value, _changes_so_far} ->

          conn
          |> put_status(:bad_request)
          |> json(%{data: [], status: false, message: "DECLINED"})

      end
        else
          conn
          |> put_status(:bad_request)
          |> json(%{data: [], status: false, message: "The number you entered is not registered: Check the number and try again."})
    end
  end

  @spec api_validate_otp(Plug.Conn.t(), nil | maybe_improper_list() | map()) :: Plug.Conn.t()
  def api_validate_otp(conn, params) do

    nrc = params["identification"]

    otp1 = params["otp1"]
    otp2 = params["otp2"]
    otp3 = params["otp3"]
    otp4 = params["otp4"]
    user_otp = "#{otp1}#{otp2}#{otp3}#{otp4}"

    IO.inspect(params, label: "-----------------OTP----------------")

    query = from(uB in Loanmanagementsystem.Accounts.User, select: uB)

    current_user_id = Repo.all(query)

    currentUserId = Enum.at(current_user_id, 0)

    IO.inspect(currentUserId, label: "-----------------currentUserId----------------")

    IO.inspect(conn, label: "conn.assigns.user.id")

    client_role = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)

    # client_line = client_role.mobileNumber
    my_client_role = Loanmanagementsystem.Accounts.get_user_role!(client_role.role_id)

    if my_client_role.otp == user_otp && user_otp != nil do


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
              # user_id: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: client_line).userId
              # user_id: conn.assigns.user.id
              user_id: conn.assigns.current_user.user.id
            })
            |> Repo.insert()
          end)
          |> Repo.transaction()
          |> case do
            {:ok, %{otp_validate: _otp_validate, user_logs: _user_logs}} ->
              conn
              |> put_status(:ok)
              |> json(%{data: user_otp, status: true, message: "OTP Validated Successfully Proceed With Your Loan Application"})

            {:error, _failed_operation, _failed_value, _changes_so_far} ->

              conn
              |> put_status(:bad_request)
              |> json(%{data: [], status: false, message: "DECLINED"})
          end
    else

    conn
      |> put_status(:bad_request)
      |> json(%{data: [], status: false, message: "OTP does not match"})

    end
  end

  def confirm_employer_code(conn, params) do

    comp_employer_code = params["employer_code"]

    get_comp_employer_code = Repo.get_by(Company, employer_code: comp_employer_code)

    get_company_id = Company.find_by(employer_code: comp_employer_code).id

    get_company_name = Company.find_by(employer_code: comp_employer_code).companyName

    get_company_pacra_number = Company.find_by(employer_code: comp_employer_code).registrationNumber

    get_company_contact = Company.find_by(employer_code: comp_employer_code).companyPhone

    get_company_email = Company.find_by(employer_code: comp_employer_code).companyEmail

    update_company = Loanmanagementsystem.Companies.get_company!(get_company_id)

      case is_nil(get_comp_employer_code) do
          false ->
            Ecto.Multi.new()
            |> Ecto.Multi.update(:update_company,
              Company.changeset(update_company, %{

                employer_code: comp_employer_code

              }))

            |> Ecto.Multi.run(:user_logs, fn _repo, %{update_company: _update_company} ->
              UserLogs.changeset(%UserLogs{}, %{
                activity: "Confirmed Employer Code Successfully",
                user_id: Loanmanagementsystem.Accounts.User.find_by(employer_code: comp_employer_code).id
              })
              |> Repo.insert()
            end)

            |> Repo.transaction()
            |> case do

              {:ok, %{update_company: _update_company}} ->

                conn
                |> put_status(:ok)
                |> json(%{data: %{id: get_company_id, code: comp_employer_code, name: get_company_name, reg_number: get_company_pacra_number, contact: get_company_contact, email: get_company_email}, status: true, message: "You Have Successfully Confirmed Employer Code"})

              {:error, _failed_operation, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors) |> List.first()


                conn
                |> put_status(:bad_request)
                |> json(%{data: [], status: false, message: "DECLINED, #{reason}"})
            end
          _ ->
            conn

            |> put_status(:bad_request)
            |> json(%{data: [], status: false, message: "Corporate with employer code #{comp_employer_code} does not exist exists"})
      end
  end

  def forget_password(conn, params) do

    random_int = to_string(Enum.random(1111..9999))
    username_data = params["username"]
    system_data = Repo.get_by(User, username: username_data)

    if system_data == nil do
      conn
      |> put_status(:bad_request)
      |> json(%{data: [], status: false, message: "Username Does Not Exist on the system."})

    else
      if system_data.status == "ACTIVE" do
        get_bio_data = Loanmanagementsystem.Accounts.get_user_for_otp(username_data)

        Ecto.Multi.new()
        |> Ecto.Multi.update(:systemparams, User.changeset(system_data, %{pin: random_int}))
        |> Repo.transaction()
        |> case do
          {:ok, %{systemparams: _systemparams}} ->

            sms = %Sms{
              mobile: get_bio_data.mobile,
              msg: "Your OTP is #{random_int}. Do not share it with anyone.",
              status: "READY",
              type: "SMS",
              msg_count: "1"
            }
            Repo.insert!(sms)

            Email.send_otp(get_bio_data.email, random_int)
            Loanmanagementsystem.Workers.Sms.send()

            conn
            |> put_status(:ok)
            |> json(%{data: %{username: username_data, otp: random_int}, status: true, message: "Message with OTP sent Successfully. Please Enter the OTP sent to your email or mobile number."})

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_status(:bad_request)
            |> json(%{data: [], status: false, message: "DECLINED, #{reason}"})
        end
      else
        conn
        |> put_status(:bad_request)
        |> json(%{data: [], status: false, message: "User is Disabled, Please Contact Paykesho."})
      end
    end
  end

  def forgot_password_validate_otp(conn, params) do
    username_data = params["username"]
    otp1 = params["otp1"]
    otp2 = params["otp2"]
    otp3 = params["otp3"]
    otp4 = params["otp4"]
    pin = "#{otp1}#{otp2}#{otp3}#{otp4}"

    query = from(uB in User, where: uB.username == ^username_data and uB.pin == ^pin, select: uB)
    users = Repo.all(query)

    user = Enum.at(users, 0)
    IO.inspect(user, label: "-------------------ID---------------")

    if(!is_nil(users) && Enum.count(users) > 0) do
      users = Enum.at(users, 0)

      users = User.changeset(users, %{pin: nil})

      Repo.update!(users)

      system_data = Repo.get_by(User, username: username_data)

      if(is_nil(system_data)) do
        conn
        |> put_status(:bad_request)
        |> json(%{data: username_data, status: false, message: "Invalid OTP provided"})
        else
        conn
        |> put_status(:ok)
        |> json(%{data: username_data, status: true, message: "OTP Validated Successfully."})
      end
    else
      conn
      |> put_status(:bad_request)
      |> json(%{data: username_data, status: false, message: "Invalid OTP provided"})
    end
  end

  def forgot_password_post_new_user_set_password(conn, params) do
    username_data = params["username"]
    password = params["password"]
    cpassword = params["cpassword"]

    Logger.info("password...#{password}")
    Logger.info("cpassword...#{cpassword}")

    if password == cpassword do
      query = from(uB in User, where: uB.username == ^username_data, select: uB)
      users = Repo.all(query)

      if Enum.count(users) > 0 do
        user = Enum.at(users, 0)

        changeset = User.changeset(user, %{password: password})

        case Repo.update(changeset) do
          {:ok, _changeset} ->

            conn
            |> put_status(:ok)
            |> json(%{data: username_data, status: true, message: "Password Successfully Changed."})

          {:error, changeset} ->
            errMessage = User.changeset_error_to_string(changeset)

            conn
            |> put_status(:bad_request)
            |> json(%{data: username_data, status: false, message: "DECLINED, #{errMessage}"})
        end
      else
        conn
        |> put_status(:bad_request)
        |> json(%{data: username_data, status: false, message: "Invalid login details provided"})
      end
    else
      conn
      |> put_status(:bad_request)
      |> json(%{data: username_data, status: false, message: "Password provided must match the confirmation password you provided"})
    end
  end

  def get_bank_list(conn, _params) do
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks
    #  |> BillboardsystemWeb.Api.BillboardController.struct_list_process

     if Enum.count(banks) >= 1 do

      conn
      |> put_status(:ok)
      |> json(%{data: banks, status: "SUCCESS"})

      |> put_status(:ok)
      |> json(%{data: banks, status: true, message: "SUCCESS"})

     else

      conn
      |> put_status(:forbidden)
      |> json(%{data: [], status: false, message: "No Banks Found"})

     end
  end


  def get_loans_list_by_id(conn, _params) do

    loans_list = Loanmanagementsystem.Loan.get_loans_list_api(conn.assigns.current_user.user.id)

     if Enum.count(loans_list) >= 1 do

      conn
      |> put_status(:ok)
      |> json(%{data: loans_list, status: "SUCCESS"})

      |> put_status(:ok)
      |> json(%{data: loans_list, status: true, message: "SUCCESS"})

     else

      conn
      |> put_status(:forbidden)
      |> json(%{data: [], status: false, message: "No Loans Found"})

     end
  end

  def make_payment(conn, params) do

    payment_amount_1 = params["payment_amount"]

    get_by_employee_id = Loanmanagementsystem.Accounts.User.find_by(id: conn.assigns.current_user.user.id).id

    loan_id = Loans.find_by(customer_id: conn.assigns.current_user.user.id).id

    get_by_employee_details = Loanmanagementsystem.Accounts.UserBioData.find_by(userId: get_by_employee_id)

    get_merchant_account = Merchant_account.find_by(merchant_number: params["merchant_number"])

    get_by_employee_account_details = Employee_account.find_by(employee_id: get_by_employee_id)

    get_employee_balance = get_by_employee_account_details.balance

    get_merchant_account_1 = get_merchant_account.balance


    payment_amount = try do
      case String.contains?(String.trim(payment_amount_1), ".") do
        true ->  String.trim(payment_amount_1) |> String.to_float()
        false ->  String.trim(payment_amount_1) |> String.to_integer() end
    rescue _-> 0 end

    if (get_employee_balance >= payment_amount) do

      actual_employee_balance = (get_employee_balance - payment_amount)

      actual_merchant_balance = (get_merchant_account_1 + payment_amount)

      amount_decimal = round(actual_employee_balance)

      Ecto.Multi.new()
      |> Ecto.Multi.update(:update_employee_account,
      Employee_account.changeset(get_by_employee_account_details, %{

          balance: actual_employee_balance

      }))

      |> Ecto.Multi.run(:update_merchant_account, fn _repo, %{update_employee_account: _update_employee_account} ->
        Merchant_account.changeset(get_merchant_account, %{

          balance: actual_merchant_balance

        })
        |> Repo.update()
      end)

      |> Ecto.Multi.run(:loan_payment_transaction, fn _repo,%{update_employee_account: _update_employee_account} ->
        Payments_transaction.changeset(%Payments_transaction{}, %{

          employee_id: get_by_employee_account_details.employee_id,
          employee_number: get_by_employee_account_details.employee_number,
          loan_id: loan_id,
          merchant_id: get_merchant_account.id,
          payment_amount: params["payment_amount"],
          reference_no: LoanmanagementsystemWeb.Api.ApiController.generate()

        })
        |> Repo.insert()
      end)

      |> Ecto.Multi.run(:sms, fn _, %{update_employee_account: _update_employee_account} ->
        datetime = Timex.now("UTC")
        modified_datetime = Timex.shift(datetime, hours: +2)
        employee_sms = %{
          mobile: get_by_employee_details.mobileNumber,
          msg:
          "Hello #{get_by_employee_details.firstName} #{get_by_employee_details.lastName}, Your paykesho loan account has been debited with ZMW #{payment_amount} on #{modified_datetime} for your payment. Your Loan balance is ZMW #{actual_employee_balance} Thank you.",
          status: "READY",
          type: "SMS",
          msg_count: "1"
        }

        Sms.changeset(%Sms{}, employee_sms)
        |> Repo.insert()
      end)

      |> Ecto.Multi.run(:user_logs, fn _repo, %{update_employee_account: _update_employee_account} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Payment Successfully Completed",
          user_id: conn.assigns.current_user.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, _} ->
        Loanmanagementsystem.Workers.Sms.send()

          conn
          |> put_status(:ok)
          |> json(%{data: %{payment_ammount: payment_amount,employee_balance: amount_decimal, merchant_balance: actual_merchant_balance}, status: true, message: "Payment Successfully Completed"})

        {:error, _failed_operations, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_status(:bad_request)
          |> json(%{data: [], status: false, message: "DECLINED, #{reason}"})
      end

      else
      conn
        |> put_status(:bad_request)
        |> json(%{data: [], status: false, message: "You dont have enough funds to do the transaction."})
    end
  end

  def get_transaction_list(conn, _params) do

    transactions = Loanmanagementsystem.Loan.get_payment_transactions_by_id(conn.assigns.current_user.user.id)

     if Enum.count(transactions) >= 1 do

      conn
      |> put_status(:ok)
      |> json(%{data: transactions, status: "SUCCESS"})

      |> put_status(:ok)
      |> json(%{data: transactions, status: true, message: "SUCCESS"})

     else

      conn
      |> put_status(:forbidden)
      |> json(%{data: [], status: false, message: "No Transactions Found"})

     end
  end

  def get_employee_current_balance(conn, _params) do

    current_balance = Loanmanagementsystem.Loan.get_employee_current_balance(conn.assigns.current_user.user.id)

     if Enum.count(current_balance) >= 1 do

      conn
      |> put_status(:ok)
      |> json(%{data: current_balance, status: "SUCCESS"})

      |> put_status(:ok)
      |> json(%{data: current_balance, status: true, message: "SUCCESS"})

     else

      conn
      |> put_status(:forbidden)
      |> json(%{data: [], status: false, message: "No Transactions Found"})

     end
  end

  def generate_reference_no(customer_id) do
    date = Timex.today()
    year = to_string(date.year)
    month = to_string(date.month)
    day = to_string(date.day)
    start_of_year_date = Timex.beginning_of_year(date)
    current_year = date
    date_difference = to_string(Date.diff(current_year, start_of_year_date))
    "A-" <> "" <> year <> "" <> month <> "" <> day <>"" <> "." <> "" <> date_difference <> "" <> "" <> "." <> "" <> customer_id <> "" <> "." <> to_string(System.system_time(:second))
  end

  def generate do
    random_binary = :crypto.strong_rand_bytes(16)
    reference_number = Base.encode16(random_binary, case: :lower)

    IO.puts("Generated Reference Number: #{reference_number}")
    reference_number
  end

  def signout(conn, _params) do
    {:ok, _} = Loanmanagementsystem.Logs.create_user_logs(%{
        user_id: conn.assigns.current_user.user.id,
        activity: "logged out"
      })

    conn
    |> put_status(:ok)
    |> clear_session()
    |> json(%{data: [], status: true, message: "User Loged Out Successfully"})

    rescue
    _ ->

    conn
    |> put_status(:ok)
    |> clear_session()
    |> json(%{data: [], status: true, message: "User Loged Out Successfully"})
  end

  def traverse_errors(errors), do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")

end
