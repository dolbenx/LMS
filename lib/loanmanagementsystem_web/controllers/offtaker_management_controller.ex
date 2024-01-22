defmodule LoanmanagementsystemWeb.OfftakerManagementController do
  use LoanmanagementsystemWeb, :controller
  use Ecto.Schema
  import Ecto.Query, warn: false
  require Logger
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Emails.Email
  alias Loanmanagementsystem.Accounts.{User, UserRole, UserBioData, Address_Details, Customer_account}
  alias Loanmanagementsystem.Merchants.{Merchant_account, Merchant_director, Merchant, Merchants_device}
  alias Loanmanagementsystem.Merchants
  alias Loanmanagementsystem.Logs.UserLogs
  # alias Loanmanagementsystem.Operations
  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Loan.Customer_Balance
  # alias Loanmanagementsystem.Employment.Personal_Bank_Details
  # alias Loanmanagementsystem.Merchants.Merchant
  # alias Loanmanagementsystem.Merchants.Merchant_director
  # alias Loanmanagementsystem.Merchants.Merchants_device
  alias Loanmanagementsystem.Notifications.Sms

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

  plug LoanmanagementsystemWeb.Plugs.Authenticate,
		       [module_callback: &LoanmanagementsystemWeb.OfftakerManagementController.authorize_role/1]
		       when action not in [
            :create_employer_maintenance,
            :create_sme_maintenance,
            :edit_company_offtaker,
            :employer_maintenance,
            :oil_marketing_company,
            :push_to_device,
            :push_to_director_details,
            :push_to_user_bio_data,
            :push_to_user_role,
            :push_to_userlog,
            :push_to_users,
            :traverse_errors,
            :add_employer,
            :add_sme,
            :sme_maintenance,
            :add_offtaker,
            :offtaker_maintenance,
            :create_offtaker_maintenance,
            :view_employer_details,
            :display_pdf,
            :edit_company_sme,
            :edit_company_employer,
            :merchant_maintenance,
            :create_merchant_maintenance,
            :edit_merchant_maintenance,
            :employer_rep_change_status,

          ]

		  use PipeTo.Override


  def employer_maintenance(conn, _params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isEmployer != true))
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "employer_maintenance.html", companies: companies, banks: banks)
  end



  def employer_rep_change_status(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(
        Loanmanagementsystem.Accounts.get_user!(params["user_id"]),
        Map.merge(params, %{"status" => params["status"]})
      )
    )
    |> Ecto.Multi.run(:activate_user_role, fn _repo, %{activate_user: _activate_user} ->
      user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["user_id"])
      UserRole.changeset(user_role, %{
        status: params["status"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _,%{activate_user: _activate_user,activate_user_role: _activate_user_role} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "#{params["status"]}ED User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "User #{params["status"]}ED successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end



  def merchant_maintenance(conn, _params) do
    companies = Loanmanagementsystem.Companies.list_all_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "add_merchant.html", companies: companies, departments: departments, banks: banks, town: town, province: province)
  end

  def view_employer_details(conn, %{"userid" => userid}) do
    employer_doc = Loanmanagementsystem.Operations.get_employer_docs(userid)
    companies = Loanmanagementsystem.Operations.get_company_by_id(userid)
    render(conn, "view_employer.html", companies: companies, employer_doc: employer_doc)
  end

  def display_pdf(conn, %{"path" => path}), do: send_file( put_resp_header(conn, "content-type", "application/pdf"), 200, path)

  def create_employer_maintenance(conn, params) do
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
                  password = LoanmanagementsystemWeb.UserController.random_string
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
                              otp: add_user.otp
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
                          |> Ecto.Multi.run(:add_company, fn _repo, %{add_user: _add_user, add_user_bio_data: add_user_bio_data} ->
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
                              createdByUserId: conn.assigns.user.id,
                              createdByUserRoleId: conn.assigns.user.role_id,
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
                              userId: add_user.id,
                              year_at_current_address: params["year_at_current_address"]
                            })
                            |> Repo.insert()
                          end)

                          |> Ecto.Multi.run(:sms, fn _, %{add_user_bio_data: add_user_bio_data, add_user: add_user} ->
                            sms = %{
                              mobile: add_user_bio_data.mobileNumber,
                              msg:
                              "Hello #{params["firstName"]}, Your login credentials are as follows, and the Company has been created. Password: #{password}, OTP: #{add_user.otp}, username: #{params["emailAddress"]}.",
                              status: "READY",
                              type: "SMS",
                              msg_count: "1"
                            }

                            Sms.changeset(%Sms{}, sms)
                            |> Repo.insert()
                          end)

                          |> Ecto.Multi.run(:user_logs, fn _repo,%{add_user_role: add_user_role, add_company: _add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
                            UserLogs.changeset(%UserLogs{}, %{
                              activity: "Added #{add_user_role.roleType} Successfully",
                              user_id: conn.assigns.user.id
                            })
                            |> Repo.insert()
                          end)
                          |> Ecto.Multi.run(:document, fn _repo, %{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
                            Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => add_company.id})
                          end)
                          |> Repo.transaction()
                          |> case do
                            {:ok, %{add_user_role: add_user_role, add_company: _add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, user_logs: _user_logs, document: _document}} ->
                              Email.send_email(params["emailAddress"], params["password"], params["firstName"])

                              conn
                              |> put_flash(:info, "You Have Successfully added #{add_user_role.roleType}")
                              |> redirect(to: Routes.offtaker_management_path(conn, :employer_maintenance))

                            {:error, _failed_operation, failed_value, _changes_so_far} ->
                              reason = traverse_errors(failed_value.errors) |> List.first()

                              conn
                              |> put_flash(:error, reason)
                              |> redirect(to: Routes.offtaker_management_path(conn, :add_employer))
                          end
                        _ ->
                          conn
                          |> put_flash(:error, "Corporate with registration number #{comp_identification_no} already exists")
                          |> redirect(to: Routes.offtaker_management_path(conn, :add_employer))
                    end
                      _ ->
                        conn
                        |> put_flash(:error, "Corporate with phone number #{comp_mobile_line} already exists")
                        |> redirect(to: Routes.offtaker_management_path(conn, :add_employer))
                  end
          _ ->
            conn
            |> put_flash(:error, "Corporate with email address #{comp_email_address} already exists")
            |> redirect(to: Routes.offtaker_management_path(conn, :add_employer))
      end
  end

  def create_merchant_maintenance(conn, params) do

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
                  idNo: nil,
                  bank_account_number: params["bank_account_number"],
                  marital_status: params["marital_status"],
                  nationality: params["nationality"],
                  number_of_dependants: params["number_of_dependants"],
                  disability_status: params["disability_status"],
                  disability_detail: params["disability_detail"],
                  # applicant_declaration: params["applicant_declaration"],
                  # applicant_signature_image: params["applicant_signature_image"]
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
                  file_path = File.cwd! <> "/priv/static/codes/qr_code/#{file_name}"
                  _qrpath =
                    barcodeval
                    |> QRCode.create(:low)
                    |> Result.and_then(&QRCode.Svg.save_as(&1, File.cwd! <> "/priv/static/codes/qr_code/#{file_name}", settings))

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

                  Loanmanagementsystem.Merchants.Merchant.changeset(%Loanmanagementsystem.Merchants.Merchant{}, merchant)
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

              |> Ecto.Multi.run(:user_logs, fn _repo, %{ add_user: add_user, add_user_role: _add_user_role, add_user_bio_data: add_user_bio_data, update_merchant: _update_merchant, merchant_account: _merchant_account, merchant_director: _merchant_director, client_document: _client_document } ->
                UserLogs.changeset(%UserLogs{}, %{
                  activity: "OTP Successfully Sent to #{add_user_bio_data.mobileNumber}",
                  user_id: add_user.id
                })
                |> Repo.insert()
              end)

              |> Repo.transaction()
              |> case do
                # {:ok, _} ->
                {:ok, add_user: add_user} ->
                  Loanmanagementsystem.Workers.Sms.send()
                  Email.send_email(params["emailAddress"], password, params["companyName"])

                  conn
                  |> put_flash(:info, "You have successfuly created the user #{add_user.username}")
                  |> redirect(to: Routes.page_path(conn, :index))

                {:error, _failed_operations, failed_value, _changes_so_far} ->
                  reason = traverse_errors(failed_value.errors)

                  conn
                  |> put_flash(:error, reason)
                  |> redirect(to: Routes.client_management_path(conn, :merchant_maintenance))
              end
              _ ->
              conn
              |> put_flash(:error, "User Already Exists")
              |> redirect(to: Routes.client_management_path(conn, :merchant_maintenance))
            end
          _ ->
          conn
          |> put_flash(:error, "Merchant with email address #{get_comp_email_address} already exists")
          |> redirect(to: Routes.client_management_path(conn, :merchant_maintenance))
        end
      _ ->
      conn
      |> put_flash(:error, "Merchant with phone number #{get_comp_mobile_line} already exists")
      |> redirect(to: Routes.client_management_path(conn, :merchant_maintenance))
      end
    _ ->
      conn
      |> put_flash(:error, "Corporate with registration number #{get_comp_identification_no} already exists")
      |> redirect(to: Routes.client_management_path(conn, :merchant_maintenance))
    end
  end

  def edit_merchant_maintenance(conn, params) do
    IO.inspect(params["user_id_merchant"], label: "ppppppppppppppppppppppppppppppppppppppppppppppp")
    user_id = params["user_id_merchant"]

    userbiodate = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["user_id_merchant"])

    update_merchant = Merchants.get_merchant_by_userId(user_id)

    address_details = Loanmanagementsystem.Accounts.get_address__details_by_userId(params["user_id_merchant"])

    update_merchant_director = Loanmanagementsystem.Accounts.get_address__details_by_userId(params["user_id_merchant"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_userbiodate,
    UserBioData.changeset(userbiodate, %{

      firstName: params["firstName"],
      lastName: params["lastName"],
      mobileNumber: params["mobileNumber"],
      dateOfBirth: params["dateOfBirth"],
      emailAddress: params["emailAddress"],
      gender: params["gender"],
      meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
      meansOfIdentificationType: params["meansOfIdentificationType"],
      otherName: params["otherName"],
      title: params["title"],
      bank_account_number: params["bank_account_number"],
      marital_status: params["marital_status"],
      nationality: params["nationality"],
      number_of_dependants: params["number_of_dependants"],
      disability_status: params["disability_status"],
      disability_detail: params["disability_detail"],

    }))

    |> Ecto.Multi.run(:update_merchant, fn _repo, %{update_userbiodate: _update_userbiodate} ->
      Merchant.changeset(update_merchant, %{

        companyAccountNumber: params["companyAccountNumber"],
        companyName: params["companyName"],
        companyPhone: params["companyPhone"],
        companyRegistrationDate: params["companyRegistrationDate"],
        contactEmail: params["contactEmail"],
        registrationNumber: params["registrationNumber"],
        merchantType: params["merchantType"],
        businessName: params["businessName"],
        taxno: params["taxno"],

      })
      |> Repo.update()
    end)

    |> Ecto.Multi.run(:update_merchant_director, fn _repo, %{update_userbiodate: _update_userbiodate, update_merchant: _update_merchant} ->
      Merchant_director.changeset(update_merchant_director, %{

        firstName: params["dr_firstName"],
        lastName: params["dr_lastName"],
        mobileNumber: params["dr_mobileNumber"],
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
        merchantType: params["merchantType"],
        businessNature: params["businessNature"]
      })
      |> Repo.update()
    end)

    |> Ecto.Multi.run(:update_address_details, fn _repo, %{ update_userbiodate: _update_userbiodate, update_merchant: _update_merchant, update_merchant_director: _update_merchant_director} ->
      Address_Details.changeset(address_details, %{

        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        province: params["province"],
        year_at_current_address: params["year_at_current_address"]
      })
      |> Repo.update()
    end)

    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_userbiodate: _update_userbiodate, update_merchant: update_merchant, update_merchant_director: _update_merchant_director, update_address_details: _update_address_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have successfully updated merchant #{update_merchant.companyName}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, update_userbiodate: _update_userbiodate, update_merchant: update_merchant, update_merchant_director: _update_merchant_director, update_address_details: _update_address_details} ->
        conn
        |> put_flash(:info, "You have successfully updated merchant #{update_merchant.companyName}")
        |> redirect(to: Routes.client_management_path(conn, :merchant_maintenance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :merchant_maintenance))
    end
  end

  def edit_company_offtaker(conn, params) do

    update_company = Loanmanagementsystem.Companies.get_company!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_company,
      Company.changeset(update_company, %{
        companyName: params["companyName"],
        companyAccountNumber: params["companyAccountNumber"],
        registrationNumber: params["registrationNumber"],
        taxno: params["taxno"],
        companyPhone: params["companyPhone"],
        contactEmail: params["contactEmail"],
        registrationDate: params["registrationDate"]
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_company: _update_company} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated Company Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _msg} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the Company")
        |> redirect(to: Routes.offtaker_management_path(conn, :offtaker_maintenance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :offtaker_maintenance))
    end
  end

  def edit_company_sme(conn, params) do

    update_company = Loanmanagementsystem.Companies.get_company!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_company,
      Company.changeset(update_company, %{
        companyName: params["companyName"],
        companyAccountNumber: params["companyAccountNumber"],
        registrationNumber: params["registrationNumber"],
        taxno: params["taxno"],
        companyPhone: params["companyPhone"],
        contactEmail: params["contactEmail"],
        registrationDate: params["registrationDate"]
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_company: _update_company} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated Company Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _msg} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the Company")
        |> redirect(to: Routes.offtaker_management_path(conn, :sme_maintenance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :sme_maintenance))
    end
  end

  def edit_company_employer(conn, params) do

    update_company = Loanmanagementsystem.Companies.get_company!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_company,
      Company.changeset(update_company, %{
        companyName: params["companyName"],
        companyAccountNumber: params["companyAccountNumber"],
        registrationNumber: params["registrationNumber"],
        taxno: params["taxno"],
        companyPhone: params["companyPhone"],
        contactEmail: params["contactEmail"],
        registrationDate: params["registrationDate"]
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_company: _update_company} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated Company Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _msg} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the Company")
        |> redirect(to: Routes.offtaker_management_path(conn, :employer_maintenance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :employer_maintenance))
    end
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")

  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:client, :create}
      act when act in ~w(index view)a -> {:client, :view}
      act when act in ~w(update edit)a -> {:client, :edit}
      act when act in ~w(change_status)a -> {:client, :change_status}
      _ -> {:client, :unknown}
    end
  end

  # DOLBEN DEBUGING -------------------------------------------------------------######

  def add_employer(conn, _params) do
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "add_employer.html", banks: banks)
  end

  def add_sme(conn, _params) do
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "add_sme.html", banks: banks)
  end

  def sme_maintenance(conn, _params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isSme != true))
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "sme_maintenance.html", companies: companies, banks: banks)
  end

  def create_sme_maintenance(conn, params) do

    account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"
    otp = to_string(Enum.random(1111..9999))
    bank_id = String.to_integer(params["bank_id"])
    reg_number = params["registrationNumber"]

    comp_email_address = params["contactEmail"]
    comp_mobile_line = params["companyPhone"]
    comp_identification_no = params["registrationNumber"]
    get_comp_email_address = Repo.get_by(Company, contactEmail: comp_email_address)
    get_comp_mobile_line = Repo.get_by(Company, companyPhone: comp_mobile_line)
    get_comp_identification_no = Repo.get_by(Company, registrationNumber: comp_identification_no)
      case is_nil(get_comp_email_address) do
        true ->
          case is_nil(get_comp_mobile_line) do
            true ->
              case is_nil(get_comp_identification_no) do
                true ->

                        Ecto.Multi.new()
                        |> Ecto.Multi.insert(:add_user,
                          User.changeset(%User{}, %{
                            password: LoanmanagementsystemWeb.UserController.random_string,
                            status: "INACTIVE",
                            username: params["mobileNumber"],
                            auto_password: "Y",
                            pin: otp
                          })
                        )


                        |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
                          UserRole.changeset(%UserRole{}, %{
                            roleType: "SME",
                            status: "INACTIVE",
                            userId: add_user.id,
                            otp: otp
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
                            meansOfIdentificationNumber:  params["meansOfIdentificationType"],
                            meansOfIdentificationType: params["meansOfIdentificationNumber"],
                            mobileNumber: params["mobileNumber"],
                            otherName: params["otherName"],
                            title: params["title"],
                            userId: add_user.id,
                            idNo: nil
                          })
                          |> Repo.insert()
                        end)

                        |> Ecto.Multi.run(:add_company, fn _repo, %{add_user: _add_user, add_user_bio_data: add_user_bio_data} ->
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
                            createdByUserId: conn.assigns.user.id,
                            createdByUserRoleId: conn.assigns.user.role_id,
                            isEmployer: false,
                            isOfftaker: false,
                            isSme: true
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
                            userId: add_user.id,
                            year_at_current_address: params["year_at_current_address"]
                          })
                          |> Repo.insert()
                        end)

                        |> Ecto.Multi.run(:user_logs, fn _repo,%{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
                          UserLogs.changeset(%UserLogs{}, %{
                            activity: "Added an SME, Name: #{params["companyName"]}  and ID: #{add_company.id} Successfully",
                            user_id: conn.assigns.user.id
                          })
                          |> Repo.insert()
                        end)

                        |> Ecto.Multi.run(:document, fn _repo, %{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
                          Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => add_company.id})
                        end)

                        |> Repo.transaction()
                        |> case do
                          {:ok, %{add_user_role: add_user_role, add_company: _add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, user_logs: _user_logs, document: _document}} ->
                            Email.send_email(params["emailAddress"], params["password"], params["firstName"])

                            conn
                            |> put_flash(:info, "You Have Successfully added #{add_user_role.roleType}")
                            |> redirect(to: Routes.offtaker_management_path(conn, :sme_maintenance))

                          {:error, _failed_operation, failed_value, _changes_so_far} ->
                            reason = traverse_errors(failed_value.errors) |> List.first()

                            conn
                            |> put_flash(:error, reason)
                            |> redirect(to: Routes.offtaker_management_path(conn, :sme_maintenance))
                        end

                      _ ->
                        conn
                        |> put_flash(:error, "Corporate with registration number #{comp_identification_no} already exists")
                        |> redirect(to: Routes.offtaker_management_path(conn, :add_employer))
                  end
                _ ->
                  conn
                  |> put_flash(:error, "Corporate with phone number #{comp_mobile_line} already exists")
                  |> redirect(to: Routes.offtaker_management_path(conn, :add_employer))
            end
          _ ->
            conn
            |> put_flash(:error, "Corporate with email address #{comp_email_address} already exists")
            |> redirect(to: Routes.offtaker_management_path(conn, :add_employer))
      end

  end


  def add_offtaker(conn, _params) do
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "add_offtaker.html", banks: banks)
  end

  def offtaker_maintenance(conn, _params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isOfftaker != true))

    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "offtaker_maintenance.html", companies: companies, banks: banks)
  end

  def create_offtaker_maintenance(conn, params) do

    account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"
    otp = to_string(Enum.random(1111..9999))
    bank_id = String.to_integer(params["bank_id"])
    reg_number = params["registrationNumber"]
    username = params["emailAddress"]
    # role_Type = String.split(params["roleType"], "|||")
    get_username = Repo.get_by(User, username: username)
    comp_email_address = params["contactEmail"]
    comp_mobile_line = params["companyPhone"]
    comp_identification_no = params["registrationNumber"]

        case is_nil(get_username) do
          true ->

            Ecto.Multi.new()
            |> Ecto.Multi.insert(:add_user,
              User.changeset(%User{}, %{
                password: LoanmanagementsystemWeb.UserController.random_string,
                status: "INACTIVE",
                username: params["emailAddress"],
                auto_password: "Y",
                # company_id:
                pin: otp
              })
            )


            |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
              UserRole.changeset(%UserRole{}, %{
                roleType: "OFFTAKER",
                status: "INACTIVE",
                userId: add_user.id,
                otp: otp
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

            |> Ecto.Multi.run(:add_company, fn _repo, %{add_user: _add_user, add_user_bio_data: add_user_bio_data} ->
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
                createdByUserId: conn.assigns.user.id,
                createdByUserRoleId: conn.assigns.user.role_id,
                isEmployer: false,
                isOfftaker: true,
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
                userId: add_user.id,
                year_at_current_address: params["year_at_current_address"]
              })
              |> Repo.insert()
            end)

            |> Ecto.Multi.run(:user_logs, fn _repo,%{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
              UserLogs.changeset(%UserLogs{}, %{
                activity: "Added an OFFTAKER, Name: #{params["companyName"]}  and ID: #{add_company.id} Successfully",
                user_id: conn.assigns.user.id
              })
              |> Repo.insert()
            end)

            |> Ecto.Multi.run(:document, fn _repo, %{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
              Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => add_company.id})
            end)

            |> Repo.transaction()
            |> case do
              {:ok, %{add_user_role: _add_user_role, add_company: _add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, user_logs: _user_logs, document: _document}} ->
                Email.send_email(params["emailAddress"], params["password"], params["firstName"])

                conn
                |> put_flash(:info, "You Have Successfully added #{params["companyName"]} as an Off-taker")
                |> redirect(to: Routes.offtaker_management_path(conn, :offtaker_maintenance))

              {:error, _failed_operation, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors) |> List.first()

                conn
                |> put_flash(:error, reason)
                |> redirect(to: Routes.offtaker_management_path(conn, :offtaker_maintenance))
            end
          _ ->
            conn
            |> put_flash(:error, "User Already Exists")
            |> redirect(to:  Routes.offtaker_management_path(conn, :offtaker_maintenance))
          end
        end
end
