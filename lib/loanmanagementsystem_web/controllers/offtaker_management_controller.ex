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
  alias Loanmanagementsystem.Merchants.Merchant
  alias Loanmanagementsystem.Merchants.Merchant_director
  alias Loanmanagementsystem.Merchants.Merchants_device

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

  def employer_maintenance(conn, _params) do
    companies = Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isEmployer != true))

    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()

    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    render(conn, "employer_maintenance.html", companies: companies, banks: banks, town: town)
  end

    def create_employer_maintenance(conn, params) do

      account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"

      otp = to_string(Enum.random(1111..9999))

      company_type_ = String.split(params["defaultSwitchRadioExample"], "|||")

      params =
        Map.merge(params, %{
          "isEmployer" => Enum.at(company_type_, 0),
          "isSme" => Enum.at(company_type_, 1),
          "isOfftaker" => Enum.at(company_type_, 2)
        })

        params =
          Map.merge(params, %{
            "createdByUserId" => "2",
            "status" => "INACTIVE",
            "createdByUserRoleId" => "1"
          })

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, params))
      |> Ecto.Multi.run(:add_user, fn _repo, %{add_company: add_company} ->
        User.changeset(%User{}, %{
          password: params["password"],
          status: "INACTIVE",
          username: params["mobileNumber"],
          auto_password: "Y",
          company_id: add_company.id,
          pin: otp
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_company: _add_company, add_user: add_user} ->
        UserRole.changeset(%UserRole{}, %{
          roleType: "EMPLOYER",
          status: "INACTIVE",
          userId: add_user.id,
          otp: otp
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_user_role_bio, fn _repo, %{add_company: _add_company, add_user: add_user} ->
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
      |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_company: _add_company, add_user: add_user} ->
        Address_Details.changeset(%Address_Details{}, %{
          accomodation_status: params["accomodation_status"],
          area: params["area"],
          house_number: params["house_number"],
          street_name: params["street_name"],
          town_address: params["town_address"],
          userId: add_user.id,
        year_at_current_address: params["year_at_current_address"]
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_customer_balance, fn _repo, %{add_company: _add_company, add_user: add_user} ->
        Customer_Balance.changeset(%Customer_Balance{}, %{
          account_number: account_number,
          user_id: add_user.id
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{add_company: add_company, add_user: add_user} ->
        Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{
            "process_documents" => params,
            "conn" => conn,
            "user_id" => add_user.id,
            "company_id" => add_company.id,
            "tax_number" => add_company.registrationNumber
          })
        end)
      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_company: _add_company} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Added Company Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_company: add_company, add_user_role: add_user_role}} ->
          conn
          |> put_flash(:info, "You have Successfully Added #{add_company.companyName} As An #{add_user_role.roleType}")
          |> redirect(to: Routes.offtaker_management_path(conn, :employer_maintenance))

        {:error, _failed_operations, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

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

  def e_money(conn, _request) do
    e_money = Loanmanagementsystem.Accounts.e_money_details()

    render(conn, "e_money.html",
      e_money: e_money,
      banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
      agent_merchant_list: Loanmanagementsystem.Merchants.list_merchants_agent()
    )
  end

  # def create_user_e_money(conn, params) do
  #   otp = to_string(Enum.random(1111..9999))
  #   pin = to_string(Enum.random(1111..9999))

  #   Ecto.Multi.new()
  #   |> Ecto.Multi.insert(
  #     :add_user,
  #     User.changeset(%User{}, %{
  #       password: params["password"],
  #       status: "INACTIVE",
  #       username: params["emailAddress"],
  #       auto_password: "Y",
  #       pin: pin
  #     })
  #   )
  #   |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
  #     UserRole.changeset(%UserRole{}, %{
  #       # roleType: params["roleType"],
  #       status: "INACTIVE",
  #       roleType: "E-MONEY-ISSUER",
  #       permissions: params["permissions"],
  #       auth_level: params["auth_level"],
  #       userId: add_user.id,
  #       otp: otp
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
  #                                            %{add_user: add_user, add_user_role: _add_user_role} ->
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
  #   |> Ecto.Multi.run(:user_logs, fn _repo,
  #                                    %{
  #                                      add_user: _add_user,
  #                                      add_user_role: _add_user_role,
  #                                      add_user_bio_data: _add_user_bio_data
  #                                    } ->
  #     UserLogs.changeset(%UserLogs{}, %{
  #       inerted_at: params["inserted_at"],
  #       activity: "Added New E-Money-Issuer User Successfully",
  #       user_id: conn.assigns.user.id
  #     })
  #     |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     # {:ok, _} ->
  #     {:ok, %{add_user: _add_user}} ->
  #       Email.send_email(params["emailAddress"], params["password"])

  #       conn
  #       |> put_flash(:info, "You have Successfully Added a New E-Money-Issuer User")
  #       |> redirect(to: Routes.offtaker_management_path(conn, :e_money))

  #     {:error, _failed_operations, failed_value, _changes_so_far} ->
  #       reason = traverse_errors(failed_value.errors)

  #       conn
  #       |> put_flash(:error, reason)
  #       |> redirect(to: Routes.offtaker_management_path(conn, :e_money))
  #   end
  # end

  def edit_e_money_user(conn, params) do
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])
    user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])

    # e_money_user = Loanmanagementsystem.Accounts.e_money_details()

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_user,
      User.changeset(user, %{
        username: params["emailAddress"]
      })
    )
    |> Ecto.Multi.run(:update_user_role, fn _repo, %{update_user: _update_user} ->
      UserRole.changeset(user_role, %{
        roleType: params["roleType"]
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
        activity: "Updated  E-Money-User Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the E-Money-User")
        |> redirect(to: Routes.offtaker_management_path(conn, :e_money))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :e_money))
    end
  end

  def activate_e_money_user(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(
        Loanmanagementsystem.Accounts.get_user!(params["id"]),
        Map.merge(params, %{"status" => "ACTIVE"})
      )
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
        activity: "Activated E-Money-User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "You have successfully activated the E-Money-User"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def deactivate_e_money_user(conn, params) do
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
        activity: "Deactivated E-Money-User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "You have successfully deactivated the E-Money-User"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def oil_marketing_company(conn, _request) do
    buyer = Loanmanagementsystem.Accounts.corporate_buyer()
    render(conn, "oil_marketing_company.html", buyer: buyer)
  end

  def create_oil_marketing_user(conn, params) do
    otp = to_string(Enum.random(1111..9999))
    pin = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_user,
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y",
        pin: pin
      })
    )
    |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
      UserRole.changeset(%UserRole{}, %{
        # roleType: params["roleType"],
        status: "INACTIVE",
        roleType: "CORPORATE-BUYER",
        permissions: params["permissions"],
        auth_level: params["auth_level"],
        userId: add_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
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
        inerted_at: params["inserted_at"],
        activity: "Added New Corporate Buyer User Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      # {:ok, _} ->
      {:ok, %{add_user: _add_user}} ->
        Email.send_email(params["emailAddress"], params["password"])

        conn
        |> put_flash(:info, "You have Successfully Added a New Corporate Buyer User")
        |> redirect(to: Routes.offtaker_management_path(conn, :oil_marketing_company))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :oil_marketing_company))
    end
  end

  def edit_oil_marketing_user(conn, params) do
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])
    user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_user,
      User.changeset(user, %{
        username: params["emailAddress"]
      })
    )
    |> Ecto.Multi.run(:update_user_role, fn _repo, %{update_user: _update_user} ->
      UserRole.changeset(user_role, %{
        roleType: params["roleType"],
        permissions: params["permissions"]
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
        activity: "Updated  Corporate Buyer User Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the Corporate Buyer User")
        |> redirect(to: Routes.offtaker_management_path(conn, :oil_marketing_company))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :oil_marketing_company))
    end
  end

  def activate_oil_marketing_user(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(
        Loanmanagementsystem.Accounts.get_user!(params["id"]),
        Map.merge(params, %{"status" => "ACTIVE"})
      )
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
        activity: " Activated Corporate Buyer User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "You Have Successfully Activated the Corporate Buyer User"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def deactivate_oil_marketing_user(conn, params) do
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
        activity: "Dectivated Corporate Buyer User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "You Have Successfully Deactivated the Corporate Buyer User"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  ####################################### RUSSELL ######################################

  def create_user_e_money(conn, params) do
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
        |> redirect(to: Routes.offtaker_management_path(conn, :e_money))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.offtaker_management_path(conn, :e_money))
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
        roleType: "E-MONEY-ISSUER",
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

  ####################################### RUSSELL ######################################

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
