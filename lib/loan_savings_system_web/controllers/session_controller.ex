defmodule LoanSavingsSystemWeb.SessionController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystemWeb.UserController
  alias LoanSavingsSystem.Logs
  # alias LoanSavingsSystem.Accounts
  alias LoanSavingsSystem.Accounts.UserRole
  alias LoanSavingsSystem.Accounts.User
  alias LoanSavingsSystem.Auth
  alias LoanSavingsSystem.Client.Clients
  alias LoanSavingsSystem.Client.UserBioData
  alias LoanSavingsSystem.Documents.DocumentType
  alias LoanSavingsSystem.Notification.OnPlatformNotification

  require Logger
  # alias LoanSavingsSystem.Accounts
  # alias MfzUssd.{Auth, Logs}

  alias LoanSavingsSystem.Repo
  require Record
  import Ecto.Query, only: [from: 2]

  plug(
    LoanSavingsSystemWeb.Plugs.RequireAuth
    when action in [:signout]
  )






  def test do # LoanSavingsSystemWeb.SessionController.test
    Repo.get_by(UserBioData, userId: 1)
  end

def get_home(conn, _params) do
  host = conn.host

  # client_session = get_session(conn, :client_session);
  # conn = if is_nil(client_session) do
  #   query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: cl.domain == ^host, select: cl
  #       client = Repo.all(query);
  #       client = Enum.at(client, 0)
  #       Logger.info "1<<<<<<<<<<<<<<<<<<<<<<<<"
  #       Logger.info (client.id);
  #   conn = put_session(conn, :client_id, client.id)

  # end
  # clientId = get_session(conn, :client_id)
  # Logger.info "<<<<<<<<<<<<<<<<<<<<<<<<"
  # Logger.info (clientId);


  render(conn, "username.html")
end

def username(conn, _params) do
  host = conn.host

  # client_session = get_session(conn, :client_session);
  # conn = if is_nil(client_session) do
  #   query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: cl.domain == ^host, select: cl
  #       client = Repo.all(query);
  #       client = Enum.at(client, 0)
  #       Logger.info "1<<<<<<<<<<<<<<<<<<<<<<<<"
  #       Logger.info (client.id);
  #   conn = put_session(conn, :client_id, client.clientId)

  # end
  # clientId = get_session(conn, :client_id)
  # Logger.info "<<<<<<<<<<<<<<<<<<<<<<<<"
  # Logger.info (clientId);


  render(conn, "username.html")
end

def get_username(conn, %{"username"=> username}) do

  with {:error, _reason} <- UserController.get_user_by_email(String.trim(username)) do
    conn
    |> put_flash(:error, "Username does not Exit")
    |> put_layout(false)
    |> render("username.html")
  else
  {:ok, user} ->
    cond do
      user.status == "ACTIVE" ->
          cond do

            user.status == "ACTIVE" ->
              conn
              #|> put_session(:current_user, user.id)
              #|> put_session(:session_timeout_at, session_timeout_at())
              |> redirect(to: Routes.session_path(conn, :new, %{"userId" => user.id, "username" => username}))

          end
      true ->
        conn
        # |> put_status(405)
        # |> put_layout(false)
        |> redirect(to: Routes.session_path(conn, :error_405))
    end
  end
# rescue
#   _ ->
#     conn
#     |> put_flash(:error, "An error occured. login failed")
#     |> put_layout(false)
#     |> render("index.html")
end

  #def new(conn, _params) do
    #render(conn, "index.html")
    #render(conn, "login_step_two")
  #end

  def new(conn, params) do
    userId = params["userId"];
    username = params["username"];
      #%{"userId" => userId, "username" => username}
    #userId = get_session(conn, :current_user_id)
    Logger.info ">>>>>>>"
    Logger.info userId
    Logger.info username


    query = from uR in UserRole, where: uR.userId == ^userId, select: uR
        userRoles = Repo.all(query)


    query = from u in User, where: u.username == ^username, select: u
        users = Repo.all(query);

    user = Enum.at(users, 0);



    if (Enum.count(userRoles)>0) do
        if is_nil(user.password) do
            render(conn, "get_login_validate_otp.html", userRoles: userRoles, username: username)
        else
            render(conn, "login_step_two.html", userRoles: userRoles, username: username)
        end
    else
        conn
            |> put_flash(:info, "Sign In failed.")
            |> redirect(to: Routes.user_path(conn, :get_login_step_one))
    end
end

def validate_otp(conn, params) do
    username = params["username"];
    otp1 = params["otp1"]
    otp2 = params["otp2"]
    otp3 = params["otp3"]
    otp4 = params["otp4"]
    otp = "#{otp1}#{otp2}#{otp3}#{otp4}"
    uRoleType = params["id_type"]
    Logger.info ("uRoleType...#{uRoleType}");

    query = from uB in User, where: uB.username == ^username, select: uB
      users = Repo.all(query)

    user = Enum.at(users, 0)

    query = from uB in UserRole, where: uB.userId == ^user.id and uB.id == ^ uRoleType and uB.otp == ^otp, select: uB
      userRoles = Repo.all(query)

    if(!is_nil(userRoles) && Enum.count(userRoles)>0) do
        userRole = Enum.at(userRoles, 0);

        userRole = UserRole.changeset(userRole,
        %{
            clientId: userRole.clientId,
            roleType: userRole.roleType,
            status: userRole.status,
            userId: userRole.userId,
            otp: nil
        })

        Repo.update!(userRole);
        userId = get_session(conn, :current_user)
        Logger.info ".............User Id #{userId}"
        if(is_nil(userId)) do
            conn
            |> redirect(to: Routes.session_path(conn, :new_user_set_password, %{"username" => username, "uRoleType" => uRoleType}))
        else
            conn
            |> redirect(to: Routes.user_path(conn, :savings_dashboard))
        end
    else
        conn
        |> put_flash(:error, "Invalid OTP provided for the role you have provided")
        |> redirect(to: Routes.session_path(conn, :username))
    end


end


def new_user_set_password(conn, %{"username"=> username, "uRoleType"=> uRoleType}) do
    #userId = get_session(conn, :current_user_id)
    Logger.info ">>>>>>>"
    Logger.info uRoleType
    Logger.info username


    query = from u in User, where: u.username == ^username, select: u
        users = Repo.all(query);

        Logger.info(Enum.count(users));
    user = Enum.at(users, 0);
    userId = user.id;


    query = from uR in UserRole, where: uR.userId == ^userId and uR.id == ^uRoleType, select: uR
        userRoles = Repo.all(query)

    if Enum.count(userRoles)>0 do
        userRole = Enum.at(userRoles, 0);
        if(!is_nil(userRole) && is_nil(userRole.otp)) do
            render(conn, "new_user_set_password.html", userRole: userRole, username: username)
        else
            conn
            |> put_flash(:danger, "Sign In failed.")
            |> redirect(to: Routes.user_path(conn, :get_login_step_one))
        end



    else

    end



end






def post_new_user_set_password(conn, params) do
    username = params["username"];
    userRoleId = params["userRoleId"];
    password = params["password"];
    cpassword = params["cpassword"];

    Logger.info "password...#{password}"
    Logger.info "cpassword...#{cpassword}"
    if password==cpassword do
        query = from uB in User, where: uB.username == ^username, select: uB
            users = Repo.all(query)

        if Enum.count(users)>0 do
            user = Enum.at(users, 0);

            changeset = User.changeset(user, %{
                clientId: user.clientId,
                createdByUserId: user.createdByUserId,
                password: password,
                status: user.status,
                username: user.username
            });

            case Repo.update(changeset) do
                {:ok, changeset} ->
                    user_id = user.id
                    query = from uB in UserBioData, where: uB.userId == ^user_id, select: uB
                      userBioData = Repo.all(query)

                    currentUserBioData = Enum.at(userBioData, 0)


                    query = from uB in UserRole, where: uB.id == ^userRoleId, select: uB
                        userRoles = Repo.all(query)

                    currentUserRole = Enum.at(userRoles, 0)

                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    |> redirect(to: Routes.user_path(conn, :savings_dashboard))
                {:error, changeset} ->
                    errMessage = User.changeset_error_to_string(changeset);
                    conn
                    |> put_flash(:error, errMessage)
                    |> redirect(to: Routes.session_path(conn, :new_user_set_password, %{"username" => username, "uRoleType" => userRoleId}))

            end


        else
            conn
            |> put_flash(:error, "Invalid login details provided")
            |> redirect(to: Routes.session_path(conn, :new_user_set_password, %{"username" => username, "uRoleType" => userRoleId}))
        end
    else
        conn
        |> put_flash(:error, "Password provded must match the confirmation password you provided")
        |> redirect(to: Routes.session_path(conn, :new_user_set_password, %{"username" => username, "uRoleType" => userRoleId}))
    end
end


def get_login_validate_otp(conn, %{"username"=> username, "uRoleType"=> uRoleType} = params) do
      query = from uB in UserRole, where: uB.id == ^uRoleType, select: uB
          userRoles = Repo.all(query)
          username_data = params["username"]
          get_email = Repo.get_by(User, username: username_data)
      render(conn, "get_login_validate_otp.html", userRoles: userRoles, username: username, get_email: get_email);
end

def create(conn, params) do
  with {:error, _reason} <- UserController.get_user_by_email(String.trim(params["username"])) do
    conn
    |> put_flash(:error, "Email do not match")
    |> put_layout(false)
    |> render("index.html")
  else
    {:ok, user} ->
      with {:error, _reason} <- Auth.confirm_password(user, String.trim(params["password"])) do
        conn
        |> put_flash(:error, "Password do not match")
        |> put_layout(false)
        |> render("index.html")
      else
            {:ok, _} ->
              cond do
                user.status == "ACTIVE" ->
                  {:ok, _} = Logs.create_user_logs(%{user_id: user.id, activity: "logged in"})
                    #cond do

                      #user.id == 1 ->
                        user_id = user.id
                        query = from uB in UserBioData, where: uB.userId == ^user_id, select: uB
                          userBioData = Repo.all(query)

                        currentUserBioData = Enum.at(userBioData, 0)

                        userRoleId = params["id_type"];
                        query = from uB in UserRole, where: uB.id == ^userRoleId, select: uB
                            userRoles = Repo.all(query)

                        currentUserRole = Enum.at(userRoles, 0)

                        notification = Repo.all(from m in OnPlatformNotification, where: m.status == ^false)
                        admin_notify = Enum.filter(notification, fn map -> map.belongs_to == "ADMIN"  end)
                        sme_notify = Enum.filter(notification, fn map -> map.belongs_to == "SME"  end)
                        offtaker_notify = Enum.filter(notification, fn map -> map.belongs_to == "OFFTAKER"  end)
                        employer_notify = Enum.filter(notification, fn map -> map.belongs_to == "EMPLOYER"  end)
                        employee_notify = Enum.filter(notification, fn map -> map.belongs_to == "EMPLOYEE"  end)
                        individual_notify = Enum.filter(notification, fn map -> map.belongs_to == "INDIVIDUAL"  end)
                        if(!is_nil(currentUserRole.otp)) do

                          Logger.info "OTP.....#{currentUserRole.otp}"
                          #render(conn, "get_login_validate_otp.html", userRoles: userRoles, username: user.username);
                          conn
                            |> put_session(:current_user, user.id)
                            |> put_session(:session_timeout_at, session_timeout_at())
                            |> put_session(:current_user_bio_data, currentUserBioData)
                            |> put_session(:current_user_role, currentUserRole)
                            |> redirect(to: Routes.session_path(conn, :get_login_validate_otp, %{"username" =>  user.username, "uRoleType" => userRoleId}))

                        else

                        cond do

                          currentUserRole.roleType == "ADMIN" ->
                            conn
                            |> put_session(:current_user, user.id)
                            |> put_session(:session_timeout_at, session_timeout_at())
                            |> put_session(:current_user_bio_data, currentUserBioData)
                            |> put_session(:current_user_role, currentUserRole)# savings_dashboard
                            |> redirect(to: Routes.user_path(conn, :savings_dashboard))

                          currentUserRole.roleType == "SME" ->
                            conn
                            |> put_session(:current_user, user.id)
                            |> put_session(:session_timeout_at, session_timeout_at())
                            |> put_session(:current_user_bio_data, currentUserBioData)
                            |> put_session(:current_user_role, currentUserRole)
                            |> put_session(:notification, sme_notify)
                            |> redirect(to: Routes.user_path(conn, :sme_dashboard))

                          currentUserRole.roleType == "OFFTAKER" ->
                            conn
                            |> put_session(:current_user, user.id)
                            |> put_session(:session_timeout_at, session_timeout_at())
                            |> put_session(:current_user_bio_data, currentUserBioData)
                            |> put_session(:current_user_role, currentUserRole)
                            |> put_session(:notification, offtaker_notify)
                            |> redirect(to: Routes.user_path(conn, :offtaker_dashboard))

                          currentUserRole.roleType == "EMPLOYER" ->
                            conn
                            |> put_session(:current_user, user.id)
                            |> put_session(:session_timeout_at, session_timeout_at())
                            |> put_session(:current_user_bio_data, currentUserBioData)
                            |> put_session(:current_user_role, currentUserRole)
                            |> put_session(:notification, employer_notify)
                            |> redirect(to: Routes.user_path(conn, :employer_dashboard))

                          # currentUserRole.roleType == "EMPLOYER" ->
                          #   conn
                          #   |> put_session(:current_user, user.id)
                          #   |> put_session(:session_timeout_at, session_timeout_at())
                          #   |> put_session(:current_user_bio_data, currentUserBioData)
                          #   |> put_session(:current_user_role, currentUserRole)
                          #   |> put_session(:notification, employer_notify)
                          #   |> redirect(to: Routes.user_path(conn, :employer_dashboard))
                            |> redirect(to: Routes.user_path(conn, :employer_dashboard))

                          currentUserRole.roleType == "EMPLOYER" ->
                            conn
                            |> put_session(:current_user, user.id)
                            |> put_session(:session_timeout_at, session_timeout_at())
                            |> put_session(:current_user_bio_data, currentUserBioData)
                            |> put_session(:current_user_role, currentUserRole)
                            |> redirect(to: Routes.user_path(conn, :employer_dashboard))

                          currentUserRole.roleType == "CLIENT_ADMIN_APPROVER" ->
                            conn
                            |> put_session(:current_user, user.id)
                            |> put_session(:session_timeout_at, session_timeout_at())
                            |> put_session(:current_user_bio_data, currentUserBioData)
                            |> put_session(:current_user_role, currentUserRole)
                            |> put_session(:notification, notification)
                            |> redirect(to: Routes.user_path(conn, :employer_dashboard))

                          currentUserRole.roleType == "EMPLOYEE" ->
                            conn
                            |> put_session(:current_user, user.id)
                            |> put_session(:session_timeout_at, session_timeout_at())
                            |> put_session(:current_user_bio_data, currentUserBioData)
                            |> put_session(:current_user_role, currentUserRole)
                            |> put_session(:notification, employee_notify)
                            |> redirect(to: Routes.user_path(conn, :employee_dashboard))

                          currentUserRole.roleType == "INDIVIDUAL" ->
                            conn
                            |> put_session(:current_user, user.id)
                            |> put_session(:session_timeout_at, session_timeout_at())
                            |> put_session(:current_user_bio_data, currentUserBioData)
                            |> put_session(:current_user_role, currentUserRole)
                            |> put_session(:notification, individual_notify)
                            |> redirect(to: Routes.individual_path(conn, :individual_dashboard))
                        end

                          #user.id == 1 ->
                          #  conn
                          #  |> put_session(:current_user, user.id)
                          #  |> put_session(:session_timeout_at, session_timeout_at())
                          #  |> redirect(to: Routes.user_path(conn, :dashboard))
                        end

                    #end
                true ->
                  conn
                  # |> put_status(405)
                  # |> put_layout(false)
                  |> redirect(to: Routes.session_path(conn, :error_405))
              end
      end
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

  def error_405(conn, _params) do
    render(conn, "disabled_account.html")
  end

  def forgot_password(conn, _params) do
    Logger.info ">>>>>>>"
    render(conn, "forgot_password.html")
  end

  def recover_password(conn, params) do
    IO.inspect "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    IO.inspect params
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
            {:ok, %{systemparams: _systemparams}} ->
              # otp = systemparams.pin
              # Email.send_otp(params["username"], otp)
              conn
              |> put_flash(:info, "Email with OTP sent Successfully. Please Enter the OTP sent to your mail")
              |> redirect(to: Routes.session_path(conn, :get_forgot_password_validate_otp, username: username_data))

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

  def get_forgot_password_validate_otp(conn, %{"username"=> username} = params) do
    query = from uB in User, where: uB.username == ^username, select: uB
        userRoles = Repo.all(query)
    username_data = params["username"]
      get_username = Repo.get_by(User, username: username_data)
    render(conn, "get_forgot_password_validate_otp.html",userRoles: userRoles, username: username, get_username: get_username);
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
    IO.inspect user

    if(!is_nil(users) && Enum.count(users)>0) do
      users = Enum.at(users, 0);

      users = User.changeset(users,
        %{
            pin: nil
        })

        Repo.update!(users);
        system_data = Repo.get_by(User, username: username_data)
        IO.inspect system_data
        if(is_nil(system_data)) do
          conn
          |> put_flash(:error, "Invalid OTP provided")
          |> redirect(to: Routes.session_path(conn, :get_forgot_password_validate_otp, username: username_data))
        else
            conn
            |> redirect(to: Routes.session_path(conn, :forgot_password_user_set_password, username: username_data))
        end
    else
        conn
        |> put_flash(:error, "Invalid OTP provided")
        |> redirect(to: Routes.session_path(conn, :get_forgot_password_validate_otp, username: username_data))
    end
  end

  def forgot_password_user_set_password(conn, %{"username"=> username} = params) do
    username_data = params["username"]

    get_username = Repo.get_by(User, username: username_data)
    query = from u in User, where: u.username == ^username_data, select: u
        users = Repo.all(query);

        Logger.info(Enum.count(users));
        user = Enum.at(users, 0);
        IO.inspect user

    if Enum.count(users)>0 do
      users = Enum.at(users, 0);
        if(!is_nil(users) && is_nil(users.pin)) do
            render(conn, "forgot_password_user_set_password.html", username: username, get_username: get_username)
        else
            conn
            |> put_flash(:danger, "Sign In failed.")
            |> redirect(to: Routes.session_path(conn, :forgot_password_user_set_password, username: username, get_username: get_username))
        end
    else

    end
    # render(conn, "new_user_set_password.html", email: email)
  end

  def forgot_password_post_new_user_set_password(conn, params) do
    username_data = params["username"];
    password = params["password"];
    cpassword = params["cpassword"];

    Logger.info "password...#{password}"
    Logger.info "cpassword...#{cpassword}"
    if password==cpassword do
        query = from uB in User, where: uB.username == ^username_data, select: uB
            users = Repo.all(query)

        if Enum.count(users)>0 do
            user = Enum.at(users, 0);

            changeset = User.changeset(user, %{
                password: password,
            });

            case Repo.update(changeset) do
                {:ok, changeset} ->
                  IO.inspect "+++++++++++++++++++++++++++++++++++="
                  IO.inspect changeset

                  render(conn, "username.html")

                {:error, changeset} ->
                    errMessage = User.changeset_error_to_string(changeset);
                    conn
                    |> put_flash(:error, errMessage)
                    |> redirect(to: Routes.session_path(conn, :forgot_password_user_set_password, username: username_data))

            end

        else
            conn
            |> put_flash(:error, "Invalid login details provided")
            |> redirect(to: Routes.session_path(conn, :forgot_password_user_set_password, username: username_data))
        end
    else
        conn
        |> put_flash(:error, "Password provded must match the confirmation password you provided")
        |> redirect(to: Routes.session_path(conn, :forgot_password_user_set_password, username: username_data))
    end
  end

    def register(conn, _params) do
        resp = Repo.all(from m in DocumentType, where: m.required == ^"YES" and m.status == ^"ACTIVE" and m.applicable_to == ^"REGISTRATION")
        render(conn, "register.html",
        ind: Enum.filter(resp, fn map -> map.belongs_to == "INDIVIDUAL" end),
        cop: Enum.filter(resp, fn map -> map.belongs_to == "COMPANY" end),
        sme: Enum.filter(resp, fn map -> map.belongs_to == "COMPANY" end)
      )
    end


    #==================================== REGISTRATION
    alias LoanSavingsSystem.Registration
    def register_user(conn, params) do
      case Registration.register(conn, params) do
        {:ok, resp} ->
          redirect(conn, to: Routes.session_path(conn, :username))
        {:error, msg} ->
          redirect(conn, to: Routes.session_path(conn, :username))
      end
    end

    def register_individual(conn, params) do
      case Registration.register_individual(conn, params) do
        {:ok, resp} ->
          redirect(conn, to: Routes.session_path(conn, :username))
        {:error, msg} ->
          redirect(conn, to: Routes.session_path(conn, :username))
      end
      # redirect(conn, to: Routes.session_path(conn, :register))
    end

  def traverse_errors(errors), do: for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"

end
