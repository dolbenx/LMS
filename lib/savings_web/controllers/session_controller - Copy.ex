defmodule SavingsWeb.CopySessionController do
  use SavingsWeb, :controller
  require Logger
  alias Savings.Logs
  alias Savings.Accounts
  alias SavingsWeb.UserController
  alias Savings.Auth
  alias Savings.Accounts.UserRole
  alias Savings.Accounts.User
  alias Savings.Emails.Email
  alias Savings.Notifications.Sms
  alias Auth

  alias Savings.Repo
  require Record
  import Ecto.Query, only: [from: 2]

  plug(SavingsWeb.Plugs.RequireAuth when action in [:signout])

  def username(conn, _params) do
    put_layout(conn, false)
    |> render("username.html")
  end

  def create(conn, params) do
    with {:error, _reason} <- UserController.get_user_by_email(String.trim(params["username"])) do
      conn
      |> put_flash(:error, "Email/password not match")
      |> put_layout(false)
      |> render("username.html")
    else
      {:ok, user} ->
        with {:error, _reason} <- Auth.confirm_password(user, String.trim(params["password"])) do
          prepare_login_attempt(user)

          conn
          |> put_flash(:error, "Email/password not match")
          |> put_layout(false)
          |> render("username.html")
        else
          {:ok, _} ->
            IO.inspect(user, label: "check my user here \n\n\n")

            cond do
              user.status == "ACTIVE" ->
                {:ok, _} =
                  Savings.Logs.create_user_logs(%{
                    user_id: user.id,
                    activity: "logged in"
                  })

                logon_dt = Timex.format!(Timex.local(), "%Y-%m-%d %H:%M:%S", :strftime)
                remote_ip = conn.remote_ip |> :inet.ntoa() |> to_string()

                {:ok, user} =
                  Accounts.update_user(user, %{
                    remote_ip: remote_ip,
                    last_login_dt: logon_dt
                    # login_attempt: 0
                  })

                user_id = user.id

                query =
                  from(uB in Savings.Client.UserBioData,
                    where: uB.userId == ^user.id,
                    select: uB
                  )

                userBioData = Repo.all(query)

                currentUserBioData = Enum.at(userBioData, 0)

                query =
                  from uB in Savings.Accounts.UserRole,
                    where: uB.userId == ^user_id,
                    select: uB

                userRoles = Repo.all(query)

                currentUserRole = Enum.at(userRoles, 0)

                query =
                  from uR in Savings.Accounts.Role,
                    where: uR.id == ^user_id,
                    select: uR

                myUserRole = Repo.all(query)

                mycurrentUserRole = Enum.at(myUserRole, 0)

                # case currentUserRole.roleType do
                #   "ADMIN" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                # |> put_session(:myuser_role, mycurrentUserRole)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> redirect(to: Routes.user_path(conn, :savings_dashboard))

              # end

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
      Savings.Logs.create_user_logs(%{
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
    max_attempts = 6
    status = if user.login_attempt < max_attempts, do: "ACTIVE", else: "INACTIVE"
    Accounts.update_user(user, %{login_attempt: user.login_attempt + 1, status: status})
  end

  def error_405(conn, _params) do
    render(conn, "disabled_account.html")
  end

  def forgot_password(conn, _params) do
    Logger.info(">>>>>>>")
    render(conn, "forgot_password.html")
  end

  def recover_password(conn, params) do
    IO.inspect("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    IO.inspect(params)
    random_int = to_string(Enum.random(1111..9999))
    username_data = params["username"]
    system_data = Repo.get_by(User, username: username_data)

    if system_data == nil do
      conn
      |> put_flash(:error, "Email Does Not Exist on the system.")
      |> redirect(to: Routes.session_path(conn, :forgot_password))
    else
      if system_data.status == "ACTIVE" do
        Ecto.Multi.new()
        |> Ecto.Multi.update(:systemparams, User.changeset(system_data, %{pin: random_int}))
        |> Repo.transaction()
        |> case do
          {:ok, %{systemparams: systemparams}} ->
            otp = systemparams.pin

            IO.inspect(
              "++++++++++++++++++++++++++---------------------------------------------------------+++++++++++++++++++++++++++++++"
            )

            IO.inspect(system_data.id)
            userid = system_data.id
            query = from bd in Savings.Client.UserBioData, where: bd.userId == ^userid, select: bd
            client = Repo.one(query)
            firstName = client.firstName
            emailAddress = client.emailAddress
            mobileNumber = client.mobileNumber
            naive_datetime = Timex.now()

            # Email.send_otp(emailAddress, otp)

            #   sms = %{
            #     mobile: mobileNumber,
            #     msg: "Dear #{firstName}, Your OTP is: #{otp}",
            #     status: "READY",
            #     type: "SMS",
            #     msg_count: "1",
            #     date_sent: naive_datetime
            #   }
            #   Sms.changeset(%Sms{}, sms)
            #   |> Repo.insert()

            conn
            |> put_flash(
              :info,
              "Email with OTP sent Successfully. Please Enter the OTP sent to your mail"
            )
            |> redirect(
              to:
                Routes.session_path(conn, :get_forgot_password_validate_otp,
                  username: username_data
                )
            )

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.session_path(conn, :forgot_password))
        end
      else
        conn
        |> put_flash(:error, "User is Disabled, Please Contact MFZ.")
        |> redirect(to: Routes.session_path(conn, :forgot_password))
      end
    end
  end

  def get_forgot_password_validate_otp(conn, %{"username" => username} = params) do
    query = from uB in User, where: uB.username == ^username, select: uB
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

    query = from uB in User, where: uB.username == ^username_data and uB.pin == ^pin, select: uB
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
    query = from u in User, where: u.username == ^username_data, select: u
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
      query = from uB in User, where: uB.username == ^username_data, select: uB
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
      |> put_flash(:error, "Password provded must match the confirmation password you provided")
      |> redirect(
        to: Routes.session_path(conn, :forgot_password_user_set_password, username: username_data)
      )
    end
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end
end
