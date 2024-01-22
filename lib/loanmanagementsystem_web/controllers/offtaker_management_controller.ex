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
            :admin_create_employer_maintenance,
            :create_sme_maintenance,
            :edit_company,
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
            :get_offtaker_by_company_id,
            :change_user_status,
            :get_sme_by_company_id,
            :admin_sme_update_user,
            :offtaker_edit_maintenance,
            :offtaker_view_maintenance,
            :sme_view_maintenance,
            :sme_edit_maintenance,
            :update_offtaker_maintenance,
            :update_sme_maintenance,
            :employer_view_maintenance,
            :employer_edit_maintenance,
            :get_employer_by_company_id,
            :display_pdf,
            :cooperate_client_360_view,
          ]

		  use PipeTo.Override


  def employer_maintenance(conn, _params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isEmployer != true))

    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "employer_maintenance.html", companies: companies, banks: banks)
  end

  def admin_create_employer_maintenance(conn, params) do

    company_type_ = String.split(params["defaultSwitchRadioExample"], "|||")

    params = Map.merge(params, %{"isOfftaker" => Enum.at(company_type_, 2), "isSme" => Enum.at(company_type_, 1), "isEmployer" => Enum.at(company_type_, 0),"createdByUserId" => 1, "createdByUserRoleId" => 2, "status" => "INACTIVE", "otp" => "#{to_string(Enum.random(1111..9999))}", "bank_id" => String.to_integer(params["bank_id"]), "password" => "#{Enum.random(1_000_000_000..9_999_999_999)}"})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, %{
      companyName: params["companyName"],
      companyPhone: params["companyPhone"],
      contactEmail: params["contactEmail"],
      createdByUserId: conn.assigns.user.id,
      createdByUserRoleId: conn.assigns.user.role_id,
      isEmployer: params["isEmployer"],
      isSme: params["isSme"],
      isOfftaker: params["isOfftaker"],
      registrationNumber: params["registrationNumber"],
      status: "INACTIVE",
      taxno: params["taxno"],
      companyRegistrationDate: params["companyRegistrationDate"],
      companyAccountNumber: params["companyAccountNumber"],
      bank_id: params["bank_id"],
      area: params["area_company"],
      twon: params["town_company"],
      province: params["province"],
      employer_industry_type: params["employer_industry_type"],
      employer_office_building_name: params["employer_office_building_name"],
      employer_officer_street_name: params["street_name_company"],
      business_sector: params["business_sector"]
    }))
    |> Ecto.Multi.run(:add_user, fn _repo, %{add_company: add_company} ->
      user = %{
        password: params["password"],
        status: "INACTIVE",
        username: params["mobileNumber"],
        auto_password: "Y",
        company_id: add_company.id,
        pin: params["otp"]
      }
      case Repo.insert(User.changeset(%User{}, user)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_company: _add_company, add_user: add_user} ->
      user_role = %{
        roleType: params["roleType"],
        status: "INACTIVE",
        userId: add_user.id,
        otp: add_user.pin
      }
      case Repo.insert(UserRole.changeset(%UserRole{},user_role)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo, %{add_user_role: _add_user_role, add_company: _add_company, add_user: add_user} ->
      user_bio_data = %{
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
        idNo: nil,
        representative_1: true,
        representative_2: false
      }
      case Repo.insert(UserBioData.changeset(%UserBioData{}, user_bio_data)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:customer_balance, fn _repo, %{add_user_role: _add_user_role, add_company: _add_company, add_user: add_user} ->
      customer_balance = %{
        account_number: "accno-#{Enum.random(1_000_000_000..9_999_999_999)}",
        user_id: add_user.id
      }
      case Repo.insert(Customer_Balance.changeset(%Customer_Balance{}, customer_balance)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_user_role: _add_user_role, add_company: add_company, add_user: add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance} ->
      address_details = %{
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        company_id: add_company.id,
        year_at_current_address: params["year_at_current_address"],
        land_mark: params["land_mark"],
        userId: add_user.id,
        province: params["province"]
      }
      case Repo.insert(Address_Details.changeset(%Address_Details{}, address_details)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details_company, fn _repo, %{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance} ->
      add_address_details_company = %{
        accomodation_status: params["accomodation_status_company"],
        area: params["area_company"],
        house_number: params["house_number_company"],
        street_name: params["street_name_company"],
        town: params["town_company"],
        company_id: add_company.id,
        year_at_current_address: params["year_at_current_address_company"],
        land_mark: params["land_mark_company"],
        province: params["company_province"]
      }
      case Repo.insert(Address_Details.changeset(%Address_Details{}, add_address_details_company)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:sms, fn _repo, %{add_user_role: _add_user_role, add_company: add_company, add_user: add_user, add_user_bio_data: add_user_bio_data, customer_balance: _customer_balance} ->
      msg = "Congratulations! You've completed the registration process for #{add_company.companyName} as a company. Your company's representative can now access their account with the following login details: Username: #{add_user.username} Password: #{params["password"]}"
      message = %{
        mobile: add_user_bio_data.mobileNumber,
        msg: msg,
        status: "READY",
        type: "SMS",
        date_sent: NaiveDateTime.local_now(),
      }

      case Repo.insert(Sms.changeset(%Sms{}, message)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,%{add_user_role: add_user_role, add_company: _add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details, add_address_details_company: _add_address_details_company} ->
      user_logs = %{
        activity: "Added #{add_user_role.roleType} Successfully",
        user_id: conn.assigns.user.id
      }
      case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_user_role: add_user_role, add_company: add_company }} ->
        Email.send_email(params["emailAddress"], params["password"], params["firstName"])
        Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => add_company.id})
        conn
        |> put_flash(:info, "You Have Successfully added #{add_user_role.roleType}")
        |> redirect(to: Routes.offtaker_management_path(conn, :employer_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :employer_maintenance))
    end
  end

  def edit_company(conn, params) do
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
    provinces = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "add_employer.html", banks: banks, provinces: provinces)
  end

  def add_sme(conn, _params) do
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "add_sme.html", banks: banks)
  end

  def sme_maintenance(conn, _params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isSme != true))

    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "SME_maintenance.html", companies: companies, banks: banks)
  end

  # def create_sme_maintenance(conn, params) do
  #   account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"
  #   otp = to_string(Enum.random(1111..9999))
  #   bank_id = String.to_integer(params["bank_id"])

  #   params = Map.merge(params, %{"isEmployer" => false, "isSme" => true, "isOfftaker" => false})
  #   params = Map.merge(params, %{"createdByUserId" => conn.assigns.user.id, "createdByUserRoleId" => 2, "status" => "INACTIVE", "bank_id" => bank_id})

  #   Ecto.Multi.new()
  #   |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, params))
  #   |> Ecto.Multi.run(:add_user, fn _repo, %{add_company: add_company} ->
  #     User.changeset(%User{}, %{
  #       password: params["password"],
  #       status: "INACTIVE",
  #       username: params["mobileNumber_rep_1"],
  #       auto_password: "Y",
  #       company_id: add_company.id,
  #       pin: otp
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:add_user_2, fn _repo, %{add_company: add_company} ->
  #     User.changeset(%User{}, %{
  #       password: params["password"],
  #       status: "INACTIVE",
  #       username: params["mobileNumber_rep_2"],
  #       auto_password: "Y",
  #       company_id: add_company.id,
  #       pin: otp
  #     })
  #     |> Repo.insert()
  #   end)
  #   |>Ecto.Multi.run(:add_user_role, fn _repo, %{add_company: _add_company, add_user: add_user} ->
  #     UserRole.changeset(%UserRole{}, %{
  #       roleType: params["roleType"],
  #       status: "INACTIVE",
  #       userId: add_user.id,
  #       otp: otp
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:add_user_bio_data, fn _repo, %{add_user_role: _add_user_role, add_company: _add_company, add_user: add_user} ->
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
  #   |> Ecto.Multi.run(:customer_balance, fn _repo, %{add_user_role: _add_user_role, add_company: _add_company, add_user: add_user} ->
  #     Customer_Balance.changeset(%Customer_Balance{}, %{
  #       account_number: account_number,
  #       user_id: add_user.id
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_user_role: _add_user_role, add_company: _add_company, add_user: add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance} ->
  #     Address_Details.changeset(%Address_Details{}, %{
  #       accomodation_status: params["accomodation_status"],
  #       area: params["area"],
  #       house_number: params["house_number"],
  #       street_name: params["street_name"],
  #       town: params["town"],
  #       userId: add_user.id,
  #       year_at_current_address: params["year_at_current_address"]
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:user_logs, fn _repo,%{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
  #     UserLogs.changeset(%UserLogs{}, %{
  #       activity: "Added an SME, Name: #{params["companyName"]}  and ID: #{add_company.id} Successfully",
  #       user_id: conn.assigns.user.id
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:document, fn _repo, %{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
  #     Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => add_company.id})
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{add_user_role: add_user_role, add_company: _add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, user_logs: _user_logs, document: _document}} ->
  #       Email.send_email(params["emailAddress"], params["password"], params["firstName"])

  #       conn
  #       |> put_flash(:info, "You Have Successfully added #{add_user_role.roleType}")
  #       |> redirect(to: Routes.offtaker_management_path(conn, :sme_maintenance))

  #     {:error, _failed_operation, failed_value, _changes_so_far} ->
  #       reason = traverse_errors(failed_value.errors) |> List.first()

  #       conn
  #       |> put_flash(:error, reason)
  #       |> redirect(to: Routes.offtaker_management_path(conn, :sme_maintenance))
  #   end
  # end

  def create_sme_maintenance(conn, params) do
    role_id = get_session(conn, :current_user_role).id
    userId = get_session(conn, :current_user_role).userId
    IO.inspect(conn, label: "-----------------------")
    account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"
    account_number_2 = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"
    otp = to_string(Enum.random(1111..9999))
    bank_id = String.to_integer(params["bank_id"])
    password = LoanSavingsSystem.Workers.Resource.random_string(4)


    Ecto.Multi.new()
    |>Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, %{
      companyName: params["companyName"],
      companyPhone: params["companyPhone"],
      contactEmail: params["contactEmail"],
      createdByUserId: userId,
      createdByUserRoleId: role_id,
      isEmployer: false,
      isOfftaker: false,
      isSme: true,
      registrationNumber: params["registrationNumber"],
      status: "INACTIVE",
      taxno: params["taxno"],
      companyRegistrationDate: params["companyRegistrationDate"],
      companyAccountNumber: params["companyAccountNumber"],
      bank_id: bank_id,
    }))
    |>Ecto.Multi.run(:add_user, fn _repo, %{add_company: add_company}->
      rep_one = %{
        password: password,
        status: "INACTIVE",
        username: params["mobileNumber_rep_1"],
        pin: otp,
        auto_password: "Y",
        company_id: add_company.id,
      }
      case Repo.insert(User.changeset(%User{}, rep_one)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:add_user_2, fn _repo, %{add_company: add_company, add_user: _add_user}->
      rep_two = %{
        password: password,
        status: "INACTIVE",
        username: params["mobileNumber_rep_2"],
        pin: otp,
        auto_password: "Y",
        company_id: add_company.id,
      }
      case Repo.insert(User.changeset(%User{}, rep_two)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:user_bio_1, fn _repo, %{add_company: _add_company, add_user: add_user,add_user_2: _add_user_2 }->
      user_bio = %{
        dateOfBirth: params["dateOfBirth_rep_1"],
        emailAddress: params["emailAddress_rep_1"],
        firstName: params["firstName_rep_1"],
        gender: params["gender_rep_1"],
        lastName: params["lastName_rep_1"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber_rep_1"],
        meansOfIdentificationType: params["meansOfIdentificationType_rep_1"],
        mobileNumber: params["mobileNumber_rep_1"],
        otherName: params["otherName_rep_1"],
        title: params["title_rep_1"],
        userId: add_user.id,
        bank_id: bank_id,
        bank_account_number: account_number,
        applicant_signature_image: params[""],
        representative_1: true,
        representative_2: false,
        designation: params["designation_rep_1"],
      }
      case Repo.insert(UserBioData.changeset(%UserBioData{}, user_bio)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:user_bio_2, fn _repo, %{add_company: _add_company, add_user: _add_user,add_user_2: add_user_2,user_bio_1: _user_bio_1 }->
      user_bio_2 = %{
        dateOfBirth: params["dateOfBirth_rep_2"],
        emailAddress: params["emailAddress_rep_2"],
        firstName: params["firstName_rep_2"],
        gender: params["gender_rep_2"],
        lastName: params["lastName_rep_2"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber_rep_2"],
        meansOfIdentificationType: params["meansOfIdentificationType_rep_2"],
        mobileNumber: params["mobileNumber_rep_2"],
        otherName: params["otherName_rep_2"],
        title: params["title_rep_2"],
        userId: add_user_2.id,
        bank_id: bank_id,
        bank_account_number: account_number_2,
        applicant_signature_image: params[""],
        representative_1: false,
        representative_2: true,
        designation: params["designation_rep_2"],
      }
      case Repo.insert(UserBioData.changeset(%UserBioData{}, user_bio_2)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:add_user_role, fn _repo, %{add_company: _add_company, add_user: add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2}->
      user_role = %{
        roleType: "SME",
        status: "ACTIVE",
        userId: add_user.id,
        otp: otp,
        client_type: "SME",
      }
      case Repo.insert(UserRole.changeset(%UserRole{}, user_role)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
       end
    end)
    |>Ecto.Multi.run(:add_user_role_2, fn _repo, %{add_company: _add_company, add_user: _add_user,add_user_2: add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role}->
      user_role_2 = %{
        roleType: "SME",
        status: "ACTIVE",
        userId: add_user_2.id,
        otp: otp,
        client_type: "SME",
      }
      case Repo.insert(UserRole.changeset(%UserRole{}, user_role_2)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
       end
    end)
    |> Ecto.Multi.run(:customer_balance, fn _repo, %{add_company: _add_company, add_user: add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2} ->
      customer_balance = %{
        account_number: account_number,
        user_id: add_user.id
      }
      case Repo.insert(Customer_Balance.changeset(%Customer_Balance{}, customer_balance)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:customer_balance_2, fn _repo, %{add_company: _add_company, add_user: _add_user,add_user_2: add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance } ->
      customer_balance_2 = %{
        account_number: account_number_2,
        user_id: add_user_2.id
      }
      case Repo.insert(Customer_Balance.changeset(%Customer_Balance{}, customer_balance_2)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_company: _add_company, add_user: add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance, customer_balance_2: _customer_balance_2} ->

      address_1 = %{
        accomodation_status: params["accomodation_status_rep_1"],
        area: params["area_rep_1"],
        house_number: params["house_number_rep_1"],
        street_name: params["street_name_rep_1"],
        town: params["town_rep_1"],
        userId: add_user.id,
        year_at_current_address: params["year_at_current_address_rep_1"],
        land_mark: params["land_mark_rep_1"],
      }
      case Repo.insert(Address_Details.changeset(%Address_Details{}, address_1)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details_2, fn _repo, %{add_company: _add_company, add_user: _add_user,add_user_2: add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance, customer_balance_2: _customer_balance_2, add_address_details: _add_address_details} ->

      address_1 = %{
        accomodation_status: params["accomodation_status_rep_2"],
        area: params["area_rep_2"],
        house_number: params["house_number_rep_2"],
        street_name: params["street_name_rep_2"],
        town: params["town_rep_2"],
        userId: add_user_2.id,
        year_at_current_address: params["year_at_current_address_rep_2"],
        land_mark: params["land_mark_rep_2"],
      }
      case Repo.insert(Address_Details.changeset(%Address_Details{}, address_1)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details_company, fn _repo, %{add_company: add_company, add_user: _add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance, customer_balance_2: _customer_balance_2, add_address_details: _add_address_details} ->

      add_address_details_company = %{
        accomodation_status: params["accomodation_status_rep_2"],
        area: params["area_company"],
        house_number: params["house_number_company"],
        street_name: params["street_name_company"],
        town: params["town_company"],
        company_id: add_company.id,
        year_at_current_address: params["year_at_current_address_company"],
        land_mark: params["land_mark_company"],
      }
      case Repo.insert(Address_Details.changeset(%Address_Details{}, add_address_details_company)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,%{add_company: add_company, add_user: _add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance, customer_balance_2: _customer_balance_2 } ->
      user_logs = %{
        activity: "Added an SME, Name: #{params["companyName"]}  and ID: #{add_company.id} Successfully",
        user_id: conn.assigns.user.id
      }
      case Repo.insert(UserLogs.changeset(%UserLogs{},user_logs)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:document, fn _repo, %{add_company: add_company, add_user: _add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance, customer_balance_2: _customer_balance_2, user_logs: _user_logs} ->
      Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => add_company.id})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_user_role: add_user_role}} ->
        Email.send_email(params["emailAddress_rep_1"], password, params["firstName_rep_1"])
        Email.send_email(params["emailAddress_rep_2"], password, params["firstName_rep_2"])
        conn
        |> put_flash(:info, "You Have Successfully added #{add_user_role.roleType}")
        |> redirect(to: Routes.offtaker_management_path(conn, :sme_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :sme_maintenance))
    end

  end


  def add_offtaker(conn, _params) do
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "add_offtaker.html", banks: banks)
  end


  def get_offtaker_by_company_id(conn, params) do
    get_bio_datas = Loanmanagementsystem.Operations.get_offtaker_reps_details(params["company_id"])
    render(conn, "get_offtaker_by_company_id.html", get_bio_datas: get_bio_datas)
  end

  def get_employer_by_company_id(conn, params) do
    get_bio_datas = Loanmanagementsystem.Operations.get_employer_reps_details(params["company_id"])
    render(conn, "get_employer_by_company_id.html", get_bio_datas: get_bio_datas)
  end

  def get_sme_by_company_id(conn, params) do
    get_bio_datas = Loanmanagementsystem.Operations.get_sme_reps_details(params["company_id"])
    render(conn, "get_sme_by_company_id.html", get_bio_datas: get_bio_datas)
  end
  def offtaker_maintenance(conn, _params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isOfftaker != true))

    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "offtaker_maintenance.html", companies: companies, banks: banks)
  end


  def offtaker_edit_maintenance(conn, params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isOfftaker != true))
    representatives = Loanmanagementsystem.Operations.get_company_and_rep_details(params["company_id"])
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    documents = Loanmanagementsystem.Operations.get_documents_by_company_id(params["company_id"])
    render(conn, "offtaker_edit.html", companies: companies, banks: banks, representatives: representatives, documents: documents)
  end

  def employer_edit_maintenance(conn, params) do
    companies = Loanmanagementsystem.Operations.get_company_by_id(params["company_id"])
    representatives = Loanmanagementsystem.Operations.get_company_and_rep_details(params["company_id"])
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    documents = Loanmanagementsystem.Operations.get_documents_by_company_id(params["company_id"])
    render(conn, "employer_edit.html", companies: companies, banks: banks, representatives: representatives, documents: documents)
  end
  def offtaker_view_maintenance(conn, params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isOfftaker != true))
    representatives = Loanmanagementsystem.Operations.get_company_and_rep_details(params["company_id"])
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "offtaker_view.html", companies: companies, banks: banks, representatives: representatives)
  end

  def employer_view_maintenance(conn, params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isEmployer != true))
    representatives = Loanmanagementsystem.Operations.get_company_and_rep_details(params["company_id"])
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "employer_view.html", companies: companies, banks: banks, representatives: representatives)
  end

  def sme_view_maintenance(conn, params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isSme != true))
    representatives = Loanmanagementsystem.Operations.get_company_and_rep_details(params["company_id"])
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "sme_view.html", companies: companies, banks: banks, representatives: representatives)
  end

  def sme_edit_maintenance(conn, params) do
    companies = Loanmanagementsystem.Operations.get_company_by_id(params["company_id"])
    representatives = Loanmanagementsystem.Operations.get_company_and_rep_details(params["company_id"])
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    documents = Loanmanagementsystem.Operations.get_documents_by_company_id(params["company_id"])
    render(conn, "sme_edit.html", companies: companies, banks: banks, representatives: representatives, documents: documents)
  end
  # def create_offtaker_maintenance(conn, params) do
  #   account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"
  #   otp = to_string(Enum.random(1111..9999))
  #   bank_id = String.to_integer(params["bank_id"])

  #   params = Map.merge(params, %{"isEmployer" => false, "isSme" => false, "isOfftaker" => true})
  #   params = Map.merge(params, %{"createdByUserId" => conn.assigns.user.id, "createdByUserRoleId" => 2, "status" => "INACTIVE", "bank_id" => bank_id})

  #   Ecto.Multi.new()
  #   |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, params))
  #   |> Ecto.Multi.run(:add_user, fn _repo, %{add_company: add_company} ->
  #     User.changeset(%User{}, %{
  #       password: params["password"],
  #       status: "INACTIVE",
  #       username: params["mobileNumber"],
  #       auto_password: "Y",
  #       company_id: add_company.id,
  #       pin: otp
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_company: _add_company, add_user: add_user} ->
  #     UserRole.changeset(%UserRole{}, %{
  #       roleType: params["roleType"],
  #       status: "INACTIVE",
  #       userId: add_user.id,
  #       otp: otp
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:add_user_bio_data, fn _repo, %{add_user_role: _add_user_role, add_company: _add_company, add_user: add_user} ->
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
  #   |> Ecto.Multi.run(:customer_balance, fn _repo, %{add_user_role: _add_user_role, add_company: _add_company, add_user: add_user} ->
  #     Customer_Balance.changeset(%Customer_Balance{}, %{
  #       account_number: account_number,
  #       user_id: add_user.id
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_user_role: _add_user_role, add_company: _add_company, add_user: add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance} ->
  #     Address_Details.changeset(%Address_Details{}, %{
  #       accomodation_status: params["accomodation_status"],
  #       area: params["area"],
  #       house_number: params["house_number"],
  #       street_name: params["street_name"],
  #       town: params["town"],
  #       userId: add_user.id,
  #       year_at_current_address: params["year_at_current_address"]
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:user_logs, fn _repo,%{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
  #     UserLogs.changeset(%UserLogs{}, %{
  #       activity: "Added an OFFTAKER, Name: #{params["companyName"]}  and ID: #{add_company.id} Successfully",
  #       user_id: conn.assigns.user.id
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:document, fn _repo, %{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details} ->
  #     Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => add_company.id})
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{add_user_role: _add_user_role, add_company: _add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, user_logs: _user_logs, document: _document}} ->
  #       Email.send_email(params["emailAddress"], params["password"], params["firstName"])

  #       conn
  #       |> put_flash(:info, "You Have Successfully added #{params["companyName"]}")
  #       |> redirect(to: Routes.offtaker_management_path(conn, :offtaker_maintenance))

  #     {:error, _failed_operation, failed_value, _changes_so_far} ->
  #       reason = traverse_errors(failed_value.errors) |> List.first()

  #       conn
  #       |> put_flash(:error, reason)
  #       |> redirect(to: Routes.offtaker_management_path(conn, :offtaker_maintenance))
  #   end
  # end


  def create_offtaker_maintenance(conn, params) do
    role_id = get_session(conn, :current_user_role).id
    userId = get_session(conn, :current_user_role).userId
    IO.inspect(conn, label: "-----------------------")
    account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"
    account_number_2 = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"
    otp = to_string(Enum.random(1111..9999))
    bank_id = String.to_integer(params["bank_id"])
    password = LoanSavingsSystem.Workers.Resource.random_string(4)


    Ecto.Multi.new()
    |>Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, %{
      companyName: params["companyName"],
      companyPhone: params["companyPhone"],
      contactEmail: params["contactEmail"],
      createdByUserId: userId,
      createdByUserRoleId: role_id,
      isEmployer: false,
      isOfftaker: true,
      isSme: false,
      registrationNumber: params["registrationNumber"],
      status: "INACTIVE",
      taxno: params["taxno"],
      companyRegistrationDate: params["companyRegistrationDate"],
      companyAccountNumber: params["companyAccountNumber"],
      bank_id: bank_id,
    }))
    |>Ecto.Multi.run(:add_user, fn _repo, %{add_company: add_company}->
      rep_one = %{
        password: password,
        status: "INACTIVE",
        username: params["mobileNumber_rep_1"],
        pin: otp,
        auto_password: "Y",
        company_id: add_company.id,
      }
      case Repo.insert(User.changeset(%User{}, rep_one)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:add_user_2, fn _repo, %{add_company: add_company, add_user: _add_user}->
      rep_two = %{
        password: password,
        status: "INACTIVE",
        username: params["mobileNumber_rep_2"],
        pin: otp,
        auto_password: "Y",
        company_id: add_company.id,
      }
      case Repo.insert(User.changeset(%User{}, rep_two)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:user_bio_1, fn _repo, %{add_company: _add_company, add_user: add_user,add_user_2: _add_user_2 }->
      user_bio = %{
        dateOfBirth: params["dateOfBirth_rep_1"],
        emailAddress: params["emailAddress_rep_1"],
        firstName: params["firstName_rep_1"],
        gender: params["gender_rep_1"],
        lastName: params["lastName_rep_1"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber_rep_1"],
        meansOfIdentificationType: params["meansOfIdentificationType_rep_1"],
        mobileNumber: params["mobileNumber_rep_1"],
        otherName: params["otherName_rep_1"],
        title: params["title_rep_1"],
        userId: add_user.id,
        bank_id: bank_id,
        bank_account_number: account_number,
        applicant_signature_image: params[""],
        representative_1: true,
        representative_2: false,
      }
      case Repo.insert(UserBioData.changeset(%UserBioData{}, user_bio)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:user_bio_2, fn _repo, %{add_company: _add_company, add_user: _add_user,add_user_2: add_user_2,user_bio_1: _user_bio_1 }->
      user_bio_2 = %{
        dateOfBirth: params["dateOfBirth_rep_2"],
        emailAddress: params["emailAddress_rep_2"],
        firstName: params["firstName_rep_2"],
        gender: params["gender_rep_2"],
        lastName: params["lastName_rep_2"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber_rep_2"],
        meansOfIdentificationType: params["meansOfIdentificationType_rep_2"],
        mobileNumber: params["mobileNumber_rep_2"],
        otherName: params["otherName_rep_2"],
        title: params["title_rep_2"],
        userId: add_user_2.id,
        bank_id: bank_id,
        bank_account_number: account_number_2,
        applicant_signature_image: params[""],
        representative_1: false,
        representative_2: true,
      }
      case Repo.insert(UserBioData.changeset(%UserBioData{}, user_bio_2)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:add_user_role, fn _repo, %{add_company: _add_company, add_user: add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2}->
      user_role = %{
        roleType: "OFFTAKER",
        status: "ACTIVE",
        userId: add_user.id,
        otp: otp,
        client_type: "OFFTAKER",
      }
      case Repo.insert(UserRole.changeset(%UserRole{}, user_role)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
       end
    end)
    |>Ecto.Multi.run(:add_user_role_2, fn _repo, %{add_company: _add_company, add_user: _add_user,add_user_2: add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role}->
      user_role_2 = %{
        roleType: "OFFTAKER",
        status: "ACTIVE",
        userId: add_user_2.id,
        otp: otp,
        client_type: "OFFTAKER",
      }
      case Repo.insert(UserRole.changeset(%UserRole{}, user_role_2)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
       end
    end)
    |> Ecto.Multi.run(:customer_balance, fn _repo, %{add_company: _add_company, add_user: add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2} ->
      customer_balance = %{
        account_number: account_number,
        user_id: add_user.id
      }
      case Repo.insert(Customer_Balance.changeset(%Customer_Balance{}, customer_balance)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:customer_balance_2, fn _repo, %{add_company: _add_company, add_user: _add_user,add_user_2: add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance } ->
      customer_balance_2 = %{
        account_number: account_number_2,
        user_id: add_user_2.id
      }
      case Repo.insert(Customer_Balance.changeset(%Customer_Balance{}, customer_balance_2)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_company: _add_company, add_user: add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance, customer_balance_2: _customer_balance_2} ->

      address_1 = %{
        accomodation_status: params["accomodation_status_rep_1"],
        area: params["area_rep_1"],
        house_number: params["house_number_rep_1"],
        street_name: params["street_name_rep_1"],
        town: params["town_rep_1"],
        userId: add_user.id,
        year_at_current_address: params["year_at_current_address_rep_1"],
        land_mark: params["land_mark_rep_1"],
      }
      case Repo.insert(Address_Details.changeset(%Address_Details{}, address_1)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details_2, fn _repo, %{add_company: _add_company, add_user: _add_user,add_user_2: add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance, customer_balance_2: _customer_balance_2, add_address_details: _add_address_details} ->

      address_1 = %{
        accomodation_status: params["accomodation_status_rep_2"],
        area: params["area_rep_2"],
        house_number: params["house_number_rep_2"],
        street_name: params["street_name_rep_2"],
        town: params["town_rep_2"],
        userId: add_user_2.id,
        year_at_current_address: params["year_at_current_address_rep_2"],
        land_mark: params["land_mark_rep_2"],
      }
      case Repo.insert(Address_Details.changeset(%Address_Details{}, address_1)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details_company, fn _repo, %{add_company: add_company, add_user: _add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance, customer_balance_2: _customer_balance_2, add_address_details: _add_address_details} ->
      add_address_details_company = %{
        accomodation_status: params["accomodation_status_rep_2"],
        area: params["area_company"],
        house_number: params["house_number_company"],
        street_name: params["street_name_company"],
        town: params["town_company"],
        company_id: add_company.id,
        year_at_current_address: params["year_at_current_address_company"],
        land_mark: params["land_mark_company"],
      }
      case Repo.insert(Address_Details.changeset(%Address_Details{}, add_address_details_company)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,%{add_company: add_company, add_user: _add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance, customer_balance_2: _customer_balance_2 } ->
      user_logs = %{
        activity: "Added an SME, Name: #{params["companyName"]}  and ID: #{add_company.id} Successfully",
        user_id: conn.assigns.user.id
      }
      case Repo.insert(UserLogs.changeset(%UserLogs{},user_logs)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:document, fn _repo, %{add_company: add_company, add_user: _add_user,add_user_2: _add_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_user_role: _add_user_role, add_user_role_2: _add_user_role_2,customer_balance: _customer_balance, customer_balance_2: _customer_balance_2, user_logs: _user_logs} ->
      Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => add_company.id})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_user_role: add_user_role}} ->
        Email.send_email(params["emailAddress_rep_1"], password, params["firstName_rep_1"])
        Email.send_email(params["emailAddress_rep_2"], password, params["firstName_rep_2"])
        conn
        |> put_flash(:info, "You Have Successfully added #{add_user_role.roleType}")
        |> redirect(to: Routes.offtaker_management_path(conn, :offtaker_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :offtaker_maintenance))
    end
  end


  def change_user_status(conn, params) do

    IO.inspect(params, label: "------------------------")
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(
        Loanmanagementsystem.Accounts.get_user!(params["id"]),
        Map.merge(params, %{"status" => params["status"]})
      )
    )
    |> Ecto.Multi.run(:activate_user_role, fn _repo, %{activate_user: _activate_user} ->
      user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])

      UserRole.changeset(user_role, %{
        status: params["status"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _,
                                     %{
                                       activate_user: _activate_user,
                                       activate_user_role: _activate_user_role
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "User Status Changed Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "User Status Changed successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end



  def admin_sme_update_user(conn, params) do
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])
    user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])
    otp = to_string(Enum.random(1111..9999))

    params =
      Map.merge(params, %{
        "status" => "ACTIVE",
        "username" => params["mobileNumber"],
        "auto_password" => "N",
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_user,
      User.changeset(user, params)
    )
    |> Ecto.Multi.run(:update_user_role, fn _repo, %{update_user: _update_user} ->
      UserRole.changeset(user_role, %{

        status: "ACTIVE",
        otp: otp
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_user_bio_data, fn _repo,
                                                %{
                                                  update_user_role: _update_user_role,
                                                  update_user: _update_user
                                                } ->
      UserBioData.changeset(user_bio_data, %{
        dateOfBirth: params["dateOfBirth"],
        emailAddress: params["emailAddress"],
        firstName: params["firstName"],
        gender: params["gender"],
        lastName: params["lastName"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
        meansOfIdentificationType: params["meansOfIdentificationType"],
        mobileNumber: params["mobileNumber"],
        otherName: params["otherName"],
        title: params["title"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       update_user_role: _update_user_role,
                                       update_user: _update_user,
                                       update_user_bio_data: _update_user_bio_data
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated User Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_user: update_user}} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the User")
        |> redirect(to: Routes.offtaker_management_path(conn, :get_sme_by_company_id, company_id: update_user.company_id))

      {:error, _failed_operations, failed_value, _changes_so_far, update_user: update_user } ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :get_sme_by_company_id, company_id: update_user.company_id))
    end
  end




  def update_offtaker_maintenance(conn, params) do
    user_id_rep_1 = Loanmanagementsystem.Accounts.User.find_by(id: params["user_id_rep_1"])
    user_id_rep_2 = Loanmanagementsystem.Accounts.User.find_by(id: params["user_id_rep_2"])
    user_bio_rep_1= Loanmanagementsystem.Accounts.UserBioData.find_by(userId: params["user_id_rep_1"])
    user_bio_rep_2 = Loanmanagementsystem.Accounts.UserBioData.find_by(userId: params["user_id_rep_2"])
    user_1_address = Loanmanagementsystem.Accounts.Address_Details.find_by(userId: params["user_id_rep_1"])
    user_2_address = Loanmanagementsystem.Accounts.Address_Details.find_by(userId: params["user_id_rep_2"])
    company_details = Loanmanagementsystem.Accounts.get_company_by_id(params["company_id"])
    company_address = Loanmanagementsystem.Accounts.get_address_by_company_id(params["company_id"])


    Ecto.Multi.new()
    |>Ecto.Multi.update(:update_company, Company.changeset(company_details, %{
      companyName: params["companyName"],
      companyPhone: params["companyPhone"],
      contactEmail: params["contactEmail"],
      registrationNumber: params["registrationNumber"],
      status: "INACTIVE",
      taxno: params["taxno"],
      companyRegistrationDate: params["companyRegistrationDate"],
      companyAccountNumber: params["companyAccountNumber"],
      bank_id: params["bank_id"],
    }))
    |>Ecto.Multi.run(:update_user, fn _repo, %{update_company: _update_company}->
      rep_one = %{
        status: "INACTIVE",
        username: params["mobileNumber_rep_1"],

      }
      if user_id_rep_1 == nil do
        {:ok, "proceed"}
      else
      case Repo.update(User.changeset(user_id_rep_1, rep_one)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end
    end)
    |>Ecto.Multi.run(:update_user_2, fn _repo, %{ update_user: _update_user}->
      rep_two = %{
        status: "INACTIVE",
        username: params["mobileNumber_rep_2"],
      }
      if user_id_rep_2 == nil do
        {:ok, "proceed"}
      else
      case Repo.update(User.changeset(user_id_rep_2, rep_two)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
      end
    end)
    |>Ecto.Multi.run(:user_bio_1, fn _repo, %{update_company: _update_company, update_user_2: _update_user_2 }->
      user_bio = %{
        dateOfBirth: params["dateOfBirth_rep_1"],
        emailAddress: params["emailAddress_rep_1"],
        firstName: params["firstName_rep_1"],
        gender: params["gender_rep_1"],
        lastName: params["lastName_rep_1"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber_rep_1"],
        meansOfIdentificationType: params["meansOfIdentificationType_rep_1"],
        mobileNumber: params["mobileNumber_rep_1"],
        otherName: params["otherName_rep_1"],
        title: params["title_rep_1"],
        representative_1: true,
        representative_2: false,
      }
      if user_bio_rep_1 == nil do
        {:ok, "proceed"}
      else
      case Repo.update(UserBioData.changeset(user_bio_rep_1, user_bio)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end
    end)
    |>Ecto.Multi.run(:user_bio_2, fn _repo, %{update_company: _update_company, update_user: _update_user, user_bio_1: _user_bio_1 }->
      user_bio_2 = %{
        dateOfBirth: params["dateOfBirth_rep_2"],
        emailAddress: params["emailAddress_rep_2"],
        firstName: params["firstName_rep_2"],
        gender: params["gender_rep_2"],
        lastName: params["lastName_rep_2"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber_rep_2"],
        meansOfIdentificationType: params["meansOfIdentificationType_rep_2"],
        mobileNumber: params["mobileNumber_rep_2"],
        otherName: params["otherName_rep_2"],
        title: params["title_rep_2"],
        representative_1: false,
        representative_2: true,
      }
      if user_bio_rep_2 == nil do
        {:ok, "proceed"}
      else
      case Repo.update(UserBioData.changeset(user_bio_rep_2, user_bio_2)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
      end
    end)
    |> Ecto.Multi.run(:add_address_details, fn _repo, %{update_company: _update_company, update_user: _update_user,update_user_2: _update_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2} ->

      address_1 = %{
        accomodation_status: params["accomodation_status_rep_1"],
        area: params["area_rep_1"],
        house_number: params["house_number_rep_1"],
        street_name: params["street_name_rep_1"],
        year_at_current_address: params["year_at_current_address_rep_1"],
        land_mark: params["land_mark_rep_1"],
      }
      if user_1_address == nil do
        {:ok, "proceed"}
      else
      case Repo.update(Address_Details.changeset(user_1_address, address_1)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end
    end)
    |> Ecto.Multi.run(:add_address_details_2, fn _repo, %{update_company: _update_company, update_user: _update_user,update_user_2: _update_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_address_details: _add_address_details} ->

      address_1 = %{
        accomodation_status: params["accomodation_status_rep_2"],
        area: params["area_rep_2"],
        house_number: params["house_number_rep_2"],
        street_name: params["street_name_rep_2"],
        town: params["town_rep_2"],
        year_at_current_address: params["year_at_current_address_rep_2"],
        land_mark: params["land_mark_rep_2"],
      }
      if user_2_address == nil do
        {:ok, "proceed"}
      else
      case Repo.update(Address_Details.changeset(user_2_address, address_1)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
      end
    end)
    |> Ecto.Multi.run(:add_address_details_company, fn _repo, %{update_user: _update_user,update_user_2: _update_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_address_details: _add_address_details} ->
      add_address_details_company = %{
        accomodation_status: params["accomodation_status_rep_2"],
        area: params["area_company"],
        house_number: params["house_number_company"],
        street_name: params["street_name_company"],
        town: params["town_company"],
        year_at_current_address: params["year_at_current_address_company"],
        land_mark: params["land_mark_company"],
      }
      if company_address == nil do
        {:ok, "proceed"}
      else
      case Repo.update(Address_Details.changeset(company_address, add_address_details_company)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,%{ update_company: update_company, update_user: _update_user,update_user_2: _update_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2 } ->
      user_logs = %{
        activity: "Updated an SME, Name: #{params["companyName"]}  and ID: #{update_company.id} Successfully",
        user_id: conn.assigns.user.id
      }
      case Repo.insert(UserLogs.changeset(%UserLogs{},user_logs)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:document, fn _repo, %{update_company: update_company, update_user: _update_user,update_user_2: _update_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, user_logs: _user_logs} ->
      Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => update_company.id})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You Have Successfully Update Employer Details")
        |> redirect(to: Routes.offtaker_management_path(conn, :offtaker_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :offtaker_maintenance))
    end
  end


  def update_sme_maintenance(conn, params) do
    user_id_rep_1 = Loanmanagementsystem.Accounts.get_user_by_id(params["user_id_rep_1"])
    user_id_rep_2 = Loanmanagementsystem.Accounts.get_user_by_id(params["user_id_rep_2"])
    user_bio_rep_1= Loanmanagementsystem.Accounts.get_user_bio_by_id(params["user_id_rep_1"])
    user_bio_rep_2 = Loanmanagementsystem.Accounts.get_user_bio_by_id(params["user_id_rep_2"])
    # user_rep_1_bank = Loanmanagementsystem.Accounts.get_user_bank_by_id(user_bio_rep_1.bank_id)
    # user_rep_2_bank = Loanmanagementsystem.Accounts.get_user_bank_by_id(user_bio_rep_2.bank_id)
    user_1_address = Loanmanagementsystem.Accounts.get_address_by_id(params["user_id_rep_1"])
    user_2_address = Loanmanagementsystem.Accounts.get_address_by_id(params["user_id_rep_2"])
    company_details = Loanmanagementsystem.Accounts.get_company_by_id(params["company_id"])
    # company_bank = Loanmanagementsystem.Accounts.get_user_bank_by_id(company_details.bank_id)
    company_address = Loanmanagementsystem.Accounts.get_address_by_company_id(params["company_id"])


    Ecto.Multi.new()
    |>Ecto.Multi.update(:update_company, Company.changeset(company_details, %{
      companyName: params["companyName"],
      companyPhone: params["companyPhone"],
      contactEmail: params["contactEmail"],
      registrationNumber: params["registrationNumber"],
      status: "INACTIVE",
      taxno: params["taxno"],
      companyRegistrationDate: params["companyRegistrationDate"],
      companyAccountNumber: params["companyAccountNumber"],
      bank_id: params["bank_id"],
    }))
    |>Ecto.Multi.run(:update_user, fn _repo, %{update_company: _update_company}->
      rep_one = %{
        status: "INACTIVE",
        username: params["mobileNumber_rep_1"],

      }
      case Repo.update(User.changeset(user_id_rep_1, rep_one)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:update_user_2, fn _repo, %{ update_user: _update_user}->
      rep_two = %{
        status: "INACTIVE",
        username: params["mobileNumber_rep_2"],
      }
      case Repo.update(User.changeset(user_id_rep_2, rep_two)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:user_bio_1, fn _repo, %{update_company: _update_company, update_user_2: _update_user_2 }->
      user_bio = %{
        dateOfBirth: params["dateOfBirth_rep_1"],
        emailAddress: params["emailAddress_rep_1"],
        firstName: params["firstName_rep_1"],
        gender: params["gender_rep_1"],
        lastName: params["lastName_rep_1"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber_rep_1"],
        meansOfIdentificationType: params["meansOfIdentificationType_rep_1"],
        mobileNumber: params["mobileNumber_rep_1"],
        otherName: params["otherName_rep_1"],
        title: params["title_rep_1"],
        representative_1: true,
        representative_2: false,
        designation: params["designation_rep_1"],
      }
      case Repo.update(UserBioData.changeset(user_bio_rep_1, user_bio)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |>Ecto.Multi.run(:user_bio_2, fn _repo, %{update_company: _update_company, update_user: _update_user, user_bio_1: _user_bio_1 }->
      user_bio_2 = %{
        dateOfBirth: params["dateOfBirth_rep_2"],
        emailAddress: params["emailAddress_rep_2"],
        firstName: params["firstName_rep_2"],
        gender: params["gender_rep_2"],
        lastName: params["lastName_rep_2"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber_rep_2"],
        meansOfIdentificationType: params["meansOfIdentificationType_rep_2"],
        mobileNumber: params["mobileNumber_rep_2"],
        otherName: params["otherName_rep_2"],
        title: params["title_rep_2"],
        representative_1: false,
        representative_2: true,
        designation: params["designation_rep_2"],
      }
      case Repo.update(UserBioData.changeset(user_bio_rep_2, user_bio_2)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details, fn _repo, %{update_company: _update_company, update_user: _update_user,update_user_2: _update_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2} ->

      address_1 = %{
        accomodation_status: params["accomodation_status_rep_1"],
        area: params["area_rep_1"],
        house_number: params["house_number_rep_1"],
        street_name: params["street_name_rep_1"],
        year_at_current_address: params["year_at_current_address_rep_1"],
        land_mark: params["land_mark_rep_1"],
      }
      case Repo.update(Address_Details.changeset(user_1_address, address_1)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details_2, fn _repo, %{update_company: _update_company, update_user: _update_user,update_user_2: _update_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_address_details: _add_address_details} ->

      address_1 = %{
        accomodation_status: params["accomodation_status_rep_2"],
        area: params["area_rep_2"],
        house_number: params["house_number_rep_2"],
        street_name: params["street_name_rep_2"],
        town: params["town_rep_2"],
        year_at_current_address: params["year_at_current_address_rep_2"],
        land_mark: params["land_mark_rep_2"],
      }
      case Repo.update(Address_Details.changeset(user_2_address, address_1)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:add_address_details_company, fn _repo, %{update_user: _update_user,update_user_2: _update_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, add_address_details: _add_address_details} ->
      add_address_details_company = %{
        accomodation_status: params["accomodation_status_rep_2"],
        area: params["area_company"],
        house_number: params["house_number_company"],
        street_name: params["street_name_company"],
        town: params["town_company"],
        year_at_current_address: params["year_at_current_address_company"],
        land_mark: params["land_mark_company"],
      }
      case Repo.update(Address_Details.changeset(company_address, add_address_details_company)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,%{ update_company: update_company, update_user: _update_user,update_user_2: _update_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2 } ->
      user_logs = %{
        activity: "Updated an SME, Name: #{params["companyName"]}  and ID: #{update_company.id} Successfully",
        user_id: conn.assigns.user.id
      }
      case Repo.insert(UserLogs.changeset(%UserLogs{},user_logs)) do
        {:ok, message} -> {:ok, message}
        {:error, response} -> {:error, response}
      end
    end)
    |> Ecto.Multi.run(:document, fn _repo, %{update_company: update_company, update_user: _update_user,update_user_2: _update_user_2,user_bio_1: _user_bio_1, user_bio_2: _user_bio_2, user_logs: _user_logs} ->
      Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => update_company.id})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You Have Successfully Update SME Details")
        |> redirect(to: Routes.offtaker_management_path(conn, :sme_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :sme_maintenance))
    end
  end



  def display_pdf(conn, %{"path" => path}), do: send_file( put_resp_header(conn, "content-type", "application/pdf"), 200, path)

  def cooperate_client_360_view(conn, params) do
    userid = String.to_integer(params["company_id"])
    loan_details = Loanmanagementsystem.Loan.get_loan_by_userId_individual360view_loan_tracking(userid)
    companies = Loanmanagementsystem.Operations.get_company_by_id(params["company_id"])
    representatives = Loanmanagementsystem.Operations.get_company_and_rep_details(params["company_id"])
    documents = Loanmanagementsystem.Operations.get_documents_by_company_id(params["company_id"])
    render(conn, "client_360_view.html", loan_details: loan_details, companies: companies, representatives: representatives, documents: documents)
  end

end
