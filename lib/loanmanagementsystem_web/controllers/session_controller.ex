defmodule LoanmanagementsystemWeb.SessionController do
  use LoanmanagementsystemWeb, :controller
  require Logger
  # alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Accounts
  alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Auth
  alias Auth
  alias Loanmanagementsystem.Accounts.{User, Address_Details}
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Notifications.Sms
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Emails.Email
  alias Loanmanagementsystem.Companies.Employee
  alias Loanmanagementsystem.Employment.{Employment_Details, Personal_Bank_Details, Income_Details}
  alias Loanmanagementsystem.Maintenance.Bank
  require Record
  import Ecto.Query, only: [from: 2]

  plug(
    LoanmanagementsystemWeb.Plugs.RequireAuth
    when action in [:signout]
  )

  def username(conn, _params) do
    render(conn, "index.html")
  end

  def forgot_password(conn, _params) do
    Logger.info(">>>>>>>")
    render(conn, "forgot_password.html")
  end

  def self_registration(conn, _params) do
    render(conn, "self_registration.html")
  end

  def otp_validation_number(conn, %{"mobileNumber" => mobile}) do
    user_details = Loanmanagementsystem.Accounts.otp_validate_by_phone(mobile)
    render(conn, "otp_validate_by_number.html", user_details: user_details)
  end

  def recover_password(conn, params) do
    IO.inspect("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    IO.inspect(params)
    random_int = to_string(Enum.random(1111..9999))
    username_data = params["username"]
    system_data = Repo.get_by(User, username: username_data)

    if system_data == nil do
      conn
      |> put_flash(:error, "Username Does Not Exist on the system.")
      |> redirect(to: Routes.session_path(conn, :forgot_password))
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
            |> put_flash(:info, "Message with OTP sent Successfully. Please Enter the OTP sent to your email or mobile number.")
            |> redirect(to: Routes.session_path(conn, :get_forgot_password_validate_otp, username: username_data))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.session_path(conn, :forgot_password))
        end
      else
        conn
        |> put_flash(:error, "User is Disabled, Please Contact PayKesho.")
        |> redirect(to: Routes.session_path(conn, :error_405))
      end
    end
  end

  def get_forgot_password_validate_otp(conn, %{"username" => username} = params) do
    query = from(uB in User, where: uB.username == ^username, select: uB)
    userRoles = Repo.all(query)
    username_data = params["username"]
    get_username = Repo.get_by(User, username: username_data)

    render(conn, "get_forgot_password_validate_otp.html",
      userRoles: userRoles,
      username: username,
      get_username: get_username
    )
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
    IO.inspect(user)

    if(!is_nil(users) && Enum.count(users) > 0) do
      users = Enum.at(users, 0)

      users =
        User.changeset(
          users,
          %{
            pin: nil
          }
        )

      Repo.update!(users)
      system_data = Repo.get_by(User, username: username_data)
      IO.inspect(system_data)

      if(is_nil(system_data)) do
        conn
        |> put_flash(:error, "Invalid OTP provided")
        |> redirect(
          to:
            Routes.session_path(conn, :get_forgot_password_validate_otp, username: username_data)
        )
      else
        conn
        |> redirect(
          to:
            Routes.session_path(conn, :forgot_password_user_set_password, username: username_data)
        )
      end
    else
      conn
      |> put_flash(:error, "Invalid OTP provided")
      |> redirect(
        to: Routes.session_path(conn, :get_forgot_password_validate_otp, username: username_data)
      )
    end
  end

  def forgot_password_user_set_password(conn, %{"username" => username} = params) do
    username_data = params["username"]

    get_username = Repo.get_by(User, username: username_data)
    query = from(u in User, where: u.username == ^username_data, select: u)
    users = Repo.all(query)

    Logger.info(Enum.count(users))
    user = Enum.at(users, 0)
    IO.inspect(user)

    if Enum.count(users) > 0 do
      users = Enum.at(users, 0)

      if(!is_nil(users) && is_nil(users.pin)) do
        render(conn, "forgot_password_user_set_password.html",
          username: username,
          get_username: get_username
        )
      else
        conn
        |> put_flash(:danger, "Sign In failed.")
        |> redirect(
          to:
            Routes.session_path(conn, :forgot_password_user_set_password,
              username: username,
              get_username: get_username
            )
        )
      end
    else
    end

    # render(conn, "new_user_set_password.html", email: email)
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

        changeset =
          User.changeset(user, %{
            password: password
          })

        case Repo.update(changeset) do
          {:ok, changeset} ->
            IO.inspect("+++++++++++++++++++++++++++++++++++=")
            IO.inspect(changeset)

            render(conn, "username.html")

          {:error, changeset} ->
            errMessage = User.changeset_error_to_string(changeset)

            conn
            |> put_flash(:error, errMessage)
            |> redirect(
              to:
                Routes.session_path(conn, :forgot_password_user_set_password,
                  username: username_data
                )
            )
        end
      else
        conn
        |> put_flash(:error, "Invalid login details provided")
        |> redirect(
          to:
            Routes.session_path(conn, :forgot_password_user_set_password, username: username_data)
        )
      end
    else
      conn
      |> put_flash(:error, "Password provided must match the confirmation password you provided")
      |> redirect(
        to: Routes.session_path(conn, :forgot_password_user_set_password, username: username_data)
      )
    end
  end

  def create(conn, params) do
    with {:error, _reason} <- UserController.get_user_by_email(String.trim(params["username"])) do
      conn
      |> put_flash(:error, "Email/Password does not match")
      |> put_layout(false)
      |> render("index.html")
    else
      {:ok, user} ->
        with {:error, _reason} <- Auth.confirm_password(user, String.trim(params["password"])) do
          prepare_login_attempt(user)

          conn
          |> put_flash(:error, "Email/Password does not match")
          |> put_layout(false)
          |> render("index.html")
        else
          {:ok, _} ->
            #IO.inspect(user, label: "check my user here \n\n\n")

            cond do
              user.status == "ACTIVE" ->
                {:ok, _} =
                  Loanmanagementsystem.Logs.create_user_logs(%{
                    user_id: user.id,
                    activity: "logged in"
                  })

                logon_dt = Timex.format!(Timex.local(), "%Y-%m-%d %H:%M:%S", :strftime)
                remote_ip = conn.remote_ip |> :inet.ntoa() |> to_string()

                {:ok, user} = Accounts.update_user(user, %{remote_ip: remote_ip, last_login_dt: logon_dt, login_attempt: 0})

                user_id = user.id

                query = from(uB in Loanmanagementsystem.Accounts.UserBioData,
                    where: uB.userId == ^user.id,
                    select: uB
                  )

                userBioData = Repo.all(query)
                currentUserBioData = Enum.at(userBioData, 0)

                IO.inspect(currentUserBioData, label: "Am here CHief")

                query = from(uB in Loanmanagementsystem.Accounts.UserRole,
                      where: uB.userId == ^user_id,
                      select: uB
                    )

                userRoles = Repo.all(query)

                currentUserRole = Enum.at(userRoles, 0)

                # query =
                #   from(uR in Loanmanagementsystem.Accounts.Role,
                #     where: uR.id == ^user_id,
                #     select: uR
                #   )

                # myUserRole = Repo.all(query)

                # mycurrentUserRole = Enum.at(myUserRole, 0)
                IO.inspect(currentUserRole, label: "??????? Dry Wave ??????")

                case currentUserRole.roleType do

                  "ADMIN" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :admin_dashboard))

                  "INDIVIDUALS" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :individual_dashboard))

                  "EMPLOYEE" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :employee_dashboard))

                  "EMPLOYER" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :employer_dashboard))

                  "SME" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :sme_dashboard))


                  "FUNDER" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.funder_path(conn, :funder_dashboard))

                  "OFFTAKER"->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :offtaker_dashboard))

                    "MERCHANT"->
                      conn
                      |> put_session(:current_user, user.id)
                      |> put_session(:current_user_bio_data, currentUserBioData)
                      |> put_session(:current_user_role, currentUserRole)
                      # |> put_session(:current_user_data, user)
                      |> put_session(:session_timeout_at, session_timeout_at())
                      |> redirect(to: Routes.user_path(conn, :merchant_dashboard))

                  _->
                    conn
                    |> put_flash(:error, "User Role Not Found")
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> render("index.html")

                end

              user.status == "INACTIVE" ->
                conn
                # |> put_status(405)
                # |> put_layout(false)
                # |> render("username.html")
                # |> put_flash(:error, "Your account has been blocked!")
                |> put_layout(false)
                |> render("disabled_account.html")

              true ->
                conn
                |> put_status(405)
                |> put_layout(false)
                |> render("username.html")
            end
        end
    end
  end

  defp session_timeout_at do
    DateTime.utc_now() |> DateTime.to_unix() |> (&(&1 + 10_000)).()
  end

  def signout(conn, _params) do
    {:ok, _} =
      Loanmanagementsystem.Logs.create_user_logs(%{
        user_id: conn.assigns.user.id,
        activity: "logged out"
      })

    conn
    # |> configure_session(drop: true)
    |> clear_session()
    |> redirect(to: Routes.session_path(conn, :username))
  rescue
    _ ->
      conn
      # |> configure_session(drop: true)
      |> clear_session()
      |> redirect(to: Routes.session_path(conn, :username))
  end

  defp prepare_login_attempt(user) do
    max_attempts = 3
    status = if user.login_attempt < max_attempts, do: "ACTIVE", else: "INACTIVE"
    Accounts.update_user(user, %{login_attempt: user.login_attempt + 1, status: status})
  end

  def register(conn, params) do
    # user_role_id = Loanmanagementsystem.Accounts.get_farmer_role()
    user_role_id = 1

    render(conn, "register.html", user_role_id: user_role_id)
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
    # user_role = params["user_role"]
    uRoleType = params["roleType"]
    # Logger.info ("uRoleType...#{uRoleType}");

    query = from(uB in User, where: uB.username == ^username, select: uB)
    users = Repo.all(query)
    user = Enum.at(users, 0)
    query = from(uB in UserRole, where: uB.userId == ^user.id and uB.id == ^uRoleType and uB.otp == ^otp, select: uB)

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

      Repo.update!(userRole)
      userId = get_session(conn, :current_user)
      Logger.info(".............User Id #{userId}")

      if(is_nil(userId)) do
        conn
        # |> put_flash(:error, "Create Password and Sign in")
        # |> redirect(
        #   to:
        #     Routes.session_path(conn, :new_user_set_password,
        #       username: "#{username}",
        #       uRoleType: "#{uRoleType}"
        #     )
        # )
        |> put_flash(:error, "Account created. You will receive your login credentials soon")
        |> redirect(to: Routes.session_path(conn, :account_inactive))
      else
        conn
        |> put_flash(:error, "Account created. You will receive your login credentials soon")
        |> redirect(to: Routes.session_path(conn, :account_inactive))
      end
    else
      conn
      |> put_flash(:error, "Invalid OTP provided for the role you have provided")
      |> redirect(to: Routes.session_path(conn, :username))
    end
  end

  def new_user_set_password(conn, %{"username" => username, "uRoleType" => uRoleType}) do
    # userId = get_session(conn, :current_user_id)
    Logger.info(">>>>>>>")
    Logger.info(uRoleType)
    Logger.info(username)

    query = from(u in User, where: u.username == ^username, select: u)
    users = Repo.all(query)

    Logger.info(Enum.count(users))
    user = Enum.at(users, 0)
    userId = user.id

    query = from(uR in UserRole, where: uR.userId == ^userId and uR.id == ^uRoleType, select: uR)
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

  def post_new_user_set_password(conn, params) do
    username = params["username"]
    userRoleId = params["userRoleId"]
    password = params["password"]
    cpassword = params["cpassword"]

    Logger.info("password...#{password}")
    Logger.info("cpassword...#{cpassword}")

    if password == cpassword do
      query = from(uB in User, where: uB.username == ^username, select: uB)
      users = Repo.all(query)

      if Enum.count(users) > 0 do
        user = Enum.at(users, 0)

        changeset =
          User.changeset(user, %{
            # clientId: user.clientId,
            # createdByUserId: user.createdByUserId,
            password: password,
            status: user.status,
            username: user.username
          })

        case Repo.update(changeset) do
          {:ok, changeset} ->
            user_id = user.id
            query = from(uB in UserBioData, where: uB.userId == ^user_id, select: uB)
            userBioData = Repo.all(query)

            currentUserBioData = Enum.at(userBioData, 0)

            query = from(uB in UserRole, where: uB.id == ^userRoleId, select: uB)
            userRoles = Repo.all(query)

            currentUserRole = Enum.at(userRoles, 0)
            IO.inspect(currentUserRole, label: "^^^^^^^ Check role here ^^^^^^^^^")

            cond do
              currentUserRole.roleType == "ADMIN" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :admin_dashboard))

              currentUserRole.roleType == "w" ->
                conn
                |> put_flash(:info, "Password set successful")
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :individual_dashboard))

              currentUserRole.roleType == "EMPLOYER" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :employer_dashboard))

              currentUserRole.roleType == "EMPLOYEE" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :employee_dashboard))

              currentUserRole.roleType == "SME" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :sme_dashboard))

              currentUserRole.roleType == "OFFTAKER" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :sme_dashboard))
            end

          {:error, changeset} ->
            errMessage = User.changeset_error_to_string(changeset)

            conn
            |> put_flash(:error, errMessage)
            |> redirect(
              to:
                Routes.session_path(conn, :new_user_set_password, %{
                  "username" => username,
                  "uRoleType" => userRoleId
                })
            )
        end
      else
        conn
        |> put_flash(:error, "Invalid login details provided")
        |> redirect(
          to:
            Routes.session_path(conn, :new_user_set_password, %{
              "username" => username,
              "uRoleType" => userRoleId
            })
        )
      end
    else
      conn
      |> put_flash(:error, "Password provded must match the confirmation password you provided")
      |> redirect(
        to:
          Routes.session_path(conn, :new_user_set_password, %{
            "username" => username,
            "uRoleType" => userRoleId
          })
      )
    end
  end

  def account_inactive(conn, _params) do
    render(conn, "account_inactive.html")
  end

  def error_405(conn, _params) do
    render(conn, "disabled_account.html")
  end

  def new_password(conn, %{"username" => username}) do
    put_layout(conn, false)
    |> render("change_password.html", username: username)
  end

  def change_password(conn, %{"username" => username, "old_password" => pwd, "new_password" => new_pwd}) do
    getdata = Loanmanagementsystem.Accounts.get_user_for_otp(username)
    userID = getdata.id

    IO.inspect "++++++++++++++++++++"
    IO.inspect userID
    case confirm_old_password(conn, %{"userID" => userID, "old_password" => pwd, "new_password" => new_pwd}) do
      false ->
        conn
        |> put_flash(:error, "Some fields were submitted empty!")
        |> redirect(to: Routes.session_path(conn, :new_password))

      result ->
        with {:error, reason} <- result do
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.session_path(conn, :new_password))
        else
          {:ok, _} ->
            conn.assigns.user
            |> change_pwd(username)
            |> Repo.transaction()
            |> case do
              {:ok, %{update: _update, insert: _insert}} ->
                conn
                |> put_flash(:info, "Password changed successfully")
                |> redirect(to: Routes.session_path(conn, :username))

              {:error, _failed_operation, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors) |> List.first()

                conn
                |> put_flash(:error, reason)
                |> redirect(to: Routes.session_path(conn, :new_password))
            end
        end
    end

    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "Password changed with errors")
    #     |> redirect(to: Routes.user_path(conn, :new_password))
  end

  defp confirm_old_password(conn, %{"userID" => userID, "old_password" => pwd, "new_password" => new_pwd}) do
    # IO.inspect("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    # IO.inspect conn

    with true <- String.trim(pwd) != "",
         true <- String.trim(new_pwd) != "" do
      Auth.confirm_password(userID.id, String.trim(pwd))
    else
      false -> false
    end
  end

  def change_pwd(user, user_params) do
    pwd = String.trim(user_params["new_password"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update, User.changeset(user, %{password: pwd, auto_password: "N"}))
    |> Ecto.Multi.insert(
      :insert,
      UserLogs.changeset(
        %UserLogs{},
        %{user_id: user.id, activity: "changed account password"}
      )
    )
  end


  def registration_validate_otp(conn, params) do
    user_name = params["username"]
    username = params["username_mobile"]
    otp1 = params["otp1"]
    otp2 = params["otp2"]
    otp3 = params["otp3"]
    otp4 = params["otp4"]
    otp = "#{otp1}#{otp2}#{otp3}#{otp4}"
    # user_role = params["user_role"]
    uRoleType = params["role_id"]
    # Logger.info ("uRoleType...#{uRoleType}");

    query = from(uB in User, where: uB.username_mobile == ^username, select: uB)
    users = Repo.all(query)
    user = Enum.at(users, 0)
    query = from(uB in UserRole, where: uB.userId == ^user.id and uB.id == ^uRoleType and uB.otp == ^otp, select: uB)

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

      Repo.update!(userRole)
      userId = get_session(conn, :current_user)
      Logger.info(".............User Id #{userId}")

      if(is_nil(userId)) do
        conn
        # |> put_flash(:error, "Create Password and Sign in")
        # |> redirect(
        #   to:
        #     Routes.session_path(conn, :new_user_set_password,
        #       username: "#{username}",
        #       uRoleType: "#{uRoleType}"
        #     )
        # )
        |> put_flash(:info, "Create Password and log in.")
        |> redirect(to: Routes.session_path(conn, :registration_new_user_set_password, username_mobile: "#{username}", uRoleType: "#{uRoleType}", user_name: "#{user_name}"))
      else
        conn
        |> put_flash(:info, "Create Password and log in.")
        |> redirect(to: Routes.session_path(conn, :registration_new_user_set_password, username_mobile: "#{username}", uRoleType: "#{uRoleType}", user_name: "#{user_name}"))
      end
    else
      conn
      |> put_flash(:error, "Invalid OTP provided for the role you have provided")
      |> redirect(to: Routes.session_path(conn, :username))
    end
  end

  def registration_new_user_set_password(conn, %{"username_mobile" => username_mobile, "uRoleType" => uRoleType, "user_name" => user_name}) do
    # userId = get_session(conn, :current_user_id)
    Logger.info(">>>>>>>")
    Logger.info(uRoleType)
    Logger.info(username_mobile)

    query = from u in User, where: u.username_mobile == ^username_mobile, select: u
    users = Repo.all(query)

    Logger.info(Enum.count(users))
    user = Enum.at(users, 0)
    userId = user.id

    query = from uR in UserRole, where: uR.userId == ^userId and uR.id == ^uRoleType, select: uR
    userRoles = Repo.all(query)

    if Enum.count(userRoles) > 0 do
      userRole = Enum.at(userRoles, 0)

      if(!is_nil(userRole) && is_nil(userRole.otp)) do
        render(conn, "registration_new_user_set_password.html", userRole: userRole, username_mobile: username_mobile, user_name: user_name)
      else
        conn
        |> put_flash(:danger, "Sign In failed.")
        |> redirect(to: Routes.session_path(conn, :username))
      end
    else
    end
  end

  def set_registration_new_user_set_password(conn, params) do
    username = params["username"]
    userRoleId = params["userRoleId"]
    password = params["password"]
    cpassword = params["cpassword"]

    Logger.info("password...#{password}")
    Logger.info("cpassword...#{cpassword}")

    if password == cpassword do
      query = from(uB in User, where: uB.username_mobile == ^username, select: uB)
      users = Repo.all(query)

      if Enum.count(users) > 0 do
        user = Enum.at(users, 0)

        changeset =
          User.changeset(user, %{
            # clientId: user.clientId,
            # createdByUserId: user.createdByUserId,
            password: password,
            status: user.status,
          })

        case Repo.update(changeset) do
          {:ok, _changeset} ->
            user_id = user.id
            query = from(uB in UserBioData, where: uB.userId == ^user_id, select: uB)
            userBioData = Repo.all(query)

            currentUserBioData = Enum.at(userBioData, 0)

            query = from(uB in UserRole, where: uB.id == ^userRoleId, select: uB)
            userRoles = Repo.all(query)

            currentUserRole = Enum.at(userRoles, 0)
            IO.inspect(currentUserRole, label: "^^^^^^^ Check role here ^^^^^^^^^")

            cond do
              currentUserRole.roleType == "ADMIN" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :admin_dashboard))

              currentUserRole.roleType == "INDIVIDUAL" ->
                conn
                |> put_flash(:info, "Password set successful")
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :individual_dashboard))

              currentUserRole.roleType == "EMPLOYER" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :employer_dashboard))

              currentUserRole.roleType == "EMPLOYEE" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :employee_dashboard))


              currentUserRole.roleType == "SME" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :sme_dashboard))

              currentUserRole.roleType == "OFFTAKER" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :sme_dashboard))

              currentUserRole.roleType == "MERCHANT" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :merchant_dashboard))
            end

          {:error, changeset} ->
            errMessage = User.changeset_error_to_string(changeset)

            conn
            |> put_flash(:error, errMessage)
            |> redirect(
              to:
                Routes.session_path(conn, :registration_new_user_set_password, %{"username" => username, "uRoleType" => userRoleId}))
        end
      else
        conn
        |> put_flash(:error, "Invalid login details provided")
        |> redirect(
          to:
            Routes.session_path(conn, :registration_new_user_set_password, %{"username" => username, "uRoleType" => userRoleId}))
      end
    else
      conn
      |> put_flash(:error, "Password provded must match the confirmation password you provided")
      |> redirect(
        to:
          Routes.session_path(conn, :registration_new_user_set_password, %{"username" => username, "uRoleType" => userRoleId}))
    end
  end

  def merchant_profile_update(conn, _params) do
    companies = Loanmanagementsystem.Companies.list_all_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "merchant_update_profile.html", companies: companies, departments: departments, banks: banks, town: town, province: province)
  end

  def create_update_merchant_profile(conn, params) do

    IO.inspect(params, label: "--------------------PARAM--------------------")

    mobile_number = try do Loanmanagementsystem.Accounts.User.find_by(username_mobile: params["mobileNumber"]).id rescue _-> "" end

    userId = mobile_number

    client_employer = try do Loanmanagementsystem.Companies.Company.find_by(id: params["company_id"]).companyName rescue _-> "" end

    bank_name = try do Bank.find_by(id: params["bank_id"]).bankName rescue _-> "" end

    branch_name = try do Bank.find_by(id: params["bank_id"]).process_branch rescue _-> "" end

    userbiodate = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(userId)

    update_companyId = Loanmanagementsystem.Accounts.get_user!(userId)

    user_role_update = Loanmanagementsystem.Accounts.get_userRole!(userId)


    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_userbiodate,
    UserBioData.changeset(userbiodate, %{

      dateOfBirth: params["dateOfBirth"],
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

    }))

    |> Ecto.Multi.run(:update_client_id, fn _repo, %{update_userbiodate: _update_userbiodate} ->
      User.changeset(update_companyId, %{

        auto_password: "Y",
        company_id: if is_integer(params["company_id"]) do params["company_id"] else String.to_integer(params["company_id"]) end,

      })
      |> Repo.update()
    end)

    |> Ecto.Multi.run(:update_user_role, fn _repo, %{update_userbiodate: _update_userbiodate} ->
      UserRole.changeset(user_role_update, %{

        client_type: params["client_type"]

      })
      |> Repo.update()
    end)

    |> Ecto.Multi.run(:update_employment_details, fn _repo, %{update_userbiodate: _update_userbiodate, update_client_id: update_client_id} ->
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
        userId: update_client_id.id,
        departmentId: params["departmentId"],
        contract_start_date: params["contract_start_date"],
        contract_end_date: params["contract_end_date"],
        company_id: if is_integer(params["company_id"]) do params["company_id"] else String.to_integer(params["company_id"]) end,
      })
      |> Repo.insert()
    end)

    |> Ecto.Multi.run(:update_address_details, fn _repo, %{ update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_client_id: update_client_id} ->
      Address_Details.changeset(%Address_Details{}, %{

        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        userId: update_client_id.id,
        year_at_current_address: params["year_at_current_address"]

      })
      |> Repo.insert()
    end)

    |> Ecto.Multi.run(:update_personal_bank, fn _repo, %{update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_address_details: _update_address_details, update_client_id: update_client_id} ->
      Personal_Bank_Details.changeset(%Personal_Bank_Details{}, %{

        accountName: params["accountName"],
        accountNumber: params["bank_account_number"],
        bankName: bank_name,
        branchName: branch_name,
        upload_bank_statement: nil,
        userId: update_client_id.id,
        bank_id: params["bank_id"],
        mobile_number: params["mobile_number"],
      })
      |> Repo.insert()
    end)

    |> Ecto.Multi.run(:update_employee, fn _repo, %{update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_address_details: _update_address_details, update_client_id: update_client_id, update_personal_bank: _update_personal_bank} ->
      Employee.changeset(%Employee{}, %{

        companyId: if is_integer(params["company_id"]) do params["company_id"] else String.to_integer(params["company_id"]) end,
        employerId: if is_integer(params["company_id"]) do params["company_id"] else String.to_integer(params["company_id"]) end,
        status: "ACTIVE",
        userId: update_client_id.id,
        userRoleId: user_role_update.id,
        loan_limit: params["loan_limit"],

      })
      |> Repo.insert()
    end)

    |> Ecto.Multi.run(:push_to_income, fn _repo, %{update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_address_details: _update_address_details, update_client_id: update_client_id, update_personal_bank: _update_personal_bank, update_employee: _update_employee} ->
    Income_Details.changeset(%Income_Details{}, %{

      pay_day: params["pay_day"],
      gross_pay: params["gross_pay"],
      total_deductions: params["total_deductions"],
      net_pay: params["net_pay"],
      total_expenses: params["total_expenses"],
      upload_payslip: params["upload_payslip"],
      userId: update_client_id.id,

      })
      |> Repo.insert()
    end)

    |> Ecto.Multi.run(:client_document, fn _repo, %{update_userbiodate: update_userbiodate, update_employment_details: _update_employment_details, update_address_details: _update_address_details, update_client_id: update_client_id, update_personal_bank: _update_personal_bank, update_employee: _update_employee, push_to_income: _push_to_income} ->
      Loanmanagementsystem.Services.ClientUploads.client_upload(%{ "process_documents" => params, "conn" => conn, "company_id" => String.to_integer(params["company_id"]), "individualId" => update_client_id.id, "nrc" => update_userbiodate.meansOfIdentificationNumber })
    end)

    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_userbiodate: _update_userbiodate, update_employment_details: _update_employment_details, update_address_details: _update_address_details, update_client_id: update_client_id, update_personal_bank: _update_personal_bank, update_employee: _update_employee, push_to_income: _push_to_income} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated Merchant Successfully",
        user_id: update_client_id.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated Merchant Details")
        |> redirect(to: Routes.user_path(conn, :employee_dashboard))

      {:info, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.session_path(conn, :merchant_profile_update))
    end
  end

  def self_register_employee(conn, _request) do
    companies = Loanmanagementsystem.Companies.list_all_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "self_register_employee.html", companies: companies, departments: departments, banks: banks, town: town, province: province)
  end

  def self_register_employer(conn, _request) do
    companies = Loanmanagementsystem.Companies.list_all_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    town = Loanmanagementsystem.Maintenance.list_tbl_district()
    province = Loanmanagementsystem.Maintenance.list_tbl_province()
    render(conn, "self_register_employer.html", companies: companies, departments: departments, banks: banks, town: town, province: province)
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end
end
