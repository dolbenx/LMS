defmodule LoanmanagementsystemWeb.UserController do
  use LoanmanagementsystemWeb, :controller
  use Ecto.Schema
  alias Loanmanagementsystem.Repo
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Emails.Email
  alias Loanmanagementsystem.Auth
  # alias Loanmanagementsystem.Loan.Customer_Balance
  alias Loanmanagementsystem.Notifications.Sms
  alias Loanmanagementsystem.Emails.Email
  # alias Loanmanagementsystem.Transactions  git
  alias Loanmanagementsystem.Loan.Loan_funder
  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Loan.Customer_Balance
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Accounts.Nextofkin
  alias Loanmanagementsystem.Companies.Client_company_details
  alias Loanmanagementsystem.Companies.Employee
  alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Employment.Personal_Bank_Details
  alias Loanmanagementsystem.Loan.Loan_market_info
  alias Loanmanagementsystem.Employment.Income_Details
  require Logger



  plug(
    LoanmanagementsystemWeb.Plugs.RequireAuth
    when action in [
           :user_creation,
           :student_dashboard,

         ]
  )

  plug(
    LoanmanagementsystemWeb.Plugs.EnforcePasswordPolicy
    when action not in [
           :new_password,
           :change_password,
           :user_creation,
           :student_dashboard,
           :post_change_password
         ]
  )


  plug LoanmanagementsystemWeb.Plugs.Authenticate,
        [module_callback: &LoanmanagementsystemWeb.UserController.authorize_role/1]
        when action not in [
          :activate_admin,
          :admin_activate_user,
          :admin_create_adiministartive_user,
          :admin_create_user,
          :admin_dashboard,
          :admin_deactivate_user,
          :admin_deactivate_user_individual,
          :admin_individual_activate_user,
          :admin_update_user,
          :admin_update_user_classification,
          :administartion_user_mgt,
          :alphabetic_and_special_characters_password,
          :alphabetic_numeric_password,
          :alphabetic_password,
          :alphanumeric_and_special_characters_password,
          :calculate_page_num,
          :calculate_page_size,
          :caplock,
          :change_password,
          :change_pwd,
          :create_new_user_role_for_existing_user,
          :customer_self_registration,
          :dashboard,
          :deactivate_admin,
          :delete_admin,
          :employee_dashboard,
          :employer_dashboard,
          :entries,
          :generate_otp,
          :generate_random_password,
          :get_user_by_email,
          :get_user_by_user_role,
          :individual_dashboard,
          :lowercase_password,
          :me,
          :month,
          :my_profile,
          :new_password,
          :number,
          :number2,
          :numbers_and_special_characters_password,
          :numeric_password,
          :password_render,
          :random_password_string,
          :random_string,
          :search_options,
          :self_create_user,
          :small_latter,
          :small_latter2,
          :sme_dashboard,
          :special,
          :status_value,
          :testththff,
          :total_entries,
          :traverse_errors,
          :uppercase_password,
          :user_creation,
          :user_logs,
          :user_mgt,
          :user_roles,
          :post_change_password,
          :funder_mgt,
          :create_funder,
          :admin_fund_funder,
          :offtaker_dashboard,
          :create_funder_as_company,
          :admin_update_funders_funds,
          :create_individual_user
       ]

use PipeTo.Override

  def user_creation(conn, _params) do
    users = Loanmanagementsystem.Accounts.get_system_admin()
    render(conn, "user_mgt.html", users: users)
  end

  def generate_otp do
    random_int = to_string(Enum.random(1111..9999))
    random_int
  end

  def get_user_by_email(username) do
    case Repo.get_by(Loanmanagementsystem.Accounts.User, username: username) do
      nil -> {:error, "invalid User Name address"}
      user -> {:ok, user}
    end
  end

  def get_user_by_user_role(userId) do
    case Loanmanagementsystem.Accounts.get_users!(userId) do
      nil ->
        {:error, "invalid User Name address"}

      user ->
        user
    end
  end

  def month(m) do
    year = Date.utc_today().year |> to_string()
    {:ok, result} = Timex.parse(year <> "-" <> m <> "-01", "{YYYY}-{0M}-{D}")
    DateTime.from_naive!(result, "Etc/UTC")
  end

  def me(m) do
    year = Date.utc_today().year |> to_string()
    {:ok, result} = Timex.parse(year <> "-" <> m <> "-01", "{YYYY}-{0M}-{D}")
    DateTime.from_naive!(result, "Etc/UTC")
  end

  def admin_dashboard(conn, _params) do
    IO.inspect(conn, label: "\n\n\nn\n\\n\n\n\n\n\n\n\n\n\n\n\Masumbi")
    users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    user_count = Loanmanagementsystem.Accounts.count_users()
    # disbursed_loans = Loanmanagementsystem.Loan.count_disbursed_loans()
    # pending_loans = Loanmanagementsystem.Loan.count_pending_loans()

    render(conn, "dashboard.html", users: users, get_bio_datas: get_bio_datas, user_count: user_count)
  end


  def employer_dashboard(conn, _params) do
    users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()

    render(conn, "employer_dashboard.html", users: users, get_bio_datas: get_bio_datas)
  end



  def offtaker_dashboard(conn, _params) do
    render(conn, "offtaker_dashboard.html")
  end

  def individual_dashboard(conn, _params) do
    users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()

    render(conn, "individual_dashboard.html", users: users, get_bio_datas: get_bio_datas)
  end

  def employee_dashboard(conn, _params) do
    IO.inspect(conn, label: "\n\n\nn\n\\n\n\n\n\n\n\n\n\n\n\n\Masumbi")

    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")

    get_my_current_user =
      Loanmanagementsystem.Accounts.get_my_current_user(currentUserRole.userId)

    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()

    render(conn, "employee_dashboard.html",
      users: users,
      get_bio_datas: get_bio_datas,
      get_my_current_user: get_my_current_user,
      banks: banks
    )
  end

  def sme_dashboard(conn, _params) do
    users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()

    render(conn, "sme_dashboard.html", users: users, get_bio_datas: get_bio_datas)
  end

  def user_mgt(conn, _params) do
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_admin_user_details()
    user_roles = Loanmanagementsystem.Accounts.list_tbl_roles()

    render(conn, "user_mgt.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      user_roles: user_roles
    )
  end

  def administartion_user_mgt(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")
    # current_user_details = Accounts.get_details(currentUserRole.userId)
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_all_administartion_users()
    users = Loanmanagementsystem.Accounts.get_system_admin()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    classifications = Loanmanagementsystem.Maintenance.list_tbl_classification()
    # roles = Accounts.list_tbl_user_role()
    render(conn, "admin_user_mgt.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users,
      banks: banks,
      classifications: classifications,
      branches: branches
    )
  end

  def my_profile(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect(currentUserRole, label: "Am here man!")
    current_user_details = Accounts.get_details(currentUserRole.userId)
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details()
    users = Loanmanagementsystem.Accounts.get_system_admin()
    # roles = Accounts.list_tbl_user_role()
    render(conn, "my_profile.html",
      system_users: system_users,
      get_bio_datas: get_bio_datas,
      users: users,
      current_user_details: current_user_details
    )
  end

  # def user_lookup(conn, params) do
  #   {draw, start, length, search_params} = search_options(params)
  #   results = Account.user_logs(search_params, start, length)
  #   total_entries = total_entries(results)
  #   entries = entries(results)

  #   results = %{
  #     draw: draw,
  #     recordsTotal: total_entries,
  #     recordsFiltered: total_entries,
  #     data: entries
  #   }
  #   json(conn, results)
  # end

  # def student_lookup(conn, %{"id" => id}) do
  #   results = Loanmanagementsystem.User.view_person(id)
  #   json(conn, results)
  # end

  def total_entries(%{total_entries: total_entries}), do: total_entries
  def total_entries(_), do: 0

  def entries(%{entries: entries}), do: entries
  def entries(_), do: []

  def search_options(params) do
    length = calculate_page_size(params["length"])
    page = calculate_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def calculate_page_num(nil, _), do: 1

  def calculate_page_num(start, length) do
    start = String.to_integer(start)
    round(start / length + 1)
  end

  def calculate_page_size(nil), do: 10
  def calculate_page_size(length), do: String.to_integer(length)

  def user_roles(conn, _params) do
    bank_roles = Accounts.list_tbl_user_roles()
    render(conn, "user_roles.html", bank_roles: bank_roles)
  end

  def activate_admin(conn, params) do
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
        conn |> json(%{message: "Savings Product approved successfully", status: 0})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
    end
  end

  def deactivate_admin(conn, params) do
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

  def new_password(conn, _params) do
    page = %{first: "Settings", last: "Change password"}
    render(conn, "change_password.html", page: page)
  end

  def change_password(conn, %{"user" => user_params}) do
    case confirm_old_password(conn, user_params) do
      false ->
        conn
        |> put_flash(:error, "Some field(s) were submitted empty!")
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
                |> put_flash(:info, "You have succefully changed your account password")
                |> redirect(to: Routes.user_path(conn, :admin_dashboard))

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
        %{user_id: user.id, activity: "Changed account password"}
      )
    )
  end

  defp confirm_old_password(conn, %{"old_password" => pwd, "new_password" => new_pwd}) do
    # IO.inspect("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    # IO.inspect conn

    with true <- String.trim(pwd) != "",
         true <- String.trim(new_pwd) != "" do
      Auth.confirm_password(conn.private.plug_session["current_user"], String.trim(pwd))
    else
      false -> false
    end
  end

  def create_new_user_role_for_existing_user(conn, params, userId) do
    generate_otp = to_string(Enum.random(1111..9999))
    # Push Data To User Roles
    user_role = %{
      userId: userId,
      roleType: params["roleType"],
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
      emailAddress: params["emailAddress"]
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
    # spc = to_string(special())
    cpl = to_string(caplock())
    smll <> "" <> nmb <> "" <> cpl <> "" <> nmb2 <> "" <> smll2
  end

  # LoanmanagementsystemWeb.UserController.random_string
  def generate_random_password(conn, _unused_params) do
    account = random_string()
    json(conn, %{"account" => account})
  end

  # ---------------------------------- Password Mgt  Config  -------------------
  def random_password_string do
    data = Loanmanagementsystem.Maintenance.Password_maintenance.all() |> Enum.at(0)
    password = data.password_format

    password
    |> case do
      nil ->
        alphabetic_numeric_password()

      "[0-9]" ->
        numeric_password()

      "[a-z]" ->
        lowercase_password()

      "[A-Z]" ->
        uppercase_password()

      "[0-9][a-z][A-Z]" ->
        alphabetic_numeric_password()

      "[a-z][A-Z]" ->
        alphabetic_password()

      "[0-9][@!%&*^$#]" ->
        numbers_and_special_characters_password()

      "[a-z][A-Z][@!%&*^$#]" ->
        alphabetic_and_special_characters_password()

      "[0-9][a-z][A-Z][@!%&*^$#]" ->
        alphanumeric_and_special_characters_password()
    end
  end

  # --------------Numbers Only Passowrd Configuration
  def numeric_password do
    spec = Enum.to_list(?0..?9)
    length = 8
    to_string(Enum.take_random(spec, length))
  end

  # ----------------------Lowercase Characters
  def lowercase_password do
    small = Enum.to_list(?a..?n)
    length_small = 8
    small_letters = to_string(Enum.take_random(small, length_small))
    small_letters
  end

  # ----------------------Uppercase Characters
  def uppercase_password do
    small = Enum.to_list(?A..?N)
    length_caps = 8
    capital_letters = to_string(Enum.take_random(small, length_caps))
    capital_letters
  end

  # ----------------------Alphabetic Characters
  def alphabetic_password do
    caps = Enum.to_list(?A..?N)
    small = Enum.to_list(?a..?n)
    length_caps = 4
    length_small = 4
    capital_letters = to_string(Enum.take_random(caps, length_caps))
    small_letters = to_string(Enum.take_random(small, length_small))
    capital_letters <> "" <> small_letters
  end

  # --------------------Alphanumeric Characters
  def alphabetic_numeric_password do
    caps = Enum.to_list(?A..?N)
    small = Enum.to_list(?a..?n)
    numbers = Enum.to_list(?0..?9)
    length_caps = 2
    length_small = 3
    length_number = 3
    capital_letters = to_string(Enum.take_random(caps, length_caps))
    small_letters = to_string(Enum.take_random(small, length_small))
    numbers = to_string(Enum.take_random(numbers, length_number))
    capital_letters <> "" <> small_letters <> "" <> numbers
  end

  # -----------------Numbers And Special Characters
  def numbers_and_special_characters_password do
    numbers_one = Enum.to_list(?0..?9)
    numbers_two = Enum.to_list(?0..?9)

    length_number_one = 4
    length_number_two = 3

    first_combination = to_string(Enum.take_random(numbers_one, length_number_one))
    second_combination = to_string(Enum.take_random(numbers_two, length_number_two))

    first_combination <> "" <> "@" <> second_combination
  end

  # ----------Alphabet And Special Characters
  def alphabetic_and_special_characters_password do
    caps = Enum.to_list(?A..?N)
    small = Enum.to_list(?a..?n)

    length_caps = 4
    length_small = 3
    capital_letters = to_string(Enum.take_random(caps, length_caps))
    small_letters = to_string(Enum.take_random(small, length_small))

    capital_letters <> "" <> "" <> "@" <> "" <> small_letters
  end

  # ----------Alphabet And Special Characters
  def alphabetic_and_special_characters_password do
    caps = Enum.to_list(?A..?N)
    small = Enum.to_list(?a..?n)

    length_caps = 4
    length_small = 3
    capital_letters = to_string(Enum.take_random(caps, length_caps))
    small_letters = to_string(Enum.take_random(small, length_small))

    capital_letters <> "" <> "" <> "@" <> "" <> small_letters
  end

  # ----------Alphanumeric And Special Characters
  def alphanumeric_and_special_characters_password do
    caps = Enum.to_list(?A..?N)
    small = Enum.to_list(?a..?n)
    numbers_one = Enum.to_list(?0..?9)

    length_caps = 3
    length_small = 2
    length_numbers = 3

    capital_letters = to_string(Enum.take_random(caps, length_caps))
    small_letters = to_string(Enum.take_random(small, length_small))
    numbers = to_string(Enum.take_random(numbers_one, length_numbers))

    capital_letters <> "" <> "" <> small_letters <> "" <> numbers
  end

  def user_logs(conn, _params) do
    user_activity = Loanmanagementsystem.Logs.list_tbl_user_activity_logs()
    render(conn, "user_logs.html", user_activity: user_activity)
  end

  @dashboard_status_params ~w(
    pending
    Failed
    successful
    Donation
    TOTAL
  )

  def dashboard(conn, _params) do
    conn.assigns.user
    # {stats, totals} =
    # Transactions.dashboard_params()
    #   |> prepare_dash_result()
    #   |> prepare_stats_params()
    #   |> (&{&1, calcu_stats_totals(&1)}).()

    # summary = Transactions.dashboard_params() |> prepare_dash_result()

    # keys = Enum.map(summary, &(&1.day)) |> Enum.uniq |> Enum.sort()
    # successful = Enum.sort_by(summary, &(&1.day))  |> Enum.filter(&(&1.status == "successful")) |> Enum.map(&(&1.count))
    # failed = Enum.sort_by(summary, &(&1.day))  |> Enum.filter(&(&1.status == "Failed")) |> Enum.map(&(&1.count))
    # donation = Enum.sort_by(summary, &(&1.day))  |> Enum.filter(&(&1.status == "Donation")) |> Enum.map(&(&1.count))
    # pending = Enum.sort_by(summary, &(&1.day))  |> Enum.filter(&(&1.status == "pending")) |> Enum.map(&(&1.count))
    # total = Enum.sort_by(summary, &(&1.day))  |>  Enum.map(&(&1.count))

    # success_summary = Transactions.dashboard_params() |> prepare_dash_result()
    # successful = Enum.sort_by(success_summary, &(&1.day))  |> Enum.filter(&(&1.status == "successful")) |> Enum.map(&(&1.count))

    # failed_summary = Transactions.dashboard_params() |> prepare_dash_result_failed()
    # failed = Enum.sort_by(failed_summary, &(&1.day))  |> Enum.filter(&(&1.status == "Failed")) |> Enum.map(&(&1.count))

    # donation_summary = Transactions.dashboard_params() |> prepare_dash_result_donation()
    # donation = Enum.sort_by(donation_summary, &(&1.day))  |> Enum.filter(&(&1.status == "Donation")) |> Enum.map(&(&1.count))

    # pending_summary = Transactions.dashboard_params() |> prepare_dash_result_pending()
    # pending = Enum.sort_by(pending_summary, &(&1.day))  |> Enum.filter(&(&1.status == "pending")) |> Enum.map(&(&1.count))

    # total_summary = Transactions.dashboard_params() |> prepare_dash_result_total()
    # total = Enum.sort_by(total_summary, &(&1.day))
    #  |>  Enum.map(&(&1.count))

    #  render(conn, "dashboard.html", donation: donation, successful: successful, pending: pending, failed: failed, keys: keys, total: total, results: stats, summary: totals)
    render(conn, "dashboard.html")
  end

  defp prepare_dash_result(results) do
    Enum.reduce(default_dashboard(), results, fn item, acc ->
      filtered = Enum.filter(acc, &(&1.day == item.day && &1.status == "successful"))
      if item not in acc && Enum.empty?(filtered), do: [item | acc], else: acc
    end)
    |> Enum.sort_by(& &1.day)
  end

  defp prepare_dash_result_donation(results) do
    Enum.reduce(default_dashboard_donation(), results, fn item, acc ->
      filtered = Enum.filter(acc, &(&1.day == item.day && &1.status == "Donation"))
      if item not in acc && Enum.empty?(filtered), do: [item | acc], else: acc
    end)
    |> Enum.sort_by(& &1.day)
  end

  defp prepare_dash_result_failed(results) do
    Enum.reduce(default_dashboard_failed(), results, fn item, acc ->
      filtered = Enum.filter(acc, &(&1.day == item.day && &1.status == "Failed"))
      if item not in acc && Enum.empty?(filtered), do: [item | acc], else: acc
    end)
    |> Enum.sort_by(& &1.day)
  end

  defp prepare_dash_result_pending(results) do
    Enum.reduce(default_dashboard_pending(), results, fn item, acc ->
      filtered = Enum.filter(acc, &(&1.day == item.day && &1.status == "pending"))
      if item not in acc && Enum.empty?(filtered), do: [item | acc], else: acc
    end)
    |> Enum.sort_by(& &1.day)
  end

  defp prepare_dash_result_total(results) do
    Enum.reduce(default_dashboard_total(), results, fn item, acc ->
      if item not in acc, do: [item | acc], else: acc
    end)
    |> Enum.sort_by(& &1.day)
  end

  defp default_dashboard_donation do
    today = Date.utc_today()
    days = Date.days_in_month(today)

    Date.range(%{today | day: 1}, %{today | day: days})
    |> Enum.map(
      &%{
        count: 0,
        day:
          Timex.format!(&1, "%b #{String.pad_leading(to_string(&1.day), 2, "0")}, %Y", :strftime),
        status: "Donation"
      }
    )
  end

  defp default_dashboard_failed do
    today = Date.utc_today()
    days = Date.days_in_month(today)

    Date.range(%{today | day: 1}, %{today | day: days})
    |> Enum.map(
      &%{
        count: 0,
        day:
          Timex.format!(&1, "%b #{String.pad_leading(to_string(&1.day), 2, "0")}, %Y", :strftime),
        status: "Failed"
      }
    )
  end

  defp default_dashboard_pending do
    today = Date.utc_today()
    days = Date.days_in_month(today)

    Date.range(%{today | day: 1}, %{today | day: days})
    |> Enum.map(
      &%{
        count: 0,
        day:
          Timex.format!(&1, "%b #{String.pad_leading(to_string(&1.day), 2, "0")}, %Y", :strftime),
        status: "pending"
      }
    )
  end

  defp default_dashboard_total do
    today = Date.utc_today()
    days = Date.days_in_month(today)

    Date.range(%{today | day: 1}, %{today | day: days})
    |> Enum.map(
      &%{
        count: 0,
        day:
          Timex.format!(&1, "%b #{String.pad_leading(to_string(&1.day), 2, "0")}, %Y", :strftime)
      }
    )
  end

  defp default_dashboard do
    today = Date.utc_today()
    days = Date.days_in_month(today)

    Date.range(%{today | day: 1}, %{today | day: days})
    |> Enum.map(
      &%{
        count: 0,
        day:
          Timex.format!(&1, "%b #{String.pad_leading(to_string(&1.day), 2, "0")}, %Y", :strftime),
        status: "successful"
      }
    )
  end

  defp calcu_stats_totals(results) do
    @dashboard_status_params
    |> Enum.map(fn status ->
      {status,
       Enum.reduce(
         results,
         &Map.merge(&1, %{
           status => (&1[status] || 0) + (&2[status] || 0)
         })
       )[status]}
    end)
    |> Enum.into(%{})
  end

  defp prepare_stats_params(items) do
    items
    |> Enum.map(
      &(Map.merge(Enum.into(Enum.map(@dashboard_status_params, fn key -> {key, 0} end), %{}), %{
          "date" => &1.day,
          &1.status => &1.count
        })
        |> Map.delete(nil))
    )
    |> Enum.group_by(& &1["date"])
    |> Map.values()
    |> Enum.map(fn item ->
      Enum.reduce(
        item,
        &Map.merge(&1, &2, fn k, v1, v2 -> if(k == "date", do: v1, else: v1 + v2) end)
      )
    end)
  end

  def status_value(values, status) do
    result = Enum.filter(values, &(&1.status == status))

    with false <- Enum.empty?(result) do
      Enum.reduce(result, &%{&1 | count: &1.count + &2.count}).count
    else
      _ -> 0
    end
  end

  # LoanmanagementsystemWeb.UserController.testththff
  def testththff do
    # nrc = "121212/10/1"
    # nrc = String.replace(nrc, "/", "")
    # IO.inspect nrc

   pass = Generator.randstring(4)<>"#{Enum.random(1_000_000..9_999_999)}"<>Generator.randstring(2)
 IO.inspect pass
  end


  def admin_create_user(conn, params) do
    username = params["emailAddress"]
    mobile_line = params["mobileNumber"]
    role_Type = String.split(params["roleType"], "|||")
    params = Map.put(params, "status", "ACTIVE")
    params = Map.put(params, "auto_password", "Y")
    get_username = Repo.get_by(User, username: username)
    IO.inspect(role_Type, label: "Check roletype here ")
    IO.inspect(username, label: "Check Email ^^^^^^^^^^^^^\n ")
    generate_otp = to_string(Enum.random(1111..9999))
    get_user_mobile_line = Repo.get_by(UserBioData, mobileNumber: mobile_line)
    user_identification_no = params["meansOfIdentificationNumber"]
    get_user_identification_no = Repo.get_by(UserBioData, meansOfIdentificationNumber: user_identification_no)

    params =
      Map.merge(params, %{
        "roleType" => Enum.at(role_Type, 1),
        "role_id" => Enum.at(role_Type, 0),
        "username" => username
      })

      case is_nil(get_user_identification_no) do
        true ->
          case is_nil(get_user_mobile_line) do
            true ->

            case is_nil(get_username) do
              true ->
                Ecto.Multi.new()
                |> Ecto.Multi.insert(:create_user, User.changeset(%User{}, params))
                |> Ecto.Multi.run(:user_role, fn _, %{create_user: user} ->
                  # Push Data To User Roles
                  user_role = %{
                    userId: user.id,
                    roleId: user.role_id,
                    roleType: params["roleType"],
                    status: user.status,
                    otp: generate_otp
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
                    meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
                    title: params["title"],
                    gender: params["gender"],
                    mobileNumber: params["mobileNumber"],
                    emailAddress: params["emailAddress"]
                  }

                  UserBioData.changeset(%UserBioData{}, user_bio_data)
                  |> Repo.insert()
                end)
                |> Ecto.Multi.run(:user_log, fn _, %{create_user: user} ->
                  activity = "Created an admin user with id \"#{user.id}\" "
                  # Push Data To User Logs
                  user_log = %{
                    user_id: conn.assigns.user.id,
                    activity: activity
                  }

                  UserLogs.changeset(%UserLogs{}, user_log)
                  |> Repo.insert()
                end)
                |> Ecto.Multi.run(:sms, fn _, %{user_bio_data: bio_data, user_role: _user_role} ->
                  sms = %{
                    mobile: bio_data.mobileNumber,
                    msg:
                    "Dear #{params["firstName"]}, Your Login Credentials. username: #{params["emailAddress"]}, password: #{params["password"]}, OTP: #{generate_otp}",
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
                    Email.send_email(params["emailAddress"], params["password"], params["firstName"])
                    Loanmanagementsystem.Workers.Sms.send()

                    conn
                    |> put_flash(:info, "User created Successfully")
                    |> redirect(to: Routes.user_path(conn, :user_mgt))

                  {:error, _failed_operation, failed_value, _changes} ->
                    reason = traverse_errors(failed_value.errors) |> List.first()

                    conn
                    |> put_flash(:error, reason)
                    |> redirect(to: Routes.user_path(conn, :user_mgt))
                end

              _ ->
                conn
                |> put_flash(:error, "User with email address #{username} already exists")
                |> redirect(to: Routes.user_path(conn, :user_mgt))
            end

            _ ->
              conn
              |> put_flash(:error, "User with phone number #{get_user_mobile_line} already exists")
              |> redirect(to: Routes.user_path(conn, :user_mgt))
          end
        _ ->
          conn
          |> put_flash(:error, "User with ID number #{user_identification_no} Already Exists")
          |> redirect(to: Routes.user_path(conn, :user_mgt))
      end

  end

  def admin_create_adiministartive_user(conn, params) do
    otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_user,
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y"
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
        activity: "Added New User Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      # {:ok, _} ->
      {:ok, %{add_user: _add_user}} ->

        conn
        |> put_flash(:info, "You have Successfully Added a New User")
        |> redirect(to: Routes.user_path(conn, :user_mgt))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :user_mgt))
    end
  end

  def self_create_user(conn, params) do
    otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_user,
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y"
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
        activity: "Added New User Successfully",
        # user_id: conn.assigns.user.id
        user_id: 1
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      # {:ok, _} ->
      {:ok, %{add_user: _add_user}} ->
        # Email.send_email(params["emailAddress"], params["password"])

        conn
        |> put_flash(:info, "You have Successfully Added a New User")
        |> redirect(to: Routes.session_path(conn, :username))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.session_path(conn, :username))
    end
  end

  def admin_update_user(conn, params) do
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])
    user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])
    otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_user,
      User.changeset(user, %{
        status: "ACTIVE",
        username: params["emailAddress"],
        auto_password: "N"
      })
    )
    |> Ecto.Multi.run(:update_user_role, fn _repo, %{update_user: _update_user} ->
      UserRole.changeset(user_role, %{
        roleType: params["roleType"],
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
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the User")
        |> redirect(to: Routes.user_path(conn, :user_mgt))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :user_mgt))
    end
  end

  def admin_update_user_classification(conn, params) do
    IO.inspect(params, label: "gvdwjhbsdbsjhjsdbhdbbdjbhsdbsjh")
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])
    user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])
    classification_id = String.to_integer(params["classification_id"])
    otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_user,
      User.changeset(user, %{
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "N",
        classification_id: classification_id
      })
    )
    |> Ecto.Multi.run(:update_user_role, fn _repo, %{update_user: _update_user} ->
      UserRole.changeset(user_role, %{
        roleType: params["roleType"],
        status: "INACTIVE",
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
        activity: "Updated User Classification Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the User Classification")
        |> redirect(to: Routes.user_path(conn, :user_mgt))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :user_mgt))
    end
  end

  def admin_activate_user(conn, params) do
    IO.inspect(params, label: "gyvgbybubbbuubyubhu")
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(
        user,
        Map.merge(params, %{
          "status" => "ACTIVE",
          "classification_id" => params["classification_id"]
        })
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
        activity: "Activated User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Activated the User ")
        |> redirect(to: Routes.user_path(conn, :user_mgt))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :user_mgt))
    end
  end

  def admin_individual_activate_user(conn, params) do
    IO.inspect(params, label: "gyvgbybubbbuubyubhu")
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(
        user,
        Map.merge(params, %{
          "status" => "ACTIVE",
          "classification_id" => params["classification_id"]
        })
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
        activity: "Activated User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Activated the User ")
        |> redirect(to: Routes.customers_path(conn, :individuals))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customers_path(conn, :individuals))
    end
  end

  def admin_deactivate_user(conn, params) do
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(user, Map.merge(params, %{"status" => "INACTIVE"}))
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
        activity: "Deactivated User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "User Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_deactivate_user_individual(conn, params) do
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(user, Map.merge(params, %{"status" => "INACTIVE"}))
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
        activity: "Deactivated User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "User Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
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
            status: "ACTIVE",
            username: params["mobileNumber"],
            auto_password: "N",
            pin: otp
          })
        )
        |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
          UserRole.changeset(%UserRole{}, %{
            roleType: params["roleType"],
            status: "ACTIVE",
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
              "Hello, Thank you for signing up. To validate your mobile number, please provide the OTP - #{my_otp}",
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
                                           add_user: add_user,
                                           add_user_role: _add_user_role,
                                           add_user_bio_data: _add_user_bio_data
                                         } ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Added New User Successfully",
            user_id: add_user.id
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
                Routes.session_path(conn, :otp_validation,
                  mobileNumber: add_user_bio_data.mobileNumber
                )
            )

          {:error, _failed_operations, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors)

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.session_path(conn, :register))
        end

      _ ->
        conn
        |> put_flash(:error, "User Already Exists")
        |> redirect(to: Routes.session_path(conn, :register))
    end
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end


  def post_change_password(conn, params) do
    user = Accounts.get_user!(conn.private.plug_session["current_user"])
    case Auth.confirm_password(user,  String.trim(params["current_password"])) do
     {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid Current Password")
        |> redirect(to: Routes.user_path(conn, :new_password))
     {:ok, _reason} ->
    case Auth.confirm_password(user,  String.trim(params["new_password"])) do
      {:ok, _reason} ->
        conn
        |> put_flash(:error, "Current Password and New Password can't be the same")
        |> redirect(to: Routes.user_path(conn, :new_password))
      {:error, _reason} ->
      param = Map.merge(params, %{
        "password" => params["new_password"], "auto_password" => "N"})
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.changeset(user, param))
    |> Ecto.Multi.run(:user_log, fn (_, %{user:  user}) ->
      activity = "Changed Password successful "
      user_log = %{
          user_id: conn.private.plug_session["current_user"],
          activity: activity
      }
      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user, user_log: user_log}} ->
        conn
        |> put_flash(:info, "Changed Password Successfully")
        |> redirect(to: Routes.session_path(conn, :username))
      {:error, failed_operation, failed_value, changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :new_password))
    end
  end
end
end

########################################################################### FUNDER #############################################################


def funder_mgt(conn, _params) do
    get_bio_datas = Accounts.list_tbl_funder_users()
    user_roles = Loanmanagementsystem.Accounts.list_tbl_roles()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "funder_mgt.html",
      get_bio_datas: get_bio_datas,
      user_roles: user_roles,
      banks: banks
    )
end

def create_funder(conn, params) do
  username = params["emailAddress"]
    # role_Type = String.split(params["roleType"], "|||")
    params = Map.put(params, "status", "ACTIVE")
    params = Map.put(params, "auto_password", "Y")
    get_username = Repo.get_by(User, username: username)
    # IO.inspect(role_Type, label: "Check roletype here ")
    IO.inspect(username, label: "Check Email ^^^^^^^^^^^^^\n ")
    generate_otp = to_string(Enum.random(1111..9999))
    password = LoanmanagementsystemWeb.UserController.random_string()

    params =
      Map.merge(params, %{
        "roleType" => "FUNDER",
        "role_id" => 1,
        "username" => username,
        "password" => password
      })

    case is_nil(get_username) do
      true ->
        Ecto.Multi.new()
        |> Ecto.Multi.insert(:create_user, User.changeset(%User{}, params))
        |> Ecto.Multi.run(:user_role, fn _, %{create_user: user} ->
          # Push Data To User Roles
          user_role = %{
            userId: user.id,
            roleId: user.id,
            roleType: "FUNDER",
            status: user.status,
            otp: generate_otp
          }

          UserRole.changeset(%UserRole{}, user_role)
          |> Repo.insert()
        end)
        |> Ecto.Multi.run(:user_bio_data, fn _, %{create_user: user, push_to_funder: _push_to_funder} ->
          # Push Data To Bio Data
          user_bio_data = %{
            firstName: params["firstName"],
            lastName: params["lastName"],
            userId: user.id,
            otherName: params["otherName"],
            dateOfBirth: params["dateOfBirth"],
            meansOfIdentificationType: params["meansOfIdentificationType"],
            meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
            title: params["title"],
            gender: params["gender"],
            mobileNumber: params["mobileNumber"],
            emailAddress: params["emailAddress"]
          }

          UserBioData.changeset(%UserBioData{}, user_bio_data)
          |> Repo.insert()
        end)
        |> Ecto.Multi.run(:user_log, fn _, %{create_user: user, push_to_funder: _push_to_funder} ->
          activity = "Created an admin user with id \"#{user.id}\" "
          # Push Data To User Logs
          user_log = %{
            user_id: conn.assigns.user.id,
            activity: activity
          }

          UserLogs.changeset(%UserLogs{}, user_log)
          |> Repo.insert()
        end)
        |> Ecto.Multi.run(:sms, fn _, %{user_bio_data: bio_data, user_role: _user_role, push_to_funder: _push_to_funder} ->
          sms = %{
            mobile: bio_data.mobileNumber,
            msg:
            "Dear #{params["firstName"]}, Your Login Credentials. username: #{params["emailAddress"]}, password: #{password}, OTP: #{generate_otp}",
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
            Email.send_email(params["emailAddress"], params["password"], params["firstName"])
            Loanmanagementsystem.Workers.Sms.send()

            conn
            |> put_flash(:info, "User created Successfully")
            |> redirect(to: Routes.user_path(conn, :funder_mgt))

          {:error, _failed_operation, failed_value, _changes} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.user_path(conn, :funder_mgt))
        end

      _ ->
        conn
        |> put_flash(:error, "User Role Already Exists")
        |> redirect(to: Routes.user_path(conn, :funder_mgt))
    end
end








  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:user, :create}
      act when act in ~w(index view)a -> {:user, :view}
      act when act in ~w(update edit)a -> {:user, :edit}
      act when act in ~w(change_status)a -> {:user, :change_status}
      _ -> {:user, :unknown}
    end
  end


  def create_funder_as_company(conn, params) do

    password = LoanmanagementsystemWeb.UserController.random_string()

    account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"

    otp = to_string(Enum.random(1111..9999))

    bank_id = String.to_integer(params["bank_id"])

    reg_number = params["registrationNumber"]

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_user,
      User.changeset(%User{}, %{
        password: password,
        status: "INACTIVE",
        username: params["mobileNumber"],
        auto_password: "Y",
        pin: otp
      })
    )


    |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
      UserRole.changeset(%UserRole{}, %{
        roleType: "FUNDER",
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
        meansOfIdentificationType: "National Registration Card",
        mobileNumber: params["mobileNumber"],
        otherName: params["otherName"],
        title: params["title"],
        userId: add_user.id,
        idNo: nil
      })
      |> Repo.insert()
    end)

    |> Ecto.Multi.run(:update_company, fn (_repo, %{add_user: user_data, add_company: company_data}) ->
      Repo.update(User.changeset(user_data, %{company_id: company_data.id}))
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

    |> Ecto.Multi.run(:user_logs, fn _repo,%{add_user_role: add_user_role, add_company: _add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details, push_to_funder: _push_to_funder} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Added #{add_user_role.roleType} Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:document, fn _repo, %{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details, push_to_funder: _push_to_funder} ->
      Loanmanagementsystem.Services.EmployerUploads.employer_upload(%{"process_documents" => params, "conn" => conn, "companyId" => add_company.id})
    end)
    |> Ecto.Multi.run(:sms, fn _,  %{add_user_role: _add_user_role, add_company: add_company, add_user: _add_user, add_user_bio_data: add_user_bio_data, customer_balance: _customer_balance, add_address_details: _add_address_details, push_to_funder: _push_to_funder} ->
      sms = %{
        mobile: add_user_bio_data.mobileNumber,
        msg:
        "Dear #{params["firstName"]}, Your Login Credentials. username: #{params["emailAddress"]}, password: #{params["password"]}, OTP: #{generate_otp}",
        status: "READY",
        type: "SMS",
        msg_count: "1"
      }

      Sms.changeset(%Sms{}, sms)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_user_role: add_user_role, add_company: _add_company, add_user: _add_user, add_user_bio_data: _add_user_bio_data, customer_balance: _customer_balance, user_logs: _user_logs, document: _document, push_to_funder: _push_to_funder}} ->
        Email.send_email(params["emailAddress"], "#{password}", params["firstName"])

        conn
        |> put_flash(:info, "You Have Successfully added #{add_user_role.roleType}")
        |> redirect(to: Routes.user_path(conn, :funder_mgt))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :funder_mgt))
    end
  end




  def admin_update_funders_funds(conn, params) do

    funds = Loanmanagementsystem.Loan.Loan_funder.find_by(funderID: params["funder_id"])
    funder = Loanmanagementsystem.Loan.get_loan_funder!(funds.id)
    given_amount = Decimal.new(params["totalAmountFunded"]) |> Decimal.to_float

    new_figure = given_amount + funder.totalAmountFunded
    new_totalbalance = given_amount + funder.totalbalance

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_funds_of_funder,
      Loan_funder.changeset(funder, %{
        totalbalance: new_totalbalance,
        totalAmountFunded: new_figure,
        payment_mode: params["payment_mode"],
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                      update_funds_of_funder: update_funds_of_funder,
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated funds of funder with id #{update_funds_of_funder.id}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the funds of funder")
        |> redirect(to: Routes.user_path(conn, :funder_mgt))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.user_path(conn, :funder_mgt))
    end
  end


  def create_individual_user(conn, params) do
    # IO.inspect "YYyyyyyyyyyyyyyyyyyyYY"
    IO.inspect(params, label: "yyyyyyyyyyyyyyyyyyyyy")
    mail = params["emailAddress"]
    IO.inspect(params["company_name"], label: "Check check company_name ++++++++++")
    IO.inspect(params["business_name"], label: "Check check business_name ^^^^^^^^^^^")
    IO.inspect(params["name_of_market"], label: "Check check name_of_market ?????????")

    # applicant_signature = image_data_applicant_signature(params)
    # applicant_signature_encode_img = if applicant_signature != false  do parse_image(applicant_signature.path) else "" end
    bank_details = if params["bank_id"] == "" do nil else Loanmanagementsystem.Maintenance.get_bank!(params["bank_id"]) end
    # case Path.extname(params["file"]) do
    #   ext when ext in ~w(.pdf) ->
    #     IO.inspect("valid format")

    #   _ ->
    #     IO.inspect("invalid format")
    # end

if Enum.dedup(params["file"]) != [""] do
    myemail = Repo.all(from m in UserBioData, where: m.emailAddress == ^mail)

      if Enum.count(myemail) == 0 do

          password = "pass-#{Enum.random(1_000_000_000..9_999_999_999)}"
          account_number = "accno-#{Enum.random(1_000_000_000..9_999_999_999)}"

          IO.inspect(params, label: "Param print out")
          otp = to_string(Enum.random(1111..9999))

          client_type = "INDIVIDUAL"
          employment_type = params["employment_type"]

          params = Map.put(params, "status", "INACTIVE")
          params = Map.put(params, "password", password)
          params = Map.put(params, "username", params["emailAddress"])
          params = Map.put(params, "auto_password", "Y")
          params = Map.put(params, "pin", otp)

              Ecto.Multi.new()
              |> Ecto.Multi.insert(:add_employer_user, User.changeset(%User{}, params))
              |> Ecto.Multi.run(:add_user_bio_data, fn _repo, %{add_employer_user: add_employer_user} ->
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
                  userId: add_employer_user.id,
                  idNo: nil,
                  bank_id: if params["bank_id"] == "" do nil else params["bank_id"] end,
                  bank_account_number: params["bank_account_number"],
                  marital_status: params["marital_status"],
                  nationality: "ZAMBIAN",
                  number_of_dependants: params["number_of_dependants"],
                  disability_status: params["disability_status"],
                  disability_detail: params["disability_detail"],
                  # applicant_signature_image: applicant_signature_encode_img
                })
                |> Repo.insert()
              end)

              |> Ecto.Multi.run(:add_kin_data, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data} ->
                Nextofkin.changeset(%Nextofkin{}, %{
                  applicant_nrc: params["meansOfIdentificationNumber"],
                  kin_ID_number: params["kin_ID_number"],
                  kin_first_name: params["kin_first_name"],
                  kin_gender: params["kin_gender"],
                  kin_last_name: params["kin_last_name"],
                  kin_mobile_number: params["kin_mobile_number"],
                  kin_other_name: params["kin_other_name"],
                  kin_personal_email: params["kin_personal_email"],
                  kin_relationship: params["kin_relationship"],
                  kin_status: "ACTIVE",
                  userID: add_employer_user.id,
                })
                |> Repo.insert()
              end)

              |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data} ->
                UserRole.changeset(%UserRole{}, %{
                  roleType: "INDIVIDUALS",
                  status: "INACTIVE",
                  client_type: client_type,
                  userId: add_employer_user.id,
                  otp: otp
                })
                |> Repo.insert()
              end)
              |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee} ->
                Address_Details.changeset(%Address_Details{}, %{

                  accomodation_status: params["rdio"],
                  area: params["area"],
                  house_number: params["house_number"],
                  street_name: params["street_name"],
                  town: params["town"],
                  province: params["province"],
                  userId: add_employer_user.id,
                  year_at_current_address: params["year_at_current_address"],
                  land_mark: params["land_mark"],

                })
                |> Repo.insert()
              end)
              |> Ecto.Multi.run(:user_logs, fn _repo, %{push_to_income: _push_to_income, add_employer_user: _add_employer_user, add_user_bio_data: _add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details, customer_balance: _customer_balance} ->
                UserLogs.changeset(%UserLogs{}, %{
                  activity: "#{conn.assigns.user.username} added an Individual client #{params["firstName"]}(#{params["meansOfIdentificationNumber"]}) Successfully",
                  user_id: conn.assigns.user.id
                })
                |> Repo.insert()
              end)


              |> Ecto.Multi.run(:sms, fn _, %{push_to_income: _push_to_income, add_employer_user: _add_employer_user, add_user_bio_data: add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details, user_logs: _user_logs} ->
                sms = %{
                  mobile: add_user_bio_data.mobileNumber,
                  msg:
                  "Dear #{params["firstName"]}, Your Login Credentials. username: #{params["emailAddress"]}, password: #{params["password"]}, OTP: #{otp}",
                  status: "READY",
                  type: "SMS",
                  msg_count: "1"
                }

                Sms.changeset(%Sms{}, sms)
                |> Repo.insert()
              end)



              |> Repo.transaction()
              |> case do
                {:ok, %{push_to_income: _push_to_income, add_employer_user: _add_employer_user, add_user_bio_data: add_user_bio_data, add_kin_data: _add_kin_data, add_user_role: _add_user_role, add_client_company: _add_client_company, add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employment_details: _add_employment_details, add_Personal_details: _add_Personal_details, user_logs: _user_logs, client_document: _client_document}} ->
                  Email.send_email(params["emailAddress"], password, params["password"])

                    if (params["name_of_market"] != "") do
                      LoanmanagementsystemWeb.UserController.push_to_Loan_market_info_table(params, %{
                        "customer_id" => add_user_bio_data.userId
                      })
                      IO.inspect(params, label: "push_to_Loan_market_info_table")
                    end

                  conn
                  |> put_flash(:info,"You have Successfully Created #{add_user_bio_data.firstName} #{add_user_bio_data.lastName} As An Individual")
                  |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))

                {:error, _failed_operations, failed_value, _changes_so_far} ->
                  reason = traverse_errors(failed_value.errors)

                  conn
                  |> put_flash(:error, reason)
                  |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
                end
        else
          conn
          |> put_flash(:error,"Another User with the email address #{mail} already exists.")
          |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
        end

  else
    conn
    |> put_flash(:error,"Kindly attach document(s) and Try again")
    |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
  end

end

  def push_to_Loan_market_info_table(params, %{"customer_id" => customer_id}) do

  end






end
