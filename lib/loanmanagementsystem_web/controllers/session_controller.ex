defmodule LoanmanagementsystemWeb.SessionController do
  use LoanmanagementsystemWeb, :controller

  require Logger
  # alias Rhema.Accounts
  # alias MfzUssd.{Auth, Logs}

  alias Loanmanagementsystem.Repo
  alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Auth
  alias Loanmanagementsystem.Logs
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.User
  require Record
  import Ecto.Query, only: [from: 2]

  plug(
    LoanmanagementsystemWeb.Plugs.RequireAuth
    when action in [:signout]
  )

  # def get_home(conn, _params) do
  # host = conn.host

  # client_session = get_session(conn, :client_session);
  # conn = if is_nil(client_session) do
  #   query = from cl in Rhema.SystemSetting.ClientTelco, where: cl.domain == ^host, select: cl
  #       client = Repo.all(query);
  #       client = Enum.at(client, 0)
  #       Logger.info "1<<<<<<<<<<<<<<<<<<<<<<<<"
  #       Logger.info (client.id);
  #   conn = put_session(conn, :client_id, client.id)

  # end
  # clientId = get_session(conn, :client_id)
  # Logger.info "<<<<<<<<<<<<<<<<<<<<<<<<"
  # Logger.info (clientId);

  #   render(conn, "username.html")
  # end

  def username(conn, _params) do
    render(conn, "index.html")
  end

  def get_username(conn, %{"username" => username, "password" => password} = params) do
    with {:error, _reason} <- UserController.get_user_by_email(String.trim(params["username"])) do
      conn
      |> put_flash(:error, "Username or Password do not match")
      |> put_layout(false)
      |> render("index.html")
    else
      {:ok, user} ->
        with {:error, _reason} <- Auth.confirm_password(user, params["password"]) do
          conn
          |> put_flash(:error, "Password do not match")
          |> put_layout(false)
          |> render("index.html")
        else
          {:ok, _} ->
            cond do
              user.status == "ACTIVE" ->
                cond do
                  user.status == "ACTIVE" ->
                    cond do
                      user.isStudent == true ->
                        conn
                        # |> put_session(:current_user, user.id)
                        # |> put_session(:session_timeout_at, session_timeout_at())
                        |> redirect(
                          to:
                            Routes.session_path(conn, :new, %{
                              "userId" => user.id,
                              "username" => username,
                              "password" => password
                            })
                        )

                      user.isStudent == false ->
                        conn
                        |> put_flash(:error, "Username or Password do not match")
                        |> put_layout(false)
                        |> render("index.html")
                    end
                end

              true ->
                conn
                # |> put_status(405)
                # |> put_layout(false)
                |> redirect(to: Routes.session_path(conn, :error_405))
            end
        end
    end

    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occured. login failed")
    #     |> put_layout(false)
    #     |> render("index.html")
  end

  def create(conn, params) do
    with {:error, _reason} <- UserController.get_user_by_email(String.trim(params["username"])) do
      conn
      |> put_flash(:error, "Username or Password do not match")
      |> put_layout(false)
      |> render("index.html")
    else
      {:ok, user} ->
        with {:error, _reason} <- Auth.confirm_password(user, String.trim(params["password"])) do
          conn
          |> put_flash(:error, "Username or Password do not match")
          |> put_layout(false)
          |> render("index.html")
        else
          {:ok, _} ->
            cond do
              user.status == "ACTIVE" ->
                {:ok, _} = Logs.create_user_logs(%{user_id: user.id, activity: "logged in"})

                user_id = user.id
                query = from uB in UserBioData, where: uB.userId == ^user_id, select: uB
                userBioData = Repo.all(query)
                currentUserBioData = Enum.at(userBioData, 0)

                IO.inspect("[{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}]")
                IO.inspect(currentUserBioData)

                query = from uB in UserRole, where: uB.userId == ^user_id, select: uB
                userRoles = Repo.all(query)
                currentUserRole = Enum.at(userRoles, 0)

                IO.inspect("[[[[[[[[[[[[[]]]]]]]]]]]]]]]")
                IO.inspect(currentUserRole)

                cond do
                  currentUserRole.roleType == "ADMIN" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    |> redirect(to: Routes.user_path(conn, :admin_dashboard))

                  currentUserRole.roleType == "INDIVIDUALS" ->
                    conn
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
                end

              true ->
                conn
                # |> put_status(405)
                # |> put_layout(false)
                |> redirect(to: Routes.session_path(conn, :error_405))
            end
        end
    end

    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occured. login failed")
    #     |> put_layout(false)
    #     |> render("index.html")
  end

  def new(conn, params) do
    userId = params["userId"]
    username = params["username"]
    password = params["password"]
    # %{"userId" => userId, "username" => username}
    # userId = get_session(conn, :current_user_id)
    Logger.info(">>>>>>>")
    Logger.info(userId)
    Logger.info(username)

    query = from uR in UserRole, where: uR.userId == ^userId, select: uR
    userRoles = Repo.all(query)

    query = from u in User, where: u.username == ^username, select: u
    users = Repo.all(query)

    user = Enum.at(users, 0)

    if Enum.count(userRoles) > 0 do
      if is_nil(user.password) do
        render(conn, "get_login_validate_otp.html",
          userRoles: userRoles,
          username: username,
          password: password
        )
      else
        render(conn, "login_step_two.html",
          userRoles: userRoles,
          username: username,
          password: password
        )
      end
    else
      conn
      |> put_flash(:info, "Sign In failed.")
      |> redirect(to: Routes.user_path(conn, :get_login_step_one))
    end
  end

  defp session_timeout_at do
    DateTime.utc_now() |> DateTime.to_unix() |> (&(&1 + 3_600)).()
  end

  def signout(conn, _params) do
    {:ok, _} = Logs.create_user_logs(%{user_id: conn.assigns.user.id, activity: "logged out"})

    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.session_path(conn, :username))
  rescue
    _ ->
      conn
      |> configure_session(drop: true)
      |> redirect(to: Routes.session_path(conn, :username))
  end

  def register(conn, params) do
    render(conn, "register.html")
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

      Repo.update!(userRole)
      userId = get_session(conn, :current_user)
      Logger.info(".............User Id #{userId}")

      if(is_nil(userId)) do
        conn
        |> put_flash(:error, "Create Password and Sign in")
        |> redirect(
          to:
            Routes.session_path(conn, :new_user_set_password,
              username: "#{username}",
              uRoleType: "#{uRoleType}"
            )
        )
      else
        conn
        |> put_flash(:error, "Create Password and Sign in")
        |> redirect(
          to:
            Routes.session_path(conn, :new_user_set_password,
              username: "#{username}",
              uRoleType: "#{uRoleType}"
            )
        )
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

  def post_new_user_set_password(conn, params) do
    username = params["username"]
    userRoleId = params["userRoleId"]
    password = params["password"]
    cpassword = params["cpassword"]

    Logger.info("password...#{password}")
    Logger.info("cpassword...#{cpassword}")

    if password == cpassword do
      query = from uB in User, where: uB.username == ^username, select: uB
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
            query = from uB in UserBioData, where: uB.userId == ^user_id, select: uB
            userBioData = Repo.all(query)

            currentUserBioData = Enum.at(userBioData, 0)

            query = from uB in UserRole, where: uB.id == ^userRoleId, select: uB
            userRoles = Repo.all(query)

            currentUserRole = Enum.at(userRoles, 0)

            cond do
              currentUserRole.roleType == "ADMIN" ->
                conn
                |> put_session(:current_user, user.id)
                |> put_session(:session_timeout_at, session_timeout_at())
                |> put_session(:current_user_bio_data, currentUserBioData)
                |> put_session(:current_user_role, currentUserRole)
                |> redirect(to: Routes.user_path(conn, :admin_dashboard))

              currentUserRole.roleType == "INDIVIDUALS" ->
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

  def error_405(conn, _params) do
    render(conn, "disabled_account.html")
  end


  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end
end
