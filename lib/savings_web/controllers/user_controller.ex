defmodule SavingsWeb.UserController do
  use SavingsWeb, :controller
  use Ecto.Schema
  alias Savings.Repo
  import Ecto.Query, warn: false
  alias Savings.Accounts
  alias Savings.Accounts.User
  alias Savings.Accounts.UserRole
  alias Savings.Client.UserBioData
  alias Savings.Emails.Email
  alias Savings.Logs.UserLogs
  alias Savings.Notifications.Sms
  alias Savings.Accounts.BankStaffRole
  alias Savings.{Logs, Repo, Logs.UserLogs}
  alias Savings.Auth
  alias Savings.Transactions
  alias Savings.FixedDeposit
  alias Savings.FixedDeposit.FixedDeposits
  alias Savings.Divestments.Divestment
  use PipeTo.Override
  require Logger

  # plug(
  #   SavingsWeb.Plugs.RequireAuth
  #   when action not in [:unknown]
  # )

  # plug(
  #   SavingsWeb.Plugs.EnforcePasswordPolicy
  #   when action not in [:unknown, :new_password, :change_password]
  # )

  # plug SavingsWeb.Plugs.Authenticate,
  #      [module_callback: &SavingsWeb.UserController.authorize/1]
  #      when action not in [
  #             :unknown,
  #             :savings_dashboard,
  #             :user_creation,
  #             :employee_dashboard,
  #             :employer_dashboard,
  #             :dashboard,
  #             :user_mgt,
  #             :savings_user_mgt,
  #             :user_roles,
  #             :new_password,69+-
  #             :user_logs,
  #             :ussd_logs,
  #             :edit_user_roles,
  #             :update,
  #             :view_user_roles,
  #             :change_status,
  #             :create_user_role,
  #             :admin_edit_user,
  #             :create_user,
  #             :generate_random_password,
  #             :change_password,
  #             :activate_admin,
  #             :deactivate_admin
  #           ]

  # plug SavingsWeb.Plugs.Authenticate,
  #      [module_callback: &SavingsWeb.UserController.authorize_role/1]
  #      when action not in [
  #             :unknown,
  #             :savings_dashboard,
  #             :user_creation,
  #             :employee_dashboard,
  #             :employer_dashboard,
  #             :dashboard,
  #             :user_mgt,
  #             :savings_user_mgt,
  #             :user_roles,
  #             :new_password,
  #             :user_logs,
  #             :ussd_logs,
  #             :edit_user_roles,
  #             :update,
  #             :view_user_roles,
  #             :change_status,
  #             :create_user_role,
  #             :admin_edit_user,
  #             :create_user,
  #             :generate_random_password,
  #             :change_password,
  #             :activate_admin,
  #             :deactivate_admin
  #           ]

  # plug SavingsWeb.Plugs.Authenticate,
  #      [module_callback: &SavingsWeb.UserController.authorize_user_logs/1]
  #      when action not in [
  #             :unknown,
  #             :savings_dashboard,
  #             :user_creation,
  #             :employee_dashboard,
  #             :employer_dashboard,
  #             :dashboard,
  #             :user_mgt,
  #             :savings_user_mgt,
  #             :user_roles,
  #             :new_password,
  #             :user_logs,
  #             :ussd_logs,
  #             :edit_user_roles,
  #             :update,
  #             :view_user_roles,
  #             :change_status,
  #             :create_user_role,
  #             :admin_edit_user,
  #             :create_user,
  #             :generate_random_password,
  #             :change_password,
  #             :activate_admin,
  #             :deactivate_admin
  #           ]

  def user_creation(conn, _params) do
    render(conn, "user_mgt.html")
  end

  def view_user_roles(conn, %{"id" => id}) do
    role =
      id
      |> Accounts.get_role!()
      |> Map.update!(:role_str, &AtomicMap.convert(&1, %{safe: false}))

    render(conn, "view_roles.html", role: role)
  end

  def edit_user_roles(conn, %{"id" => id}) do
    role =
      id
      |> Accounts.get_role!()
      |> Map.update!(:role_str, &AtomicMap.convert(&1, %{safe: false}))

    render(conn, "edit_roles.html", role: role)
  end

  def generate_otp do
    random_int = to_string(Enum.random(1111..9999))
    random_int
  end

  def get_user_by_email(username) do
    case Repo.get_by(User, username: username) do
      nil -> {:error, "invalid User Name address"}
      user -> {:ok, user}
    end
  end

  def get_user_by_user_role(userId) do
    case Accounts.get_users(userId) do
      nil ->
        {:error, "invalid User Name address"}

      user ->
        user
    end
  end

  def create_user(conn, params) do
    nrc = params["meansOfIdentificationNumber"]
    nrc = String.replace(nrc, "/", "")

    username = params["emailAddress"]
    params = Map.put(params, "status", "ACTIVE")
    params = Map.put(params, "auto_password", "Y")
    params = Map.put(params, "clientID", 1)
    get_username = Repo.get_by(User, username: username)
    # IO.inspect(myroleType, label: "@@@@@@@@@@@@@@@@ Check myroleType @@@@@@@@@@@@@@@@@@@@@ ")
    # IO.inspect(role_id, label: "%%%%%%%%%%%%%%% Check role_id %%%%%%%%%%%%%%%%%%%%\n ")

    params =
      Map.merge(params, %{
        "username" => username,
        "password" => params["password"],
        # "roleType" => Enum.at(myroleType, 1),
        "role_id" => params["role_id"]
      })

    case is_nil(get_username) do
      true ->
        Ecto.Multi.new()
        |> Ecto.Multi.insert(:create_user, User.changeset(%User{}, params))
        |> Ecto.Multi.run(:user_role, fn _, %{create_user: user} ->
          generate_otp = to_string(Enum.random(1111..9999))
          # Push Data To User Roles
          user_role = %{
            userId: user.id,
            roleId: user.role_id,
            roleType: "ADMIN",
            clientId: conn.assigns.user.clientId,
            status: user.status,
            otp: generate_otp
            # permissions: params["permissions"]
          }

          UserRole.changeset(%UserRole{}, user_role)
          |> Repo.insert()
        end)
        |> Ecto.Multi.run(:user_bio_data, fn _, %{create_user: user} ->
          # Push Data To Bio Data
          user_bio_data = %{
            firstName: params["firstName"],
            lastName: params["lastName"],
            userId: user.id,
            otherName: params["otherName"],
            dateOfBirth: params["dateOfBirth"],
            meansOfIdentificationType: params["meansOfIdentificationType"],
            meansOfIdentificationNumber: nrc,
            title: params["title"],
            gender: params["gender"],
            mobileNumber: params["phone_number"],
            emailAddress: params["emailAddress"],
            clientId: conn.assigns.user.clientId
          }

          UserBioData.changeset(%UserBioData{}, user_bio_data)
          |> Repo.insert()
        end)
        |> Ecto.Multi.run(:user_log, fn _, %{create_user: user} ->
          activity = "created user with id \"#{user.id}\" "
          # Push Data To User Logs
          user_log = %{
            user_id: conn.assigns.user.id,
            activity: activity
          }

          UserLogs.changeset(%UserLogs{}, user_log)
          |> Repo.insert()
        end)
        |> Ecto.Multi.run(:sms, fn _, %{user_bio_data: bio_data, user_role: user_role} ->
          otp = user_role.otp

          sms = %{
            mobile: bio_data.mobileNumber,
            msg:
              "Dear customer, Your Login Credentials. username: #{params["emailAddress"]}, password: #{params["password"]}, OTP: #{otp}",
            status: "READY",
            type: "SMS",
            msg_count: "1"
          }

          Sms.changeset(%Sms{}, sms)
          |> Repo.insert()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{create_user: _user, user_log: _user_log}} ->
            # Email.send_email(params["emailAddress"], params["password"], params["firstName"])

            conn
            |> put_flash(:info, "User Account created Successfully")
            |> redirect(to: Routes.user_path(conn, :user_mgt))

          {:error, _failed_operation, failed_value, _changes} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.user_path(conn, :user_mgt))
        end

      _ ->
        conn
        |> put_flash(:error, "User Role Already Exists")
        |> redirect(to: Routes.user_path(conn, :user_mgt))
    end
  end

  def create_new_user_role_for_existing_user(conn, params, userId) do
    generate_otp = to_string(Enum.random(1111..9999))
    # Push Data To User Roles
    user_role = %{
      userId: userId,
      roleType: params["roleType"],
      clientId: conn.assigns.user.clientId,
      status: conn.assigns.user.status,
      otp: generate_otp
    }

    UserRole.changeset(%UserRole{}, user_role)
    |> Repo.insert()

    # Push Data To Bio Data
    user_bio_data = %{
      firstName: params["firstName"],
      lastName: params["lastName"],
      userId: userId,
      otherName: params["otherName"],
      dateOfBirth: params["dateOfBirth"],
      meansOfIdentificationType: params["meansOfIdentificationType"],
      meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
      title: params["title"],
      gender: params["gender"],
      mobileNumber: params["mobileNumber"],
      emailAddress: params["emailAddress"],
      clientId: params["clientId"]
    }

    UserBioData.changeset(%UserBioData{}, user_bio_data)
    |> Repo.insert()
    |> Repo.transaction()
    |> case do
      {:ok, %{create_user: _user}} ->
        conn
        |> put_flash(:info, "User created Successfully")
        |> redirect(to: Routes.user_path(conn, :user_mgt))

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to create user.")
        |> redirect(to: Routes.user_path(conn, :user_mgt))
    end
  end

  # def savings_dashboard(conn, _params) do
  #  users = Accounts.list_tbl_users()
  #  get_bio_datas = Accounts.get_logged_user_details
  #  user = Accounts.get_user!(conn.assigns.user.id).id
  #  last_logged_in = Logs.last_logged_in(user)
  # render(conn, "savings_dashboard.html", users: users, get_bio_datas: get_bio_datas)
  # end

  def month(m) do
    year = Date.utc_today().year |> to_string()
    {:ok, result} = Timex.parse(year <> "-" <> m <> "-01", "{YYYY}-{0M}-{D}")
    DateTime.from_naive!(result, "Etc/UTC")
  end

  def savings_dashboard(conn, _params) do
    users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()

    logged_user = Savings.Accounts.get_logged_user_details_by_id(conn.assigns.user.id)

    IO.inspect(conn.assigns.user.role, label: "CHECK MY CONN HERE %%%%%%%%%%%%%%\n")
    #  user = Accounts.get_user!(conn.assigns.user.id).id
    # last_logged_in = Logs.last_logged_in(user)
    todays_transactions = Transactions.list_today_transactions()
    matured_transactions = FixedDeposit.list_matured_transactions()

    # for_fixed_transaction
    jandate = month("01")

    fxdjanstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(jandate) and
              au.inserted_at <= ^Timex.end_of_month(jandate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    febdate = month("02")

    fxdfebstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(febdate) and
              au.inserted_at <= ^Timex.end_of_month(febdate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    mardate = month("03")

    fxdmrcstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(mardate) and
              au.inserted_at <= ^Timex.end_of_month(mardate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    aprdate = month("04")

    fxdaprstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(aprdate) and
              au.inserted_at <= ^Timex.end_of_month(aprdate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    maydate = month("05")

    fxdmaystats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(maydate) and
              au.inserted_at <= ^Timex.end_of_month(maydate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    jundate = month("06")

    fxdjunstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(jundate) and
              au.inserted_at <= ^Timex.end_of_month(jundate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    juldate = month("07")

    fxdjulstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(juldate) and
              au.inserted_at <= ^Timex.end_of_month(juldate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    augdate = month("08")

    fxdaugstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(augdate) and
              au.inserted_at <= ^Timex.end_of_month(augdate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    sepdate = month("09")

    fxdsepstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(sepdate) and
              au.inserted_at <= ^Timex.end_of_month(sepdate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    octdate = month("10")

    fxdoctstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(octdate) and
              au.inserted_at < ^Timex.end_of_month(octdate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )



    novdate = month("11")

    fxdnovstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(novdate) and
              au.inserted_at <= ^Timex.end_of_month(novdate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    decdate = month("12")

    fxddecstats =
      Repo.one(
        from au in FixedDeposits,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(decdate) and
              au.inserted_at <= ^Timex.end_of_month(decdate) and au.fixedDepositStatus == "ACTIVE",
          select: sum(au.principalAmount)
      )

    # end_of_fixed_transaction

    # Divestment_transaction

    jandate = month("01")

    divjanstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(jandate) and
              au.inserted_at <= ^Timex.end_of_month(jandate) and au.divestmentType == "Active",
          select: sum(au.id)
      )

    febdate = month("02")

    divfebstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(febdate) and
              au.inserted_at <= ^Timex.end_of_month(febdate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    mardate = month("03")

    divmrcstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(mardate) and
              au.inserted_at <= ^Timex.end_of_month(mardate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    aprdate = month("04")

    divaprstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(aprdate) and
              au.inserted_at <= ^Timex.end_of_month(aprdate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    maydate = month("05")

    divmaystats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(maydate) and
              au.inserted_at <= ^Timex.end_of_month(maydate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    jundate = month("06")

    divjunstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(jundate) and
              au.inserted_at <= ^Timex.end_of_month(jundate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    juldate = month("07")

    divjulstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(juldate) and
              au.inserted_at <= ^Timex.end_of_month(juldate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    augdate = month("08")

    divaugstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(augdate) and
              au.inserted_at <= ^Timex.end_of_month(augdate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    sepdate = month("09")

    divsepstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(sepdate) and
              au.inserted_at <= ^Timex.end_of_month(sepdate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    octdate = month("10")

    divoctstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(octdate) and
              au.inserted_at <= ^Timex.end_of_month(octdate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    novdate = month("11")

    divnovstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(novdate) and
              au.inserted_at <= ^Timex.end_of_month(novdate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    decdate = month("12")

    divdecstats =
      Repo.one(
        from au in Divestment,
          where:
            au.inserted_at >= ^Timex.beginning_of_month(decdate) and
              au.inserted_at <= ^Timex.end_of_month(decdate) and
              au.divestmentType == "Full Divestment",
          select: sum(au.id)
      )

    # End_Divestment_transaction
    render(conn, "savings_dashboard.html",
      users: users,
      get_bio_datas: get_bio_datas,
      todays_transactions: todays_transactions,
      matured_transactions: matured_transactions,
      fxdjanstats: fxdjanstats,
      fxdfebstats: fxdfebstats,
      fxdmrcstats: fxdmrcstats,
      fxdaprstats: fxdaprstats,
      fxdmaystats: fxdmaystats,
      fxdjunstats: fxdjunstats,
      fxdjulstats: fxdjulstats,
      fxdaugstats: fxdaugstats,
      fxdsepstats: fxdsepstats,
      fxdoctstats: fxdoctstats,
      fxdnovstats: fxdnovstats,
      fxddecstats: fxddecstats,
      divjanstats: divjanstats,
      divfebstats: divfebstats,
      divmrcstats: divmrcstats,
      divaprstats: divaprstats,
      divmaystats: divmaystats,
      divjunstats: divjunstats,
      divjulstats: divjulstats,
      divaugstats: divaugstats,
      divsepstats: divsepstats,
      divoctstats: divoctstats,
      divnovstats: divnovstats,
      divdecstats: divdecstats,
      logged_user: logged_user
    )
  end

  def dashboard(conn, _params) do
    users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    #  user = Accounts.get_user!(conn.assigns.user.id).id
    # last_logged_in = Logs.last_logged_in(user)
    render(conn, "dashboard.html", users: users, get_bio_datas: get_bio_datas)
  end

  def user_mgt(conn, _params) do
    # bank_roles = Accounts.list_tbl_bank_staff_role()
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()

    user_roles = Savings.Accounts.list_tbl_roles() |> Enum.reject(&(&1.status != "ACTIVE"))

    # roles = Accounts.list_tbl_user_role()
    render(conn, "user_mgt.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      # bank_roles: bank_roles,
      user_roles: user_roles
    )
  end

  def savings_user_mgt(conn, _params) do
    bank_roles = Accounts.list_tbl_bank_staff_role()
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    # roles = Accounts.list_tbl_user_role()
    render(conn, "user_mgt.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      bank_roles: bank_roles
    )
  end

  def user_roles(conn, _params) do
    get_bio_datas = Accounts.get_logged_user_details()

    user_roles = Savings.Accounts.list_tbl_roles()
    render(conn, "user_roles.html", user_roles: user_roles, get_bio_datas: get_bio_datas)
  end

  def add_user_roles(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user_roles, BankStaffRole.changeset(%BankStaffRole{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{user_roles: user_roles} ->
      activity = "Created new Branch with ID \"#{user_roles.id}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user_roles: _user_roles, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "New Bank User Role Created successfully.")
        |> redirect(to: Routes.user_path(conn, :user_roles))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :user_roles))
    end

    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end

  def activate_admin(conn, params) do
    IO.inspect(params, label: "check my user")
    users_approve = Accounts.get_user!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "ACTIVE"}))
    |> Ecto.Multi.run(:user_log, fn _, %{users: _users} ->
      activity = "User Activated"

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: _users, user_log: _user_log}} ->
        conn |> json(%{message: "User approved successfully", status: 0})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
    end
  end

  def deactivate_admin(conn, params) do
    IO.inspect(params, label: "check my user")
    users_approve = Accounts.get_user!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "DEACTIVATED"}))
    |> Ecto.Multi.run(:user_log, fn _, %{users: _users} ->
      activity = "Account Deactivated"

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: _users, user_log: _user_log}} ->
        conn |> json(%{message: "Account Deativated successfully", status: 0})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
    end
  end

  def delete_admin(conn, params) do
    users_approve = Accounts.get_user!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "BLOCKED"}))
    |> Ecto.Multi.run(:user_log, fn _, %{users: _users} ->
      activity = "Account Deleted"

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: _users, user_log: _user_log}} ->
        conn |> json(%{message: "Account Deativated successfully", status: 0})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
    end
  end

  def getEmployerUserByMobileNumberAndRoleType(conn, params) do
    mobileNumber = params["mobileNumber"]
    roleType = params["roleType"]
    companyId = params["companyId"]
    userStatus = "ACTIVE"

    query =
      from cl in Savings.Accounts.User,
        where: cl.username == ^mobileNumber and cl.status == ^userStatus,
        select: cl

    users = Repo.all(query)

    if(Enum.count(users) == 0) do
      response = %{
        status: 0
      }

      SavingsWeb.ProductController.send_response(conn, response)
    else
      user = Enum.at(users, 0)

      query =
        from cl in Savings.Accounts.UserRole,
          where:
            cl.userId == ^user.id and cl.roleType == ^roleType and
              cl.companyId == ^companyId and cl.status == ^userStatus,
          select: cl

      userRoles = Repo.all(query)

      if(Enum.count(userRoles) == 0) do
        query =
          from cl in Savings.Client.UserBioData,
            where: cl.userId == ^user.id,
            select: cl

        userBioDatas = Repo.all(query)
        userBioData = Enum.at(userBioDatas, 0)

        query =
          from cl in Savings.Accounts.UserRole,
            where:
              cl.userId == ^user.id and
                cl.companyId == ^companyId and cl.status == ^userStatus,
            select: cl.roleType

        userRoles = Repo.all(query)

        response = %{
          status: 1,
          userBioData: userBioData,
          userRoles: Enum.join(userRoles, ", ")
        }

        SavingsWeb.ProductController.send_response(conn, response)
      else
        response = %{
          status: -1,
          message:
            "A company administrator of the same company having the same number already exists"
        }

        SavingsWeb.ProductController.send_response(conn, response)
      end
    end
  end

  def create_employer_admin(conn, params) do
    current_user = get_session(conn, :current_user)
    mobileNumber = params["mobileNumber"]
    companyId = params["companyId"]
    title = params["title"]
    first_name = params["first_name"]
    last_name = params["last_name"]
    email = params["email"]
    id_type = params["id_type"]
    id_no = params["id_no"]
    address = params["address"]
    sex = params["sex"]
    user_role = params["user_role"]
    age = params["age"]
    userStatus = "ACTIVE"
    roleType = "COMPANY ADMIN"
    clientId = get_session(conn, :client_id)

    query =
      from cl in Savings.Accounts.User,
        where: cl.username == ^mobileNumber and cl.status == ^userStatus,
        select: cl

    users = Repo.all(query)

    Logger.info("User Count ... #{Enum.count(users)}")

    if(Enum.count(users) == 0) do
      query = from cl in Savings.Companies.Company, where: cl.id == ^companyId, select: cl

      companies = Repo.all(query)
      company = Enum.at(companies, 0)
      registrationNumber = company.registrationNumber

      current_user = get_session(conn, :current_user)
      mobileNumber = params["mobileNumber"]
      companyId = params["companyId"]
      title = params["title"]
      first_name = params["first_name"]
      last_name = params["last_name"]
      email = params["email"]
      id_type = params["id_type"]
      id_no = params["id_no"]
      address = params["address"]
      sex = params["sex"]
      user_role = params["user_role"]
      age = params["age"]
      userStatus = "ACTIVE"
      roleType = "COMPANY ADMIN"
      clientId = get_session(conn, :client_id)
      age = Date.from_iso8601!(age)

      user = %Savings.Accounts.User{
        username: mobileNumber,
        clientId: conn.assigns.user.clientId,
        createdByUserId: current_user,
        status: userStatus
      }

      case Repo.insert(user) do
        {:ok, user} ->
          user_bio_data = %Savings.Client.UserBioData{
            firstName: first_name,
            lastName: last_name,
            userId: user.id,
            otherName: nil,
            dateOfBirth: age,
            meansOfIdentificationType: id_type,
            meansOfIdentificationNumber: id_no,
            title: title,
            gender: sex,
            mobileNumber: mobileNumber,
            emailAddress: email,
            clientId: conn.assigns.user.clientId
          }

          case Repo.insert(user_bio_data) do
            {:ok, user_bio_data} ->
              otp = Enum.random(1_000..9_999)
              otp = Integer.to_string(otp)

              appUserRole = %Savings.Accounts.UserRole{
                clientId: clientId,
                roleType: roleType,
                status: "ACTIVE",
                userId: user.id,
                companyId: company.id,
                otp: otp
              }

              case Repo.insert(appUserRole) do
                {:ok, appUserRole} ->
                  conn
                  |> put_flash(:info, "Company Administrator role has been created for the user")
                  |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")

                {:error, changeset} ->
                  conn
                  |> put_flash(
                    :info,
                    "Company Administrator role could not be be created for the user"
                  )
                  |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")
              end

            {:error, changeset} ->
              conn
              |> put_flash(
                :info,
                "Company Administrator profile could not be be created for the user"
              )
              |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")
          end

        {:error, changeset} ->
          conn
          |> put_flash(
            :info,
            "Company Administrator profile could not be be created for the user"
          )
          |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")
      end
    else
      us = Enum.at(users, 0)

      query = from cl in Savings.Companies.Company, where: cl.id == ^companyId, select: cl

      companies = Repo.all(query)
      company = Enum.at(companies, 0)
      registrationNumber = company.registrationNumber

      conn
      |> put_flash(:error, "Use the option to add a role to this user instead")
      |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")
    end
  end

  def add_employer_admin_role(conn, params) do
    mobileNumber = params["mobileNumber"]
    companyId = params["companyId"]
    userStatus = "ACTIVE"
    roleType = "COMPANY ADMIN"
    clientId = get_session(conn, :client_id)

    query =
      from cl in Savings.Accounts.User,
        where: cl.username == ^mobileNumber and cl.status == ^userStatus,
        select: cl

    users = Repo.all(query)

    if(Enum.count(users) == 0) do
      response = %{
        status: 0
      }

      SavingsWeb.ProductController.send_response(conn, response)
    else
      user = Enum.at(users, 0)

      query = from cl in Savings.Companies.Company, where: cl.id == ^companyId, select: cl

      companies = Repo.all(query)
      company = Enum.at(companies, 0)
      registrationNumber = company.registrationNumber

      query =
        from cl in Savings.Accounts.UserRole,
          where:
            cl.userId == ^user.id and cl.roleType == ^roleType and
              cl.companyId == ^companyId and cl.status == ^userStatus,
          select: cl

      userRoles = Repo.all(query)

      if(Enum.count(userRoles) == 0) do
        otp = Enum.random(1_000..9_999)
        otp = Integer.to_string(otp)

        appUserRole = %Savings.Accounts.UserRole{
          clientId: clientId,
          roleType: roleType,
          status: "ACTIVE",
          userId: user.id,
          companyId: company.id,
          otp: otp
        }

        case Repo.insert(appUserRole) do
          {:ok, appUserRole} ->
            conn
            |> put_flash(:info, "Company Administrative role has been added to the users profile")
            |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")

          {:error, changeset} ->
            conn
            |> put_flash(
              :info,
              "Company Administrative role could not be been added to the users profile"
            )
            |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")
        end
      else
        response = %{
          status: -1,
          message:
            "A company administrator of the same company having the same number already exists"
        }

        SavingsWeb.ProductController.send_response(conn, response)
      end
    end
  end

  def add_employer_employee_role(conn, params) do
    mobileNumber = params["mobileNumber"]
    companyId = params["companyId"]
    netPay = params["netPay"]
    userStatus = "ACTIVE"
    roleType = "EMPLOYEE"
    clientId = get_session(conn, :client_id)
    netPay = elem(Float.parse(netPay), 0)

    query =
      from cl in Savings.Accounts.User,
        where: cl.username == ^mobileNumber and cl.status == ^userStatus,
        select: cl

    users = Repo.all(query)

    if(Enum.count(users) == 0) do
      response = %{
        status: 0
      }

      SavingsWeb.ProductController.send_response(conn, response)
    else
      user = Enum.at(users, 0)

      query = from cl in Savings.Companies.Company, where: cl.id == ^companyId, select: cl

      companies = Repo.all(query)
      company = Enum.at(companies, 0)
      registrationNumber = company.registrationNumber

      query =
        from cl in Savings.Accounts.UserRole,
          where:
            cl.userId == ^user.id and cl.roleType == ^roleType and
              cl.companyId == ^companyId and cl.status == ^userStatus,
          select: cl

      userRoles = Repo.all(query)

      if(Enum.count(userRoles) == 0) do
        otp = Enum.random(1_000..9_999)
        otp = Integer.to_string(otp)

        appUserRole = %Savings.Accounts.UserRole{
          clientId: clientId,
          roleType: roleType,
          status: "ACTIVE",
          userId: user.id,
          companyId: company.id,
          otp: otp,
          netPay: netPay
        }

        case Repo.insert(appUserRole) do
          {:ok, appUserRole} ->
            conn
            |> put_flash(:info, "Company Employee role has been added to the users profile")
            |> redirect(to: "/Add/Employer/Staff?company_id=#{companyId}")

          {:error, changeset} ->
            conn
            |> put_flash(
              :info,
              "Company Employee role could not be been added to the users profile"
            )
            |> redirect(to: "/Add/Employer/Staff?company_id=#{companyId}")
        end
      else
        response = %{
          status: -1,
          message: "A company employee of the same company having the same number already exists"
        }

        SavingsWeb.ProductController.send_response(conn, response)
      end
    end
  end

  def getUserBioDataById(conn, params) do
    bioDataId = params["bioDataId"]

    query = from cl in Savings.Client.UserBioData, where: cl.id == ^bioDataId, select: cl

    userBioData = Repo.all(query)
    userBioData = Enum.at(userBioData, 0)

    uB = %{
      "First Name" => userBioData.firstName,
      "Last Name" => userBioData.lastName,
      "Date Of Birth" => userBioData.dateOfBirth,
      "Means Of Identification Type" => userBioData.meansOfIdentificationType,
      "Means Of Identification Number" => userBioData.meansOfIdentificationNumber,
      "Mobile Number" => userBioData.mobileNumber,
      "Email Address" => userBioData.emailAddress
    }

    response = %{
      bioData: uB,
      status: 1
    }

    SavingsWeb.ProductController.send_response(conn, response)
  end

  def getUserAddressesById(conn, params) do
    userId = params["userId"]

    query =
      from cl in Savings.Client.Address,
        where: cl.userId == ^userId,
        order_by: [desc: cl.isCurrent],
        select: cl

    addresses = Repo.all(query)

    response = %{
      addresses: addresses,
      status: 1
    }

    SavingsWeb.ProductController.send_response(conn, response)
  end

  def getNextOfKinByUserId(conn, params) do
    userId = params["userId"]

    query =
      from cl in Savings.Client.NextOfKin,
        where: cl.userId == ^userId,
        order_by: [desc: cl.inserted_at],
        select: cl

    nextOfKins = Repo.all(query)

    response = %{
      nextOfKins: nextOfKins,
      status: 1
    }

    SavingsWeb.ProductController.send_response(conn, response)
  end

  def getEmployerUserByMobileNumberAndRoleType(conn, params) do
    mobileNumber = params["mobileNumber"]
    roleType = params["roleType"]
    companyId = params["companyId"]
    userStatus = "ACTIVE"

    query =
      from cl in Savings.Accounts.User,
        where: cl.username == ^mobileNumber and cl.status == ^userStatus,
        select: cl

    users = Repo.all(query)

    if(Enum.count(users) == 0) do
      response = %{
        status: 0
      }

      SavingsWeb.ProductController.send_response(conn, response)
    else
      user = Enum.at(users, 0)

      query =
        from cl in Savings.Accounts.UserRole,
          where:
            cl.userId == ^user.id and cl.roleType == ^roleType and
              cl.companyId == ^companyId and cl.status == ^userStatus,
          select: cl

      userRoles = Repo.all(query)

      if(Enum.count(userRoles) == 0) do
        query =
          from cl in Savings.Client.UserBioData,
            where: cl.userId == ^user.id,
            select: cl

        userBioDatas = Repo.all(query)
        userBioData = Enum.at(userBioDatas, 0)

        query =
          from cl in Savings.Accounts.UserRole,
            where:
              cl.userId == ^user.id and
                cl.companyId == ^companyId and cl.status == ^userStatus,
            select: cl.roleType

        userRoles = Repo.all(query)

        response = %{
          status: 1,
          userBioData: userBioData,
          userRoles: Enum.join(userRoles, ", ")
        }

        SavingsWeb.ProductController.send_response(conn, response)
      else
        response = %{
          status: -1,
          message:
            "A company administrator of the same company having the same number already exists"
        }

        SavingsWeb.ProductController.send_response(conn, response)
      end
    end
  end

  def new_password(conn, _params) do
    page = %{first: "Settings", last: "Change password"}
    render(conn, "change_password.html", page: page)
  end

  def admin_edit_user(conn, params) do
    user = Savings.Accounts.get_user!(params["id"])
    get_user_bio_id = Savings.Client.get_my_user_bio_id(params["id"])
    user_bio_data = Savings.Client.get_user_bio_data!(get_user_bio_id.id)
    get_user_role = Savings.Accounts.get_my_user_role!(params["id"])
    user_role = Savings.Accounts.get_user_role!(get_user_role.id)
    roleType_length = String.length(params["roleType"])
    IO.inspect(roleType_length, label: "check roleType_length ")
    gender_length = String.length(params["gender"])

    my_user_role = params["roleType"]
    myroleType = String.split(my_user_role, "|||")
    role_id = Enum.at(myroleType, 0)
    role_type = Enum.at(myroleType, 1)

    case roleType_length do
      0 ->
        IO.inspect(params["roleType"], label: "Check Chech role_type ++++++++++++++++++++++++++++")

        IO.inspect(user_role, label: "role_type role_type %%%%%%%%%%%%\n")

        IO.inspect(user_bio_data, label: "user_bio_data user_bio_data %%%%%%%%%%%%\n")

        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :update_user,
          User.changeset(user, %{
            username: params["mobileNumber"]
          })
        )
        |> Ecto.Multi.run(:update_user_bio_data, fn _repo, %{update_user: _update_user} ->
          case gender_length do
            0 ->
              UserBioData.changeset(user_bio_data, %{
                dateOfBirth: params["dateOfBirth"],
                emailAddress: params["emailAddress"],
                firstName: params["firstName"],
                lastName: params["lastName"],
                meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
                meansOfIdentificationType: params["meansOfIdentificationType"],
                mobileNumber: params["mobileNumber"],
                otherName: params["otherName"],
                title: params["title"]
              })
              |> Repo.update()

            _ ->
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
          end
        end)
        |> Ecto.Multi.run(:user_logs, fn _repo,
                                         %{
                                           update_user: update_user,
                                           update_user_bio_data: _update_user_bio_data
                                         } ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Updated User Successfully with ID \"#{update_user.id}\"",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{update_user: update_user}} ->
            conn
            |> put_flash(
              :info,
              "You have Successfully Updated the User \"#{update_user.username}\""
            )
            |> redirect(to: Routes.user_path(conn, :user_mgt))

          {:error, _failed_operations, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors)

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.user_path(conn, :user_mgt))
        end

      _ ->
        IO.inspect(params["roleType"],
          label: "Check Chech role_type with greater tha 0 ++++++++++++++++++++++++++++"
        )

        IO.inspect(user_role, label: "role_type role_type with greater tha 0")

        IO.inspect(user_bio_data, label: "user_bio_data user_bio_data %%%%%%%%%%%%\n")

        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :update_user,
          User.changeset(user, %{
            username: params["mobileNumber"],
            role_id: role_id
          })
        )
        |> Ecto.Multi.run(:update_user_bio_data, fn _repo, %{update_user: _update_user} ->
          case gender_length do
            0 ->
              UserBioData.changeset(user_bio_data, %{
                dateOfBirth: params["dateOfBirth"],
                emailAddress: params["emailAddress"],
                firstName: params["firstName"],
                lastName: params["lastName"],
                meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
                meansOfIdentificationType: params["meansOfIdentificationType"],
                mobileNumber: params["mobileNumber"],
                otherName: params["otherName"],
                title: params["title"]
              })
              |> Repo.update()

            _ ->
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
          end
        end)
        |> Ecto.Multi.run(:update_user_role, fn _repo, %{update_user: _update_user} ->
          UserRole.changeset(user_role, %{
            roleId: role_id,
            roleType: role_type
          })
          |> Repo.update()
        end)
        |> Ecto.Multi.run(:user_logs, fn _repo,
                                         %{
                                           update_user: update_user,
                                           update_user_bio_data: _update_user_bio_data,
                                           update_user_role: _update_user_role
                                         } ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Updated User Successfully with ID \"#{update_user.id}\"",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{update_user: update_user, update_user_role: _update_user_role}} ->
            conn
            |> put_flash(
              :info,
              "You have Successfully Updated the User \"#{update_user.username}\""
            )
            |> redirect(to: Routes.user_path(conn, :user_mgt))

          {:error, _failed_operations, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors)

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.user_path(conn, :user_mgt))
        end
    end
  end

  def change_password(conn, %{"user" => user_params}) do
    case confirm_old_password(conn, user_params) do
      false ->
        conn
        |> put_flash(:error, "some fields were submitted empty!")
        |> redirect(to: Routes.user_path(conn, :new_password))

      result ->
        with {:error, reason} <- result do
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.user_path(conn, :new_password))
        else
          {:ok, _} ->
            conn.assigns.user
            |> change_pwd(user_params)
            |> Repo.transaction()
            |> case do
              {:ok, %{update: _update, insert: _insert}} ->
                conn
                |> put_flash(:info, "Password changed successful")
                |> redirect(to: Routes.user_path(conn, :savings_dashboard))

              {:error, _failed_operation, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors) |> List.first()

                conn
                |> put_flash(:error, reason)
                |> redirect(to: Routes.user_path(conn, :new_password))
            end
        end
    end

    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "Password changed with errors")
    #     |> redirect(to: Routes.user_path(conn, :new_password))
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

  defp confirm_old_password(
         conn,
         %{"old_password" => pwd, "new_password" => new_pwd}
       ) do
    # IO.inspect("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    # IO.inspect conn

    with true <- String.trim(pwd) != "",
         true <- String.trim(new_pwd) != "" do
      Auth.confirm_password(
        conn.assigns.user,
        String.trim(pwd)
      )
    else
      false -> false
    end
  end

  def password_render() do
    random_string()
  end

  def number do
    spec = Enum.to_list(?2..?9)
    length = 2
    Enum.take_random(spec, length)
  end

  def number2 do
    spec = Enum.to_list(?1..?9)
    length = 1
    Enum.take_random(spec, length)
  end

  def caplock do
    spec = Enum.to_list(?A..?N)
    length = 1
    Enum.take_random(spec, length)
  end

  def small_latter do
    spec = Enum.to_list(?a..?n)
    length = 1
    Enum.take_random(spec, length)
  end

  def small_latter2 do
    spec = Enum.to_list(?p..?z)
    length = 2
    Enum.take_random(spec, length)
  end

  def special do
    spec = Enum.to_list(?#..?*)
    length = 1

    Enum.take_random(spec, length)
    |> to_string()
    |> String.replace("'", "^")
    |> String.replace("(", "!")
    |> String.replace(")", "@")
  end

  def random_string do
    smll = to_string(small_latter())
    smll2 = to_string(small_latter2())
    nmb = to_string(number())
    nmb2 = to_string(number2())
    spc = to_string(special())
    cpl = to_string(caplock())
    smll <> "" <> nmb <> "" <> spc <> "" <> cpl <> "" <> nmb2 <> "" <> smll2
  end

  def generate_random_password(conn, _param) do
    account = random_string()
    json(conn, %{"account" => account})
  end

  def user_logs(conn, _params) do
    user_activity = Logs.list_tbl_user_activity_logs()
    render(conn, "user_logs.html", user_activity: user_activity)
  end

  def ussd_logs(conn, _params) do
    query =
      from au in Savings.UssdLogs.UssdLog,
        join: userBioData in UserBioData,
        on: au.userId == userBioData.userId,
        select: %{au: au, userBioData: userBioData}

    ussdLogs = Repo.all(query)
    render(conn, "ussd_logs.html", ussdLogs: ussdLogs)
  end

  ################################ Create Roles #####################################
  alias Savings.Accounts.Role

  def create_user_role(conn, %{"user_role" => params, "role_str" => role_str}) do
    IO.inspect(role_str, label: "Am here ba TEDDY\n\n\n\n\n\n\n\n\n\n")
    params = Map.put(params, "role_str", role_str)

    conn.assigns.user
    |> handle_create(params)
    |> Repo.transaction()
    |> case do
      {:ok, %{user_role: user_role, user_log: _user_log}} ->
        json(conn, %{info: "#{user_role.role_desc} role creation successful"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  defp handle_create(user, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :user_role,
      Role.changeset(%Role{status: "D"}, params)
    )
    |> Ecto.Multi.run(:user_log, fn repo, %{user_role: user_role} ->
      activity = "Created new user role with user role desc: \"#{user_role.role_desc}\""

      user_log = %{
        user_id: user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> repo.insert()
    end)
  end

  def update(conn, %{"user_role" => params, "role_str" => role_str, "id" => id}) do
    IO.inspect(params["id"], label: "check user_role updates here $$$$$$$$$$ \n\n\n\n\n\n\n\n")
    IO.inspect(id, label: "check user_role updates here $$$$$$$$$$ \n\n\n\n\n\n\n\n")

    user_role = Accounts.get_role!(id)
    params = Map.put(params, "role_str", role_str)

    conn.assigns.user
    |> handle_update(user_role, params)
    |> Repo.transaction()
    |> case do
      {:ok, %{update: _update, insert: _insert}} ->
        json(conn, %{info: "Changes applied successfully!"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def change_status(conn, %{"id" => id} = params) do
    user_role = Accounts.get_role!(id)
    user = conn.assigns.user

    handle_update(user, user_role, Map.put(params, "checker_id", user.id))
    |> Repo.transaction()
    |> case do
      {:ok, %{update: _update, insert: _insert}} ->
        json(conn, %{"info" => "Changes applied successfully!"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{"error" => reason})
    end
  end

  defp handle_update(user, user_role, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update, Role.changeset(user_role, params))
    |> Ecto.Multi.run(:insert, fn repo, %{update: _update} ->
      activity = "Modified user role with user role ID #{user_role.id}"

      user_log = %{
        user_id: user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> repo.insert()
    end)
  end

  ################################ Create Roles #####################################

  # def authorize(conn) do
  #   case Phoenix.Controller.action_name(conn) do
  #     act when act in ~w(user_mgt)a ->
  #       {:system_users, :user_mgt}

  #     # act when act in ~w(savings_dashboard)a -> {:savings_dashboard, :savings_dashboard}
  #     # act when act in ~w(update edit)a -> {:user_role, :edit}
  #     # act when act in ~w(change_status)a -> {:user_role, :change_status}
  #     # act when act in ~w(delete)a -> {:user_role, :delete}
  #     _ ->
  #       {:system_users, :unknown}
  #   end
  # end

  def authorize(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(savings_dashboard user_mgt client edit_user_roles)a ->
        {:index, :savings_dashboard}

      act when act in ~w(edit_user_roles update)a ->
        {:user_role, :edit}

      # act when act in ~w(index show)a -> {:user, :index}
      _ ->
        {:index, :unknown}
    end
  end

  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(savings_dashboard edit_user_roles)a ->
        {:role_maintenance, :savings_dashboard}

      act when act in ~w(edit_user_roles)a ->
        {:role_maintenance, :edit_user_roles}

      act when act in ~w(new edit_user_roles)a ->
        {:role_maintenance, :view}

      act when act in ~w(update edit_user_roles edit)a ->
        {:role_maintenance, :edit}

      act when act in ~w(change_user_status)a ->
        {:role_maintenance, :change_status}

      # act when act in ~w(index show)a -> {:user, :index}
      _ ->
        {:role_maintenance, :unknown}
    end
  end

  def authorize_user_logs(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(user_logs)a ->
        {:user_logs, :view}

      act when act in ~w(change_user_status user_logs)a ->
        {:user_logs, :change_status}

      # act when act in ~w(index show)a -> {:user, :index}
      _ ->
        {:user_logs, :unknown}
    end
  end

  # def authorize(conn) do
  #   case Phoenix.Controller.action_name(conn) do
  #     act when act in ~w(new new2)a -> {:user, :index}
  #     act when act in ~w(index show)a -> {:user, :index}
  #     act when act in ~w(update edit)a -> {:user, :edit}
  #     act when act in ~w(change_user_status)a -> {:user, :update_status}
  #     act when act in ~w(delete)a -> {:user, :delete}
  #     _ -> {:user, :unknown}
  #   end
  # end

  # SavingsWeb.UserController.date
  def date do

    specific_month = ~D[2023-11-01]  # Replace with your specific month

    one_day_before = Timex.shift(specific_month, days: -10)

    query =
      from t in Savings.FixedDeposit.FixedDeposits,
      where: t.inserted_at >= fragment("DATE_TRUNC('MONTH', ?::date)", ^one_day_before),
      where: t.inserted_at < fragment("DATE_TRUNC('MONTH', ?::date + INTERVAL '1 month')", ^one_day_before),
      where: t.fixedDepositStatus == "ACTIVE",
      select: %{sum_principal_amount: sum(t.principalAmount)}

    result = Savings.Repo.one(query)
    IO.inspect(result)
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end
end
