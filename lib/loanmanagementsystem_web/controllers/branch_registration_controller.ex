defmodule LoanmanagementsystemWeb.BranchRegistrationController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Repo
  use Ecto.Schema
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole}
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Emails.Email
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Employment.Income_Details
  alias Loanmanagementsystem.Employment.Personal_Bank_Details
  # alias Loanmanagementsystem.Accounts
  require Logger

  plug LoanmanagementsystemWeb.Plugs.Authenticate,
      [module_callback: &LoanmanagementsystemWeb.BranchRegistrationController.authorize_role/1]
      when action not in [
            :admin_branch_registration_add_address_details,
            :branch_create_new_user,
            :branch_registration,
            :branch_registration_add_bank_details,
            :branch_registration_add_employment_details,
            :branch_registration_bank_details,
            :branch_registration_income_details,
            :branch_registration_income_details_addition,
            :customer_self_registration,
            :final_steps_of_registration,
            :new_user_set_password,
            :otp_validation,
            :step_three_user_registration,
            :step_two_branch_registration,
            :step_two_user_personal_details,
            :traverse_errors,
            :validate_otp,
       ]

use PipeTo.Override


  # Repo.get_by(Loanmanagementsystem.Accounts.User, username: "0976799179")

  def step_two_branch_registration(conn, params) do
    created_user = params["created_user"]
    render(conn, "step_branch_registration.html", created_user: created_user)
  end

  def branch_registration(conn, params) do
    username = params["mobileNumber"]

    # get_username = Repo.get_by(Loanmanagementsystem.Accounts.User, username: username)

    get_username = Loanmanagementsystem.Accounts.get_my_user(username)

    case is_nil(get_username) do
      true ->
        user = branch_create_new_user(conn, params)

        case user do
          {:ok} ->
            conn
            |> put_flash(:info, "you have successfully created a User account")
            |> redirect(to: Routes.branch_registration_path(conn, :step_two_branch_registration))

          {:error, reason} ->
            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.user_path(conn, :register))
        end

      _ ->
        conn
        |> put_flash(:info, "User Already Exist")
        |> redirect(to: Routes.user_path(conn, :register))
    end
  end

  def branch_create_new_user(conn, params) do
    otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_user,
      User.changeset(%User{}, %{
        status: "INACTIVE",
        username: params["mobileNumber"],
        auto_password: "Y",
        pin: otp
      })
    )
    |> Ecto.Multi.run(:user_bio_data, fn _repo, %{add_user: add_user} ->
      UserBioData.changeset(%UserBioData{}, %{
        mobileNumber: params["mobileNumber"],
        userId: add_user.id,
        idNo: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{add_user: add_user, user_bio_data: _user_bio_data} ->
      UserRole.changeset(%UserRole{}, %{
        roleType: params["roleType"],
        status: "INACTIVE",
        userId: add_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:sms, fn _repo,
                               %{
                                 add_user_bio_data: add_user_bio_data,
                                 add_user: add_user,
                                 add_user_role: _add_user_role
                               } ->
      my_otp = add_user.pin

      sms = %{
        mobile: add_user_bio_data.mobileNumber,
        msg:
          "Hello, Thank you for registering with QFin. To validate your mobile number, please provide the OTP - #{my_otp}",
        status: "READY",
        type: "SMS",
        msg_count: "1"
      }

      Loanmanagementsystem.Notifications.Sms.changeset(
        %Loanmanagementsystem.Notifications.Sms{},
        sms
      )
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_user: _add_user,
                                       user_bio_data: _user_bio_data,
                                       add_user_role: add_user_role
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully created #{add_user_role.roleType}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} -> {:ok}
      {:error, reason} -> {:error, reason}
    end
  end

  def customer_self_registration(conn, params) do
    username = params["mobileNumber"]

    get_username = Repo.get_by(User, username: username)

    case is_nil(get_username) do
      true ->
        otp = to_string(Enum.random(1111..9999))

        Ecto.Multi.new()
        |> Ecto.Multi.insert(
          :add_user,
          User.changeset(%User{}, %{
            # password: params["password"],
            status: "INACTIVE",
            username: params["mobileNumber"],
            auto_password: "Y",
            pin: otp
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
        |> Ecto.Multi.run(:sms, fn _repo,
                                   %{
                                     add_user_bio_data: add_user_bio_data,
                                     add_user: add_user,
                                     add_user_role: _add_user_role
                                   } ->
          my_otp = add_user.pin

          sms = %{
            mobile: add_user_bio_data.mobileNumber,
            msg:
              "Hello, Thank you for Registering with QFin. To validate your mobile number, please provide the OTP - #{my_otp}",
            status: "READY",
            type: "SMS",
            msg_count: "1"
          }

          Loanmanagementsystem.Notifications.Sms.changeset(
            %Loanmanagementsystem.Notifications.Sms{},
            sms
          )
          |> Repo.insert()
        end)
        |> Ecto.Multi.run(:user_logs, fn _repo,
                                         %{
                                           add_user: _add_user,
                                           add_user_role: _add_user_role,
                                           add_user_bio_data: _add_user_bio_data
                                         } ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Added New User Successfully",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
        |> Repo.transaction()
        |> case do
          # {:ok, _} ->
          {:ok, %{add_user: _add_user, add_user_bio_data: add_user_bio_data}} ->
            Email.send_email(params["emailAddress"], params["password"])

            conn
            |> put_flash(:info, "You have Successfully Added a New User")
            |> redirect(
              to:
                Routes.branch_registration_path(conn, :otp_validation,
                  mobileNumber: add_user_bio_data.mobileNumber
                )
            )

          {:error, _failed_operations, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors)

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.customers_path(conn, :individuals))
        end

      _ ->
        conn
        |> put_flash(:error, "User Already Exists")
        |> redirect(to: Routes.customers_path(conn, :individuals))
    end
  end

  def otp_validation(conn, %{"mobileNumber" => mobileNumber}) do
    user_details = Loanmanagementsystem.Accounts.get_user_username(mobileNumber)

    render(conn, "otp_validation.html", user_details: user_details)
  end

  def validate_otp(conn, params) do
    username = params["username"]
    otp1 = params["otp1"]
    otp2 = params["otp2"]
    otp3 = params["otp3"]
    otp4 = params["otp4"]
    otp = "#{otp1}#{otp2}#{otp3}#{otp4}"
    user_role = params["user_role"]
    uRoleType = params["roleType"]
    # Logger.info ("uRoleType...#{uRoleType}");

    query = from uB in User, where: uB.username == ^username, select: uB
    users = Repo.all(query)

    user = Enum.at(users, 0)

    query =
      from uB in UserRole,
        where: uB.userId == ^user.id and uB.id == ^uRoleType and uB.otp == ^otp,
        select: uB

    userRoles = Repo.all(query)

    if(!is_nil(userRoles) && Enum.count(userRoles) > 0) do
      userRole = Enum.at(userRoles, 0)

      userRole =
        UserRole.changeset(
          userRole,
          %{
            # clientId: userRole.clientId,
            roleType: userRole.roleType,
            status: userRole.status,
            userId: userRole.userId,
            otp: nil
          }
        )

      conn
      |> put_flash(:info, "You have Successfully Reached Step 2")
      |> redirect(
        to:
          Routes.branch_registration_path(conn, :step_two_branch_registration, created_user: user)
      )
    else
      conn
      |> put_flash(:error, "Invalid OTP provided for the role you have provided")
      |> redirect(to: Routes.branch_registration_path(conn, :otp_validation))
    end
  end

  def new_user_set_password(conn, %{"username" => username, "uRoleType" => uRoleType}) do
    # userId = get_session(conn, :current_user_id)
    Logger.info(">>>>>>>")
    Logger.info(uRoleType)
    Logger.info(username)

    query = from u in User, where: u.username == ^username, select: u
    users = Repo.all(query)

    Logger.info(Enum.count(users))
    user = Enum.at(users, 0)
    userId = user.id

    query = from uR in UserRole, where: uR.userId == ^userId and uR.id == ^uRoleType, select: uR
    userRoles = Repo.all(query)

    if Enum.count(userRoles) > 0 do
      userRole = Enum.at(userRoles, 0)

      if(!is_nil(userRole) && is_nil(userRole.otp)) do
        render(conn, "new_user_set_password.html", userRole: userRole, username: username)
      else
        conn
        |> put_flash(:danger, "Sign In failed.")
        |> redirect(to: Routes.session_path(conn, :username))
      end
    else
    end
  end

  def step_two_user_personal_details(conn, params) do
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :add_user_detials,
      UserBioData.changeset(user_bio_data, %{
        dateOfBirth: params["dateOfBirth"],
        emailAddress: params["emailAddress"],
        firstName: params["firstName"],
        gender: params["gender"],
        lastName: params["lastName"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
        meansOfIdentificationType: params["meansOfIdentificationType"],
        otherName: params["otherName"],
        title: params["title"],
        userId: params["id"],
        idNo: nil,
        marital_status: params["marital_status"],
        nationality: params["nationality"],
        number_of_dependants: params["number_of_dependants"]
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_user_detials: _add_user_detials} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You Successfully Updated User Personal Details",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        userId = params["id"]

        conn
        |> put_flash(
          :info,
          "You have successfully Added User Personal detials, Proceed to Step 3"
        )
        |> redirect(
          to:
            Routes.branch_registration_path(conn, :step_three_user_registration,
              created_user: userId
            )
        )

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)
        userId = params["id"]

        conn
        |> put_flash(:error, reason)
        |> redirect(
          to:
            Routes.branch_registration_path(conn, :step_two_branch_registration,
              created_user: userId
            )
        )
    end
  end

  def step_three_user_registration(conn, params) do
    created_user = params["created_user"]
    render(conn, "step_three_user_registration.html", created_user: created_user)
  end

  def admin_branch_registration_add_address_details(conn, params) do
    params = Map.merge(params, %{"userId" => params["id"]})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_address_details,
      Address_Details.changeset(%Address_Details{}, params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_address_details: _add_address_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You Successfully Added User Address Details",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        userId = params["id"]

        conn
        |> put_flash(:info, "You have successfully added Address Details")
        |> redirect(
          to:
            Routes.branch_registration_path(conn, :final_steps_of_registration,
              created_user: userId
            )
        )

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)
        userId = params["id"]

        conn
        |> put_flash(:error, reason)
        |> redirect(
          to:
            Routes.branch_registration_path(conn, :step_three_user_registration,
              created_user: userId
            )
        )
    end
  end

  def final_steps_of_registration(conn, params) do
    render(conn, "final_steps_of_registration.html", created_user: params["created_user"])
  end

  def branch_registration_add_employment_details(conn, params) do
    params = Map.merge(params, %{"userId" => params["id"]})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_employment_details,
      Employment_Details.changeset(%Employment_Details{}, params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_employment_details: _add_employment_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Added Employee Details",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        userId = params["id"]

        conn
        |> put_flash(
          :info,
          "You have Successfully added Employee Details. Proceed to the Next Step"
        )
        |> redirect(
          to:
            Routes.branch_registration_path(conn, :branch_registration_income_details,
              created_user: userId
            )
        )

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)
        userId = params["id"]

        conn
        |> put_flash(conn, reason)
        |> redirect(
          to:
            Routes.branch_registration_path(conn, :final_steps_of_registration,
              created_user: userId
            )
        )
    end
  end

  def branch_registration_income_details(conn, params) do
    render(conn, "branch_registration_income_details.html", created_user: params["created_user"])
  end

  def branch_registration_income_details_addition(conn, params) do
    params = Map.merge(params, %{"userId" => params["id"]})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_income_details, Income_Details.changeset(%Income_Details{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_income_details: _add_income_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have successfully Added Income Details",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        userId = params["id"]

        conn
        |> put_flash(:info, "You have Successfully Added Client Income Details")
        |> redirect(
          to:
            Routes.branch_registration_path(conn, :branch_registration_bank_details,
              created_user: userId
            )
        )

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)
        userId = params["id"]

        conn
        |> put_flash(:error, reason)
        |> redirect(
          to:
            Routes.branch_registration_path(conn, :branch_registration_income_details,
              created_user: userId
            )
        )
    end
  end

  def branch_registration_bank_details(conn, params) do
    render(conn, "branch_registration_add_bank_details.html",
      created_user: params["created_user"],
      banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
      branches: Loanmanagementsystem.Maintenance.list_tbl_branch()
    )
  end

  def branch_registration_add_bank_details(conn, params) do
    otp = to_string(Enum.random(1111..9999))

    bank_name_and_branch_name = String.split(params["bank_name_and_branch"], "|||")

    params =
      Map.merge(params, %{
        "bankName" => Enum.at(bank_name_and_branch_name, 0),
        "branchName" => Enum.at(bank_name_and_branch_name, 1),
        "userId" => params["id"]
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_bank_details,
      Personal_Bank_Details.changeset(%Personal_Bank_Details{}, params)
    )
    |> Ecto.Multi.run(:update_password, fn _repo, %{add_bank_details: _add_bank_details} ->
      IO.inspect(otp, label: "password")
      params = Loanmanagementsystem.Accounts.get_user!(params["id"])

      User.changeset(params, %{
        password: otp
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_bank_details: _add_bank_details,
                                       update_password: _update_password
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully added Client Bank details",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        userId = params["id"]
        user = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(userId)
        Email.send_email(user.emailAddress, otp)

        conn
        |> put_flash(:info, "You have Successfully Added the Clients Personal Banks Details")
        |> redirect(to: Routes.customers_path(conn, :individuals, created_user: userId))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)
        userId = params["id"]

        conn
        |> put_flash(:error, reason)
        |> redirect(
          to:
            Routes.branch_registration_path(conn, :branch_registration_bank_details,
              created_user: userId
            )
        )
    end
  end



  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:bank_branch, :create}
      act when act in ~w(index view)a -> {:bank_branch, :view}
      act when act in ~w(update edit)a -> {:bank_branch, :edit}
      act when act in ~w(change_status)a -> {:bank_branch, :change_status}
      _ -> {:bank_branch, :unknown}
    end
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
