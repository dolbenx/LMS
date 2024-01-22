defmodule LoanmanagementsystemWeb.MaintenanceController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false

  alias Loanmanagementsystem.Maintenance.{
    Currency, Country, Province, District, Security_questions, Branch, Bank, Classification}
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole}
  alias Loanmanagementsystem.Emails.Email
  # alias Loanmanagementsystem.Companies
  alias Loanmanagementsystem.Charges.Charge
  alias Loanmanagementsystem.Loan.Customer_Balance
  alias Loanmanagementsystem.SystemSetting.SystemSettings
  alias Loanmanagementsystem.Email_configs.Email_config_receiver




  plug LoanmanagementsystemWeb.Plugs.Authenticate,
        [module_callback: &LoanmanagementsystemWeb.MaintenanceController.authorize_role/1]
        when action not in [
              :add_charge,
              :admin_activate_bank,
              :admin_activate_branch,
              :admin_activate_classification,
              :admin_activate_company,
              :admin_activate_msg_config,
              :admin_add_branch,
              :admin_add_msg_configuration,
              :admin_configure_add_sms,
              :admin_configure_sms,
              :admin_configure_update_sms,
              :admin_create_company,
              :admin_create_company_offtaker,
              :admin_create_company_sme,
              :admin_create_country,
              :admin_create_currency,
              :admin_create_district,
              :admin_create_province,
              :admin_create_security_questions,
              :admin_deactivate_bank,
              :admin_deactivate_branch,
              :admin_deactivate_classification,
              :admin_deactivate_company,
              :admin_deactivate_msg_config,
              :admin_email_logs,
              :admin_maintian_message_configurations,
              :admin_sms_logs,
              :admin_update_branch,
              :admin_update_country,
              :admin_update_currency,
              :admin_update_district,
              :admin_update_msg_configuration,
              :admin_update_province,
              :admin_update_security_question,
              :admin_user_logs,
              :admin_ussd_logs,
              :bank,
              :charges,
              :classification,
              :create_bank,
              :create_classification,
              :csv,
              :currency,
              :default_dir,
              :disbursed_loans,
              :extract_xlsx,
              :handle__province_bulk_upload,
              :is_valide_file,
              :loans,
              :loans_branch,
              :outstanding_loans,
              :pending_loans,
              :persist,
              :process_bulk_upload,
              :process_csv,
              :return_off_loans,
              :security_questions,
              :self_create_company,
              :self_create_company_offtaker,
              :self_create_company_sme,
              :tracking_loans,
              :traverse_errors,
              :update_bank,
              :update_charge,
              :update_classification,
              :upload,
              :upload_documents,
              :validate_document,
              :admin_configure_email_sender,
              :admin_configure_email_receiver,
              :create_receiver_email,
              :admin_update_email_receiver,
              :create_emails_sender,
              :admin_update_emails_sender

       ]

use PipeTo.Override




  def admin_create_currency(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_currency, Currency.changeset(%Currency{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_currency: _add_currency} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Add Currency Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_currency: _add_currency, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "You Have Successfully added a currency")
        |> redirect(to: Routes.maintenance_path(conn, :currency))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :currency))
    end
  end

  def admin_create_country(conn, params) do
    IO.inspect(params, label: "ffffffffffffffffffffffffffffffffff")

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_country, Country.changeset(%Country{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_country: _add_country} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Add Country Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_country: _add_country, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "You Have Successfully added a Country")
        |> redirect(to: Routes.system_management_path(conn, :countries))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :countries))
    end
  end

  def admin_create_province(conn, params) do
    province_ = String.split(params["country"], "|||")

    params =
      Map.merge(params, %{
        "countryId" => Enum.at(province_, 0),
        "countryName" => Enum.at(province_, 1)
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_province, Province.changeset(%Province{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_province: _add_province} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Add Province Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_province: _add_province, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "You Have Successfully added a Province")
        |> redirect(to: Routes.system_management_path(conn, :province))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :province))
    end
  end

  def admin_create_district(conn, params) do
    province_ = String.split(params["province"], "|||")

    params =
      Map.merge(params, %{
        "provinceId" => Enum.at(province_, 0),
        "provinceName" => Enum.at(province_, 1)
      })

    country_ = String.split(params["country"], "|||")

    params =
      Map.merge(params, %{
        "countryId" => Enum.at(country_, 0),
        "countryName" => Enum.at(country_, 1)
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_district,
      District.changeset(%District{}, %{
        countryId: params["countryId"],
        countryName: params["countryName"],
        name: params["name"],
        provinceId: params["provinceId"],
        provinceName: params["provinceName"]
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_district: _add_district} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Added District Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_district: _add_district, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "You Have Successfully added a District")
        |> redirect(to: Routes.system_management_path(conn, :district))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :district))
    end
  end

  def admin_create_security_questions(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_security_questions,
      Security_questions.changeset(%Security_questions{}, params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_security_questions: _add_security_questions} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Added Security Questions Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_security_questions: _add_security_questions, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "You Have Successfully added Security Questions")
        |> redirect(to: Routes.maintenance_path(conn, :security_questions))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :security_questions))
    end
  end

  def admin_create_company(conn, params) do
    bank_id = String.to_integer(params["bank_id"])
    IO.inspect("DDDDDDDDDD")
    IO.inspect(params)
    IO.inspect(params["password"], label: "password is : ")
    IO.inspect("EEEEEEEEEEEE")
    account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"

    otp = to_string(Enum.random(1111..9999))

    IO.inspect(params["defaultSwitchRadioExample"])
    company_type_ = String.split(params["defaultSwitchRadioExample"], "|||")

    IO.inspect(company_type_)

    params =
      Map.merge(params, %{
        "isEmployer" => Enum.at(company_type_, 0),
        "isSme" => Enum.at(company_type_, 1),
        "isOfftaker" => Enum.at(company_type_, 2)
      })

    params =
      Map.merge(params, %{
        "createdByUserId" => 1,
        "createdByUserRoleId" => 1,
        "status" => "INACTIVE",
        "bank_id" => bank_id
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, params))
    |> Ecto.Multi.run(:add_admin_user, fn _repo, %{add_company: add_company} ->
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["mobileNumber"],
        auto_password: "Y",
        company_id: add_company.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_company: _add_company,
                                           add_admin_user: add_admin_user
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: params["roleType"],
        status: "INACTIVE",
        userId: add_admin_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                             %{
                                               add_user_role: _add_user_role,
                                               add_company: _add_company,
                                               add_admin_user: add_admin_user
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
        userId: add_admin_user.id,
        idNo: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:customer_balance, fn _repo,
                                            %{
                                              add_user_role: _add_user_role,
                                              add_company: _add_company,
                                              add_admin_user: add_admin_user
                                            } ->
      Customer_Balance.changeset(%Customer_Balance{}, %{
        account_number: account_number,
        user_id: add_admin_user.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_user_role: add_user_role,
                                       add_company: _add_company,
                                       add_admin_user: _add_admin_user,
                                       add_user_bio_data: _add_user_bio_data,
                                       customer_balance: _customer_balance
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Added #{add_user_role.roleType} Successfully",
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
         add_user_role: add_user_role,
         add_company: _add_company,
         add_admin_user: _add_admin_user,
         add_user_bio_data: add_user_bio_data,
         customer_balance: _customer_balance,
         user_logs: _user_logs
       }} ->
        Email.send_email(params["emailAddress"], params["password"], add_user_bio_data.firstName)

        conn
        |> put_flash(:info, "You Have Successfully added #{add_user_role.roleType}")
        |> redirect(to: Routes.customers_path(conn, :company))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customers_path(conn, :company))
    end
  end

  def admin_create_company_offtaker(conn, params) do
    IO.inspect("DDDDDDDDDD")
    IO.inspect(params)
    IO.inspect(params["password"], label: "password is : ")
    IO.inspect("EEEEEEEEEEEE")
    account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"
    bank_id = String.to_integer(params["bank_id"])
    otp = to_string(Enum.random(1111..9999))

    IO.inspect(params["defaultSwitchRadioExample"])
    company_type_ = String.split(params["defaultSwitchRadioExample"], "|||")

    IO.inspect(company_type_)

    params =
      Map.merge(params, %{
        "isEmployer" => Enum.at(company_type_, 0),
        "isSme" => Enum.at(company_type_, 1),
        "isOfftaker" => Enum.at(company_type_, 2)
      })

    params =
      Map.merge(params, %{
        "createdByUserId" => 1,
        "createdByUserRoleId" => 1,
        "status" => "INACTIVE",
        "bank_id" => bank_id
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, params))
    |> Ecto.Multi.run(:add_admin_user, fn _repo, %{add_company: add_company} ->
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["mobileNumber"],
        auto_password: "Y",
        company_id: add_company.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_company: _add_company,
                                           add_admin_user: add_admin_user
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: params["roleType"],
        status: "INACTIVE",
        userId: add_admin_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                             %{
                                               add_user_role: _add_user_role,
                                               add_company: _add_company,
                                               add_admin_user: add_admin_user
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
        userId: add_admin_user.id,
        idNo: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:customer_balance, fn _repo,
                                            %{
                                              add_user_role: _add_user_role,
                                              add_company: _add_company,
                                              add_admin_user: add_admin_user
                                            } ->
      Customer_Balance.changeset(%Customer_Balance{}, %{
        account_number: account_number,
        user_id: add_admin_user.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_user_role: add_user_role,
                                       add_company: _add_company,
                                       add_admin_user: _add_admin_user,
                                       add_user_bio_data: _add_user_bio_data,
                                       customer_balance: _customer_balance
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Added #{add_user_role.roleType} Successfully",
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
         add_user_role: add_user_role,
         add_company: _add_company,
         add_admin_user: _add_admin_user,
         add_user_bio_data: add_user_bio_data,
         customer_balance: _customer_balance,
         user_logs: _user_logs
       }} ->
        Email.send_email(params["emailAddress"], params["password"], add_user_bio_data.firstName)

        conn
        |> put_flash(:info, "You Have Successfully added #{add_user_role.roleType}")
        |> redirect(to: Routes.customers_path(conn, :offtaker))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customers_path(conn, :offtaker))
    end
  end

  def admin_create_company_sme(conn, params) do
    IO.inspect("DDDDDDDDDD")
    IO.inspect(params)
    IO.inspect(params["password"], label: "password is : ")
    IO.inspect("EEEEEEEEEEEE")
    account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"

    otp = to_string(Enum.random(1111..9999))
    bank_id = String.to_integer(params["bank_id"])
    IO.inspect(params["defaultSwitchRadioExample"])
    company_type_ = String.split(params["defaultSwitchRadioExample"], "|||")

    IO.inspect(company_type_)

    params =
      Map.merge(params, %{
        "isEmployer" => Enum.at(company_type_, 0),
        "isSme" => Enum.at(company_type_, 1),
        "isOfftaker" => Enum.at(company_type_, 2)
      })

    params =
      Map.merge(params, %{
        "createdByUserId" => 1,
        "createdByUserRoleId" => 1,
        "status" => "INACTIVE",
        "bank_id" => bank_id
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, params))
    |> Ecto.Multi.run(:add_admin_user, fn _repo, %{add_company: add_company} ->
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["mobileNumber"],
        auto_password: "Y",
        company_id: add_company.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_company: _add_company,
                                           add_admin_user: add_admin_user
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: params["roleType"],
        status: "INACTIVE",
        userId: add_admin_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                             %{
                                               add_user_role: _add_user_role,
                                               add_company: _add_company,
                                               add_admin_user: add_admin_user
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
        userId: add_admin_user.id,
        idNo: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:customer_balance, fn _repo,
                                            %{
                                              add_user_role: _add_user_role,
                                              add_company: _add_company,
                                              add_admin_user: add_admin_user
                                            } ->
      Customer_Balance.changeset(%Customer_Balance{}, %{
        account_number: account_number,
        user_id: add_admin_user.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_user_role: add_user_role,
                                       add_company: _add_company,
                                       add_admin_user: _add_admin_user,
                                       add_user_bio_data: _add_user_bio_data,
                                       customer_balance: _customer_balance
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Added #{add_user_role.roleType} Successfully",
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
         add_user_role: add_user_role,
         add_company: _add_company,
         add_admin_user: _add_admin_user,
         add_user_bio_data: add_user_bio_data,
         customer_balance: _customer_balance,
         user_logs: _user_logs
       }} ->
        Email.send_email(params["emailAddress"], params["password"], add_user_bio_data.firstName)

        conn
        |> put_flash(:info, "You Have Successfully added #{add_user_role.roleType}")
        |> redirect(to: Routes.customers_path(conn, :smes))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customers_path(conn, :smes))
    end
  end

  def self_create_company_offtaker(conn, params) do
    IO.inspect("DDDDDDDDDD ghjkdghdbhbdhdb")
    IO.inspect(params)

    IO.inspect("EEEEEEEEEEEE")

    otp = to_string(Enum.random(1111..9999))

    IO.inspect(params["defaultSwitchRadioExample"])
    company_type_ = String.split(params["defaultSwitchRadioExample"], "|||")

    IO.inspect(company_type_)

    params =
      Map.merge(params, %{
        "isEmployer" => Enum.at(company_type_, 0),
        "isSme" => Enum.at(company_type_, 1),
        "isOfftaker" => Enum.at(company_type_, 2)
      })

    params =
      Map.merge(params, %{
        "createdByUserId" => 1,
        "createdByUserRoleId" => 1,
        "status" => "INACTIVE"
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, params))
    |> Ecto.Multi.run(:add_admin_user, fn _repo, %{add_company: add_company} ->
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y",
        company_id: add_company.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_company: _add_company,
                                           add_admin_user: add_admin_user
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: params["roleType"],
        status: "INACTIVE",
        userId: add_admin_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                             %{
                                               add_user_role: _add_user_role,
                                               add_company: _add_company,
                                               add_admin_user: add_admin_user
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
        userId: add_admin_user.id,
        idNo: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_user_role: _add_user_role,
                                       add_company: _add_company,
                                       add_admin_user: add_admin_user,
                                       add_user_bio_data: _add_user_bio_data
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "OffTaker Self Registration Successfully Done",
        user_id: add_admin_user.id
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
         add_user_role: _add_user_role,
         add_company: _add_company,
         add_admin_user: _add_admin_user,
         add_user_bio_data: _add_user_bio_data,
         user_logs: _user_logs
       }} ->

        conn
        |> put_flash(:info, "You Have Successfully Created Your Company As an OffTaker")
        |> redirect(to: Routes.session_path(conn, :username))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.session_path(conn, :username))
    end
  end

  def self_create_company_sme(conn, params) do
    IO.inspect("DDDDDDDDDD ghjkdghdbhbdhdb")
    IO.inspect(params)
    IO.inspect(params["password"], label: "password is : ")
    IO.inspect("EEEEEEEEEEEE")

    otp = to_string(Enum.random(1111..9999))

    IO.inspect(params["defaultSwitchRadioExample"])
    company_type_ = String.split(params["defaultSwitchRadioExample"], "|||")

    IO.inspect(company_type_)

    params =
      Map.merge(params, %{
        "isEmployer" => Enum.at(company_type_, 0),
        "isSme" => Enum.at(company_type_, 1),
        "isOfftaker" => Enum.at(company_type_, 2)
      })

    params =
      Map.merge(params, %{
        "createdByUserId" => 1,
        "createdByUserRoleId" => 1,
        "status" => "INACTIVE"
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, params))
    |> Ecto.Multi.run(:add_admin_user, fn _repo, %{add_company: add_company} ->
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y",
        company_id: add_company.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_company: _add_company,
                                           add_admin_user: add_admin_user
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: params["roleType"],
        status: "INACTIVE",
        userId: add_admin_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                             %{
                                               add_user_role: _add_user_role,
                                               add_company: _add_company,
                                               add_admin_user: add_admin_user
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
        userId: add_admin_user.id,
        idNo: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_user_role: _add_user_role,
                                       add_company: _add_company,
                                       add_admin_user: add_admin_user,
                                       add_user_bio_data: _add_user_bio_data
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "SME Self Registration Successfully Dobe",
        user_id: add_admin_user.id
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
         add_user_role: _add_user_role,
         add_company: _add_company,
         add_admin_user: _add_admin_user,
         add_user_bio_data: _add_user_bio_data,
         user_logs: _user_logs
       }} ->

        conn
        |> put_flash(:info, "You Have Successfully Created Your Company as An SME")
        |> redirect(to: Routes.session_path(conn, :username))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.session_path(conn, :username))
    end
  end

  def self_create_company(conn, params) do
    IO.inspect("DDDDDDDDDD ghjkdghdbhbdhdb")
    IO.inspect(params)
    IO.inspect("EEEEEEEEEEEE")

    otp = to_string(Enum.random(1111..9999))

    IO.inspect(params["defaultSwitchRadioExample"])
    company_type_ = String.split(params["defaultSwitchRadioExample"], "|||")

    IO.inspect(company_type_)

    params =
      Map.merge(params, %{
        "isEmployer" => Enum.at(company_type_, 0),
        "isSme" => Enum.at(company_type_, 1),
        "isOfftaker" => Enum.at(company_type_, 2)
      })

    params =
      Map.merge(params, %{
        "createdByUserId" => 1,
        "createdByUserRoleId" => 1,
        "status" => "INACTIVE"
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, params))
    |> Ecto.Multi.run(:add_admin_user, fn _repo, %{add_company: add_company} ->
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y",
        company_id: add_company.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_company: _add_company,
                                           add_admin_user: add_admin_user
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: params["roleType"],
        status: "INACTIVE",
        userId: add_admin_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                             %{
                                               add_user_role: _add_user_role,
                                               add_company: _add_company,
                                               add_admin_user: add_admin_user
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
        userId: add_admin_user.id,
        idNo: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_user_role: _add_user_role,
                                       add_company: _add_company,
                                       add_admin_user: add_admin_user,
                                       add_user_bio_data: _add_user_bio_data
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Company Self Registration Successful",
        user_id: add_admin_user.id
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
         add_user_role: _add_user_role,
         add_company: _add_company,
         add_admin_user: _add_admin_user,
         add_user_bio_data: _add_user_bio_data,
         user_logs: _user_logs
       }} ->

        conn
        |> put_flash(:info, "You Have Successfully Created Your Company")
        |> redirect(to: Routes.session_path(conn, :username))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.session_path(conn, :username))
    end
  end

  alias Loanmanagementsystem.Companies.Paths
  alias Loanmanagementsystem.Companies.Documents

  def upload_documents(company, docx) do
    path = Repo.one(from m in Paths, where: m.name == ^"COMPANY")

    case path != nil do
      true ->
        with {_ok, doc} <- validate_document(docx) do
          Ecto.Multi.new()
          |> Ecto.Multi.insert(
            :docx,
            Documents.changeset(%Documents{}, %{
              company_id: company.id,
              name: "#{company.id}#{docx.filename}",
              path_id: path.id
            })
          )
          |> Ecto.Multi.run(:upload, fn _REPO, %{docx: _docx} ->
            upload(path.path, doc, company.id)
          end)
          |> Repo.transaction()
          |> case do
            {:ok, %{docx: _docx}} ->
              {:ok, "successfully inserted and uploaded documents"}

            {:error, _failed_operation, failed_value, _changes_so_far} ->
              File.rm("#{path.path}/#{company.id}#{docx.filename}")
              {:error, %{errors: traverse_errors(failed_value.errors) |> List.first()}}
          end
        else
          {:error, msg} -> {:error, %{errors: msg}}
        end

      false ->
        {:error, %{errors: "Failed to upload documents kindly contact the system administrator"}}
    end
  end

  def validate_document(docx) do
    with true <- Enum.member?([".PDF", ".Pdf", ".pdf"], Path.extname(docx.filename)) do
      {:ok, docx}
    else
      false ->
        {:error, "Kindly upload a \"PDF\" document or convert the one you have to \"PDF\" "}
    end
  end

  def upload(path, doc, company_id) do
    with :ok <- File.cp(doc.path, "#{path}/#{company_id}#{doc.filename}") do
      {:ok, "success"}
    else
      _ANYTHING_ELSE -> {:error, %{errors: "Failed to upload documents"}}
    end
  end

  def loans(conn, _params),
    do: render(conn, "loans.html", loans: Loanmanagementsystem.Loan.get_all_loans())

  def pending_loans(conn, _params), do: render(conn, "pending_loans.html")
  def tracking_loans(conn, _params), do: render(conn, "tracking_loans.html")
  def disbursed_loans(conn, _params), do: render(conn, "disbursed_loans.html")

  @spec outstanding_loans(Plug.Conn.t(), any) :: Plug.Conn.t()
  def outstanding_loans(conn, _params), do: render(conn, "outstanding_loans.html")

  def return_off_loans(conn, _params), do: render(conn, "return_off_loans.html")

  def add_charge(conn, params) do
    # host = conn.host
    # query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: (cl.domain== ^host), select: cl
    # clientTelco = Repo.one(query);

    IO.inspect(params["currency"])
    currency_ = String.split(params["currency"], "|||")

    IO.inspect(currency_)

    params =
      Map.merge(params, %{
        "currency" => Enum.at(currency_, 1),
        "currencyId" => Enum.at(currency_, 0)
      })

    IO.inspect(params)
    chargeChangeSet = Charge.changeset(%Charge{}, params)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:charges, chargeChangeSet)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{charges: charges} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Created new Charges with ID \"#{charges.id}\"",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Charge Created successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :charges))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :charges))
    end

    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end

  def update_charge(conn, params) do
    charges = Loanmanagementsystem.Charges.get_charge!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:charges, Charge.changeset(charges, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{charges: charges} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "updated  Charges with ID \"#{charges.id}\"",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{charges: _charges, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Charge updated successfully")
        |> redirect(to: Routes.maintenance_path(conn, :charges))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :charges))
    end
  end

  alias Loanmanagementsystem.Maintenance.Message_Management

  def admin_maintian_message_configurations(conn, _params),
    do:
      render(conn, "message_configurations.html",
        msg_configs: Loanmanagementsystem.Maintenance.list_tbl_msg_mgt()
      )

  def admin_add_msg_configuration(conn, params) do
    params = Map.merge(params, %{"status" => "INACTIVE"})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_msg_config,
      Message_Management.changeset(%Message_Management{}, params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_msg_config: add_msg_config} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Successfully Added Message Configuration #{add_msg_config.msg_type}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_msg_config: add_msg_config}} ->
        conn
        |> put_flash(:info, "You Have Succefully Added #{add_msg_config.msg_type}")
        |> redirect(to: Routes.maintenance_path(conn, :admin_maintian_message_configurations))

      {:error, _faile_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :admin_maintian_message_configurations))
    end
  end

  def admin_update_msg_configuration(conn, params) do
    param = Loanmanagementsystem.Maintenance.get_message__management!(params["id"])
    params = Map.merge(params, %{"status" => "INACTIVE"})

    Ecto.Multi.new()
    |> Ecto.Multi.update(:add_msg_config, Message_Management.changeset(param, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_msg_config: add_msg_config} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Successfully Update Message Configuration #{add_msg_config.msg_type}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_msg_config: add_msg_config}} ->
        conn
        |> put_flash(:info, "You Have Succefully Update #{add_msg_config.msg_type}")
        |> redirect(to: Routes.maintenance_path(conn, :admin_maintian_message_configurations))

      {:error, _faile_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :admin_maintian_message_configurations))
    end
  end

  def charges(conn, _params),
    do:
      render(conn, "charges.html",
        currencies: Loanmanagementsystem.Maintenance.list_tbl_currency(),
        charges: Loanmanagementsystem.Charges.list_tbl_charges()
      )

  def loans_branch(conn, _params) do
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()

    province = Loanmanagementsystem.Maintenance.list_tbl_province()

    city = Loanmanagementsystem.Maintenance.list_tbl_district()

    render(conn, "loans_branch.html", branches: branches, province: province, city: city)
  end

  def admin_add_branch(conn, params) do
    params = Map.merge(params, %{"status" => "ACTIVE"})
    params = Map.merge(params, %{"created_by" => conn.assigns.user.id})
    # params = Map.merge(params, %{"status" => "INACTIVE"})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:branches, Branch.changeset(%Branch{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{branches: branches} ->
      activity = "Created new Branch with ID \"#{branches.id}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{branches: branches, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "#{branches.branchName} Created successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :loans_branch))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :loans_branch))
    end
  end

  def admin_update_branch(conn, params) do
    branch = Loanmanagementsystem.Maintenance.get_branch!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_branches, Branch.changeset(branch, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{update_branches: update_branches} ->
      activity = "Updated Branch with ID \"#{update_branches.id}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_branches: _update_branches, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Branch Update successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :loans_branch))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :loans_branch))
    end
  end

  def admin_user_logs(conn, _params), do: render(conn, "admin_user_logs.html")

  def admin_ussd_logs(conn, _params), do: render(conn, "admin_ussd_logs.html")

  def admin_email_logs(conn, _params), do: render(conn, "admin_email_logs.html")

  def admin_sms_logs(conn, _params), do: render(conn, "admin_sms_logs.html")

  def currency(conn, _params),
    do:
      render(conn, "currency.html",
        currencies: Loanmanagementsystem.Services.Services.get_all_currencies(),
        countries: Loanmanagementsystem.Maintenance.list_tbl_country()
      )

  def security_questions(conn, _params),
    do:
      render(conn, "security_questions.html",
        security_questions: Loanmanagementsystem.Maintenance.list_tbl_security_questions()
      )

  def bank(conn, _params),
    do:
      render(conn, "banks.html",
        branches: Loanmanagementsystem.Maintenance.list_tbl_branch(),
        banks: Loanmanagementsystem.Maintenance.list_tbl_banks()
      )

  def classification(conn, _params),
    do:
      render(conn, "classification.html",
        classifications: Loanmanagementsystem.Maintenance.list_tbl_classification()
      )

  def create_bank(conn, params) do
    company_type_ = String.split(params["process_branch"], "|||")

    params =
      Map.merge(params, %{
        "center_code" => Enum.at(company_type_, 0),
        "process_branch" => Enum.at(company_type_, 1)
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_bank, Bank.changeset(%Bank{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_bank: add_bank} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have successfully Added #{add_bank.bankName} bank",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_bank: add_bank}} ->
        conn
        |> put_flash(:info, "You have successfully added #{add_bank.bankName} Bank")
        |> redirect(to: Routes.maintenance_path(conn, :bank))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :bank))
    end
  end

  def update_bank(conn, params) do
    bamk = Loanmanagementsystem.Maintenance.get_bank!(params["id"])
    company_type_ = String.split(params["process_branch"], "|||")

    params =
      Map.merge(params, %{
        "center_code" => Enum.at(company_type_, 0),
        "process_branch" => Enum.at(company_type_, 1)
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_bank, Bank.changeset(bamk, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_bank: update_bank} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have successfully Upadated #{update_bank.bankName} bank",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_bank: update_bank}} ->
        conn
        |> put_flash(:info, "You have successfully Upadated #{update_bank.bankName} Bank")
        |> redirect(to: Routes.maintenance_path(conn, :bank))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :bank))
    end
  end

  def create_classification(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_classification, Classification.changeset(%Classification{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_classification: _add_classification} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have successfully added a classification",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have successfully added a Classification")
        |> redirect(to: Routes.maintenance_path(conn, :classification))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :classification))
    end
  end

  def update_classification(conn, params) do
    classification = Loanmanagementsystem.Maintenance.get_classification!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:upload_classification, Classification.changeset(classification, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{upload_classification: upload_classification} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "You have successfully Updated #{upload_classification.classifcation}  classification",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{upload_classification: upload_classification}} ->
        conn
        |> put_flash(
          :info,
          "You have successfully Updated #{upload_classification.classifcation} Classification"
        )
        |> redirect(to: Routes.maintenance_path(conn, :classification))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :classification))
    end
  end

  def admin_update_country(conn, params) do
    country = Loanmanagementsystem.Maintenance.get_country!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_country, Country.changeset(country, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_country: _update_country} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Updated A Country",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Added a Country")
        |> redirect(to: Routes.system_management_path(conn, :countries))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :countries))
    end
  end

  def admin_update_province(conn, params) do
    province = Loanmanagementsystem.Maintenance.get_province!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_province, Province.changeset(province, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_province: _update_province} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Updated A Province",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Added a Province")
        |> redirect(to: Routes.system_management_path(conn, :province))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :province))
    end
  end

  def admin_update_currency(conn, params) do
    currency = Loanmanagementsystem.Maintenance.get_currency!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_currency, Currency.changeset(currency, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_currency: _update_currency} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Updated A Currency",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Added a Currency")
        |> redirect(to: Routes.maintenance_path(conn, :currency))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :currency))
    end
  end

  def admin_update_district(conn, params) do
    currency = Loanmanagementsystem.Maintenance.get_district!(params["id"])

    province_ = String.split(params["province"], "|||")

    params =
      Map.merge(params, %{
        "provinceId" => Enum.at(province_, 0),
        "provinceName" => Enum.at(province_, 1)
      })

    country_ = String.split(params["country"], "|||")

    params =
      Map.merge(params, %{
        "countryId" => Enum.at(country_, 0),
        "countryName" => Enum.at(country_, 1)
      })

      params = Map.merge(params, %{
        "name" => params["name"]
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_district, District.changeset(currency, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_district: _update_district} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Updated A District",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated a District")
        |> redirect(to: Routes.system_management_path(conn, :district))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :district))
    end
  end

  def admin_update_security_question(conn, params) do
    security_question = Loanmanagementsystem.Maintenance.get_security_questions!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_security_question,
      Security_questions.changeset(security_question, params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{update_security_question: _update_security_question} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Updated A Security Question",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Added a Security Question")
        |> redirect(to: Routes.maintenance_path(conn, :security_questions))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :security_questions))
    end
  end

  def admin_activate_company(conn, params) do

    update_company = Loanmanagementsystem.Companies.get_company!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:activate_company,
      Company.changeset(update_company, %{

        status: "ACTIVE"

      }))

    |> Ecto.Multi.run(:user_logs, fn _, %{activate_company: activate_company} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated #{activate_company.companyName} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_company: activate_company}} ->
        json(conn, %{data: "#{activate_company.companyName} activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_deactivate_company(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_company,
      Company.changeset(
        Loanmanagementsystem.Companies.get_company!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_company: activate_company} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated #{activate_company.companyName} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_company: activate_company}} ->
        json(conn, %{data: "#{activate_company.companyName} Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_configure_sms(conn, _params),
    do:
      render(conn, "sms_config.html",
        msg_configs: Loanmanagementsystem.SystemSetting.list_tbl_system_settings()
      )


  def admin_configure_add_sms(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_sms_configuration,
      SystemSettings.changeset(%SystemSettings{}, %{
        username: params["username"],
        password: params["password"],
        host: params["host"],
        sender: params["sender"],
        max_attempts: params["max_attempts"]
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_sms_configuration: add_sms_configuration} ->
      UserLogs.changeset(%UserLogs{}, %{
        inerted_at: params["inserted_at"],
        activity: "Successfully Added Message Configuration #{add_sms_configuration.username}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      # {:ok, _} ->
      {:ok, %{add_sms_configuration: add_sms_configuration}} ->
        conn
        |> put_flash(:info, "You Have Succefully Added #{add_sms_configuration.username}")
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_sms))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_sms))
    end
  end

  def admin_configure_update_sms(conn, params) do

    update_sms_configuration = Loanmanagementsystem.SystemSetting.get_system_settings!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_sms_configuration,
      SystemSettings.changeset(update_sms_configuration, %{
        username: params["username"],
        password: params["password"],
        host: params["host"],
        sender: params["sender"],
        max_attempts: params["max_attempts"]
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_sms_configuration: update_sms_configuration} ->
      UserLogs.changeset(%UserLogs{}, %{
        inerted_at: params["inserted_at"],
        activity: "Successfully Updated Message Configuration #{update_sms_configuration.username}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      # {:ok, _} ->
      {:ok, %{update_sms_configuration: update_sms_configuration}} ->
        conn
        |> put_flash(:info, "You Have Succefully updated #{update_sms_configuration.username}")
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_sms))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_sms))
    end
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

  def admin_deactivate_classification(conn, params) do
    classification = Loanmanagementsystem.Maintenance.get_classification!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_class,
      Classification.changeset(classification, Map.merge(params, %{"status" => "INACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_class: activate_class} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated #{activate_class.classification} Classification Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_class: activate_class}} ->
        json(conn, %{
          data: "#{activate_class.classification} Classification Deactivated successfully"
        })

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_activate_bank(conn, params) do
    bamk = Loanmanagementsystem.Maintenance.get_bank!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_bank,
      Bank.changeset(bamk, Map.merge(params, %{"status" => "ACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_bank: activate_bank} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated #{activate_bank.bankName} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_bank: activate_bank}} ->
        json(conn, %{data: "#{activate_bank.bankName}  activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_deactivate_bank(conn, params) do
    bamk = Loanmanagementsystem.Maintenance.get_bank!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_bank,
      Bank.changeset(bamk, Map.merge(params, %{"status" => "INACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_bank: activate_bank} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated #{activate_bank.bankName}  Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_bank: activate_bank}} ->
        json(conn, %{data: "#{activate_bank.bankName}  Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_activate_branch(conn, params) do

    branch = Loanmanagementsystem.Maintenance.get_branch!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_branch,
      Branch.changeset(branch, Map.merge(params, %{"status" => "ACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_branch: activate_branch} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated #{activate_branch.branchName} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_branch: activate_branch}} ->
        json(conn, %{data: "#{activate_branch.branchName} activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_deactivate_branch(conn, params) do
    branch = Loanmanagementsystem.Maintenance.get_branch!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_branch,
      Branch.changeset(branch, Map.merge(params, %{"status" => "INACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_branch: activate_branch} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated #{activate_branch.branchName} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_branch: activate_branch}} ->
        json(conn, %{data: "#{activate_branch.branchName}  Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_activate_msg_config(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_msg_config,
      Message_Management.changeset(
        Loanmanagementsystem.Maintenance.get_message__management!(params["id"]),
        Map.merge(params, %{"status" => "ACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_msg_config: activate_msg_config} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated #{activate_msg_config.msg_type} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_msg_config: activate_msg_config}} ->
        json(conn, %{data: "#{activate_msg_config.msg_type} activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  @spec admin_deactivate_msg_config(Plug.Conn.t(), map) :: Plug.Conn.t()
  def admin_deactivate_msg_config(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_msg_config,
      Message_Management.changeset(
        Loanmanagementsystem.Maintenance.get_message__management!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_msg_config: activate_msg_config} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated #{activate_msg_config.msg_type} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_msg_config: activate_msg_config}} ->
        json(conn, %{data: "#{activate_msg_config.msg_type} Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end


  @headers ~w/ countryName provinceName /a

  def handle__province_bulk_upload(conn, params) do
    user = conn.assigns.user
    {key, msg, _invalid} = handle_file_upload(user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.system_management_path(conn, :province))
    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.system_management_path(conn, :province))
    end
  end

  defp handle_file_upload(user, params) do
    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
      user
      |> process_bulk_upload(filename, destin_path)
      |> case do
        {:ok, {invalid, valid}} ->
          {:info, "#{valid} Successful entrie(s) and #{invalid} invalid entrie(s)", invalid}

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
    |> Repo.transaction(timeout: 290_000)
    |> case do
      {:ok, multi_records} ->
        {invalid, valid} =
          multi_records
          |> Map.values()
          |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->
            case item do
              %{provincefile_name: _src} -> {invalid, valid + 1}
              %{col_index: _index} -> {invalid + 1, valid}
              _ -> {invalid, valid}
            end
          end)

        {:ok, {invalid, valid}}

      {:error, _, changeset, _} ->
        reason = traverse_errors(changeset.errors) |> Enum.join("\r\n")
        {:error, reason}
    end
  end

  defp prepare_bulk_params(_user, _filename, items) do
    items
    |> Stream.with_index(2)
    |> Stream.map(fn {item, index} ->

      countryId = try do Country.find_by(name: item.countryName).id rescue _-> "" end

      other_details = %{
        name: item.provinceName,
        countryName: item.countryName,
        countryId: countryId
      }

      changeset = Province.changeset(%Province{}, Map.merge(item, other_details))
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset)
    end)
    |> Enum.reject(fn
      %{operations: [{_, {:run, _}}]} -> false
      %{operations: [{_, {_, changeset, _}}]} -> changeset.valid? == false
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
  end

  # ---------------------- file persistence --------------------------------------
  def is_valide_file(%{"provincefile_name" => params}) do
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
    destin_path = "C:/CountriesUploads/file" |> default_dir()
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

  def admin_configure_email_sender(conn, _params),
  do:
    render(conn, "email_sender_config.html",
      sender_email: Loanmanagementsystem.Email_configs.list_tbl_email_sender()
    )

  def admin_configure_email_receiver(conn, _params),
  do:
    render(conn, "email_receiver_config.html",
      receiver_email: Loanmanagementsystem.Email_configs.list_tbl_email_receiver()
    )



  def create_receiver_email(conn, params) do
    new_params =
      Map.merge(params, %{"name" => params["name"], "email" => params["email"], "status" => "ACTIVE"})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:email_receiver, Email_config_receiver.changeset(%Email_config_receiver{}, new_params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{email_receiver: email_receiver} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have successfully Added #{email_receiver.email} as email recipient",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{email_receiver: email_receiver}} ->
        conn
        |> put_flash(:info, "You have successfully added #{email_receiver.email} as recipient")
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_email_receiver))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_email_receiver))
    end
  end

  def admin_update_email_receiver(conn, params) do
    email_receiver = Loanmanagementsystem.Email_configs.get_email_config_receiver!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_email_receiver, Email_config_receiver.changeset(email_receiver, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{update_email_receiver: update_email_receiver} ->
      activity = "Updated Branch with ID \"#{update_email_receiver.id}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_email_receiver: _update_email_receiver, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Email Receiver Update successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_email_receiver))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_email_receiver))
    end
  end

  alias Loanmanagementsystem.Email_configs.Email_config_sender

  def create_emails_sender(conn, params) do
    new_params =
      Map.merge(params, %{"password" => params["password"], "email" => params["email"], "status" => "ACTIVE"})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:email_receiver, Email_config_sender.changeset(%Email_config_sender{}, new_params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{email_receiver: email_receiver} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have successfully Added #{email_receiver.email} as email recipient",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{email_receiver: email_receiver}} ->
        conn
        |> put_flash(:info, "You have successfully added #{email_receiver.email} as emails sender")
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_email_sender))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_email_sender))
    end
  end

  def admin_update_emails_sender(conn, params) do
    email_sender = Loanmanagementsystem.Email_configs.get_email_config_sender!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_email_sender, Email_config_sender.changeset(email_sender, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{update_email_sender: update_email_sender} ->
      activity = "Updated Branch with ID \"#{update_email_sender.id}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_email_sender: _update_email_sender, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Email Sender Update successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_email_sender))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :admin_configure_email_sender))
    end
  end

  defp strgfy_term(term) when is_tuple(term), do: term
  defp strgfy_term(term) when not is_tuple(term), do: String.trim("#{term}")

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")

    def authorize_role(conn) do
      case Phoenix.Controller.action_name(conn) do
        act when act in ~w(new create)a -> {:maintenance, :create}
        act when act in ~w(index view)a -> {:maintenance, :view}
        act when act in ~w(update edit)a -> {:maintenance, :edit}
        act when act in ~w(change_status)a -> {:maintenance, :change_status}
        _ -> {:maintenance, :unknown}
      end
    end


end
