defmodule LoanmanagementsystemWeb.OfftakerManagementController do
  use LoanmanagementsystemWeb, :controller
  use Ecto.Schema
  import Ecto.Query, warn: false
  require Logger
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Emails.Email
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Logs.UserLogs
  # alias Loanmanagementsystem.Operations
  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Loan.Customer_Balance
  alias Loanmanagementsystem.Accounts.Address_Details
  # alias Loanmanagementsystem.Employment.Personal_Bank_Details
  # alias Loanmanagementsystem.Merchants.Merchant
  # alias Loanmanagementsystem.Merchants.Merchant_director
  # alias Loanmanagementsystem.Merchants.Merchants_device
  alias Loanmanagementsystem.Companies.Documents

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
            :admin_edit_employer,
            :edit_com_documents
          ]

		  use PipeTo.Override


  def employer_maintenance(conn, _params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isEmployer != true))
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "employer_maintenance.html", companies: companies, banks: banks)
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
                          Ecto.Multi.new()
                          |> Ecto.Multi.insert(:add_user,
                            User.changeset(%User{}, %{
                              password: LoanmanagementsystemWeb.UserController.random_string,
                              status: "INACTIVE",
                              username: params["emailAddress"],
                              auto_password: "Y",
                              pin: otp
                            })
                          )


                          |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
                            UserRole.changeset(%UserRole{}, %{
                              roleType: "EMPLOYER",
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
    # comp_email_address = params["contactEmail"]
    # comp_mobile_line = params["companyPhone"]
    # comp_identification_no = params["registrationNumber"]

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




    def admin_edit_employer(conn, %{"company_id" => company_id}) do
      banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
      employer_doc = Loanmanagementsystem.Operations.get_employer_docs_by_company_id(company_id)
      companies = Loanmanagementsystem.Operations.get_company_by_id(company_id)
      IO.inspect(employer_doc, label: "CHeck my DOcs")
      render(conn, "admin_edit_employer.html", banks: banks, companies: companies, employer_doc: employer_doc)
    end


    # def edit_com_documents(conn, params) do
    #   multi = Ecto.Multi.new()
    #   add_currency = Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => String.to_integer(params["company_id"])})
    #   |> Ecto.Multi.run(:user_logs, fn _repo, %{add_currency: _add_currency} ->
    #     UserLogs.changeset(%UserLogs{}, %{
    #       activity: "Add Documents Successfully",
    #       user_id: conn.assigns.user.id
    #     })
    #     |> Repo.insert()
    #   end)

    #   multi
    #   |> Repo.transaction()
    #   |> case do
    #     {:ok, %{add_currency: _add_currency, user_logs: _user_logs}} ->
    #       conn
    #       |> put_flash(:info, "You Have Successfully added a Document")
    #       |> redirect(to: Routes.offtaker_management_path(conn, :employer_maintenance))

    #     {:error, _failed_operation, failed_value, _changes_so_far} ->
    #       reason = traverse_errors(failed_value.errors) |> List.first()

    #       conn
    #       |> put_flash(:error, reason)
    #       |> redirect(to: Routes.offtaker_management_path(conn, :employer_maintenance))
    #   end
    # end


    def edit_com_documents(conn, params) do

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
      |> Ecto.Multi.run(:document, fn _repo, %{update_company: _update_company} ->
        Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => String.to_integer(params["company_id"])})
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







end
