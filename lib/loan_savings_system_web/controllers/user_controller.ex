defmodule LoanSavingsSystemWeb.UserController do
  use LoanSavingsSystemWeb, :controller
  use Ecto.Schema
  alias LoanSavingsSystem.Repo
  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Accounts
  alias LoanSavingsSystem.Accounts.User
  alias LoanSavingsSystem.Accounts.UserRole
  alias LoanSavingsSystem.Client.UserBioData
  alias LoanSavingsSystem.Emails.Email
  alias LoanSavingsSystem.Logs.UserLogs
  alias LoanSavingsSystem.Notifications.Sms
  alias LoanSavingsSystem.Accounts.BankStaffRole
  alias LoanSavingsSystem.{Logs, Repo, Logs.UserLogs}
  alias LoanSavingsSystem.Auth
  alias LoanSavingsSystem.Transactions
  alias LoanSavingsSystem.FixedDeposit
  alias LoanSavingsSystem.FixedDeposit.FixedDeposits
  alias LoanSavingsSystem.Divestments.Divestment
  alias LoanSavingsSystem.Companies.Company
  alias LoanSavingsSystem.Companies.Documents
  alias LoanSavingsSystem.Notifications.Emails
  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo
  require Logger

  plug(
      LoanSavingsSystemWeb.Plugs.RequireAuth
        when action in [
              :user_creation,
              :generate_otp,
              :get_user_by_email,
              :get_user_by_user_role,
              :employee_dashboard,
              :employer_dashboard,
              :create_user,
              :create_new_user_role_for_existing_user,
              :savings_dashboard,
              :dashboard,
              :user_mgt,
              :savings_user_mgt,
              :user_roles,
              :add_user_roles,
              :activate_admin,
              :deactivate_admin,
              :delete_admin,
              :getEmployerUserByMobileNumberAndRoleType,
              :create_employer_admin,
              :add_employer_admin_role,
              :add_employer_employee_role,
              :getUserBioDataById,
              :getUserAddressesById,
              :getNextOfKinByUserId,
              :getEmployerUserByMobileNumberAndRoleType,
              :new_password,
              :change_pwd,
              :confirm_old_password,
              :password_render,
              :sme_dashboard,
              :offtaker_dashboard,
              :loans_admin_dashboard,
              :loans_ussd_logs
            ]
    )
  plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

    plug(
      LoanSavingsSystemWeb.Plugs.RequireAdmin
        when action in [
          :registred_companies,
          :profile_documents,
          :profile_users,
          :savings_dashboard,
          :user_logs,
          :ussd_logs,
          :user_mgt,
          :list_users,
          :user_creation
        ]
      )
      plug(
      LoanSavingsSystemWeb.Plugs.RequireEmployer
        when action in [
          :employer_dashboard
        ]
      )

      plug(
        LoanSavingsSystemWeb.Plugs.RequireIndividual
          when action in [
            :individual_dashboard
          ]
        )

        plug(
          LoanSavingsSystemWeb.Plugs.RequireSme
            when action in [
              :sme_dashboard
            ]
          )

          plug(
            LoanSavingsSystemWeb.Plugs.RequireOfftaker
              when action in [
                :offtaker_dashboard
              ]
            )

            plug(
              LoanSavingsSystemWeb.Plugs.RequireEmployee
                when action in [
                  :Employee_dashboard
                ]
              )






  def registred_companies(conn, _params), do: render(conn, "registred_companies.html", company: Repo.all(Company))

  def profile_documents(conn, %{"id" => id}), do: render(conn, "profile_documents.html", doc: Repo.all(from m in Documents, where: m.companyID == ^id, select: %{id: m.id, status: m.status, name: m.docName, path: m.docType}) |> Enum.map(fn map -> %{id: map.id, status: map.status, name: map.name, path: Enum.at(Path.wildcard(map.path), 0) } end) |> Enum.filter(fn %{id: _id, status: _status, name: _name, path: path} -> path != nil end))

  def profile_users(conn, %{"id" => id}) do
      user =
      User
      |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
      |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
      |> where([uA, uB, uR], uR.companyId == ^id)
      |> select([uA, uB, uR], %{
        username: uA.username,
        id: uA.id,
        status: uA.status,
        firstName: uB.firstName,
        lastName: uB.lastName,
        otherName: uB.otherName,
        dateOfBirth: uB.dateOfBirth,
        meansOfIdentificationType: uB.meansOfIdentificationType,
        meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
        title: uB.title,
        gender: uB.gender,
        mobileNumber: uB.mobileNumber,
        emailAddress: uB.emailAddress,
        roleType: uR.roleType,
        userId: uR.userId,
        physical_address: uB.physical_address
      })
      |> Repo.all()
      render(conn, "profile_users.html", user: user)
    end

  def user_creation(conn, _params), do: render(conn, "user_mgt.html")


  def generate_otp, do: to_string(Enum.random(1111..9999))


  def get_user_by_email(username) do
    case Repo.get_by(User, username: username) do
      nil -> {:error, "invalid User Name address"}
      user -> {:ok, user}
    end
  end

  def get_user_by_user_role(userId) do
    case Accounts.get_users(userId) do
      nil -> {:error, "invalid User Name address"}
     user ->
      user
    end
  end

  def employee_dashboard(conn, _params) do
    users = Accounts.list_tbl_users()
    loans = Intergrator.Intergrations.pbl_product_list
  #  user = Accounts.get_user!(conn.assigns.user.id).id
  # last_logged_in = Logs.last_logged_in(user)
    render(conn, "employee_dashboard.html", users: users, loans: loans)
  end

  def employer_dashboard(conn, _params) do
    current_user_role = get_session(conn, :current_user_role)
    query = from cl in LoanSavingsSystem.Companies.Company, where: cl.id == ^current_user_role.companyId, select: cl
        company = Repo.all(query);
        company = Enum.at(company, 0)
    users = Accounts.list_tbl_users()
  #  user = Accounts.get_user!(conn.assigns.user.id).id
  # last_logged_in = Logs.last_logged_in(user)
    render(conn, "employer_dashboard.html", users: users, company: company)
  end

  def month(m) do
    year = Date.utc_today().year|> to_string()
    {:ok, result} = Timex.parse(year<>"-"<>m<>"-01", "{YYYY}-{0M}-{D}")
    DateTime.from_naive!(result, "Etc/UTC")
  end

  def offtaker_dashboard(conn, _params) do
    current_user_role = get_session(conn, :current_user_role)
    query = from cl in LoanSavingsSystem.Companies.Company, where: cl.id == ^current_user_role.companyId, select: cl
    company = Repo.all(query);
    company = Enum.at(company, 0)
    users = Accounts.list_tbl_users()

    current_user_role = get_session(conn, :current_user_role);
    current_user = get_session(conn, :current_user);
    offtaker_id = current_user_role.companyId
    total_smes = LoanSavingsSystem.Companies.total_smes(offtaker_id)
  #  user = Accounts.get_user!(conn.assigns.user.id).id
  # last_logged_in = Logs.last_logged_in(user)

  #  company_id = Integer.to_string(company_id)
  #Pending_documents
  jandate = month("01")
   pendingjanstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(jandate) and au.updated_at <= ^Timex.end_of_month(jandate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  febdate = month("02")
   pendingfebstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(febdate) and au.updated_at <= ^Timex.end_of_month(febdate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  mardate = month("03")
   pendingmarstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(mardate) and au.updated_at <= ^Timex.end_of_month(mardate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  aprdate = month("04")
   pendingaprstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(aprdate) and au.updated_at <= ^Timex.end_of_month(aprdate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  maydate = month("05")
   pendingmaystats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(maydate) and au.updated_at <= ^Timex.end_of_month(maydate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  jundate = month("06")
   pendingjunstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(jundate) and au.updated_at <= ^Timex.end_of_month(jundate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  juldate = month("07")
   pendingjulstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(juldate) and au.updated_at <= ^Timex.end_of_month(juldate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  augdate = month("08")
   pendingaugstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(augdate) and au.updated_at <= ^Timex.end_of_month(augdate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  sepdate = month("09")
   pendingsepstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(sepdate) and au.updated_at <= ^Timex.end_of_month(sepdate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  octdate = month("10")
   pendingoctstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(octdate) and au.updated_at <= ^Timex.end_of_month(octdate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  novdate = month("11")
   pendingnovstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(novdate) and au.updated_at <= ^Timex.end_of_month(novdate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))
  decdate = month("12")
   pendingdecstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(decdate) and au.updated_at <= ^Timex.end_of_month(decdate) and au.status == "PENDING_OFFTAKER_APPROVAL", select: count(au.id))

   #approved_documents
   jandate = month("01")
   approvedjanstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(jandate) and au.updated_at <= ^Timex.end_of_month(jandate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   febdate = month("02")
   approvedfebstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(febdate) and au.updated_at <= ^Timex.end_of_month(febdate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   mardate = month("03")
   approvedmarstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(mardate) and au.updated_at <= ^Timex.end_of_month(mardate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   aprdate = month("04")
   approvedaprstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(aprdate) and au.updated_at <= ^Timex.end_of_month(aprdate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   maydate = month("05")
   approvedmaystats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(maydate) and au.updated_at <= ^Timex.end_of_month(maydate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   jundate = month("06")
   approvedjunstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(jundate) and au.updated_at <= ^Timex.end_of_month(jundate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   juldate = month("07")
   approvedjulstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(juldate) and au.updated_at <= ^Timex.end_of_month(juldate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   augdate = month("08")
   approvedaugstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(augdate) and au.updated_at <= ^Timex.end_of_month(augdate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   sepdate = month("09")
   approvedsepstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(sepdate) and au.updated_at <= ^Timex.end_of_month(sepdate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   octdate = month("10")
   approvedoctstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(octdate) and au.updated_at <= ^Timex.end_of_month(octdate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   novdate = month("11")
   approvednovstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(novdate) and au.updated_at <= ^Timex.end_of_month(novdate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))
   decdate = month("12")
   approveddecstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(decdate) and au.updated_at <= ^Timex.end_of_month(decdate) and au.status == "OFFTAKER_APPROVED", select: count(au.id))


   #Rejected_documents
   jandate = month("01")
   rejectedjanstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(jandate) and au.updated_at <= ^Timex.end_of_month(jandate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   febdate = month("02")
   rejectedfebstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(febdate) and au.updated_at <= ^Timex.end_of_month(febdate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   mardate = month("03")
   rejectedmarstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(mardate) and au.updated_at <= ^Timex.end_of_month(mardate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   aprdate = month("04")
   rejectedaprstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(aprdate) and au.updated_at <= ^Timex.end_of_month(aprdate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   maydate = month("05")
   rejectedmaystats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(maydate) and au.updated_at <= ^Timex.end_of_month(maydate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   jundate = month("06")
   rejectedjunstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(jundate) and au.updated_at <= ^Timex.end_of_month(jundate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   juldate = month("07")
   rejectedjulstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(juldate) and au.updated_at <= ^Timex.end_of_month(juldate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   augdate = month("08")
   rejectedaugstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(augdate) and au.updated_at <= ^Timex.end_of_month(augdate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   sepdate = month("09")
   rejectedsepstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(sepdate) and au.updated_at <= ^Timex.end_of_month(sepdate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   octdate = month("10")
   rejectedoctstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(octdate) and au.updated_at <= ^Timex.end_of_month(octdate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   novdate = month("11")
   rejectednovstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(novdate) and au.updated_at <= ^Timex.end_of_month(novdate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))
   decdate = month("12")
   rejecteddecstats = Repo.one(from au in LoanSavingsSystem.Documents.LoanDocument, where: au.offtaker_id == ^current_user_role.companyId and au.updated_at >= ^Timex.beginning_of_month(decdate) and au.updated_at <= ^Timex.end_of_month(decdate) and au.status == "OFFTAKER_REJECTED", select: count(au.id))

    render(conn, "offtaker_dashboard.html", users: users, company: company, total_smes: total_smes,
    pendingjanstats: pendingjanstats,
    pendingfebstats: pendingfebstats,
    pendingmarstats: pendingmarstats,
    pendingaprstats: pendingaprstats,
    pendingmaystats: pendingmaystats,
    pendingjunstats: pendingjunstats,
    pendingjulstats: pendingjulstats,
    pendingaugstats: pendingaugstats,
    pendingsepstats: pendingsepstats,
    pendingoctstats: pendingoctstats,
    pendingnovstats: pendingnovstats,
    pendingdecstats: pendingdecstats,

    approvedjanstats: approvedjanstats,
    approvedfebstats: approvedfebstats,
    approvedmarstats: approvedmarstats,
    approvedaprstats: approvedaprstats,
    approvedmaystats: approvedmaystats,
    approvedjunstats: approvedjunstats,
    approvedjulstats: approvedjulstats,
    approvedaugstats: approvedaugstats,
    approvedsepstats: approvedsepstats,
    approvedoctstats: approvedoctstats,
    approvednovstats: approvednovstats,
    approveddecstats: approveddecstats,

    rejectedjanstats: rejectedjanstats,
    rejectedfebstats: rejectedfebstats,
    rejectedmarstats: rejectedmarstats,
    rejectedaprstats: rejectedaprstats,
    rejectedmaystats: rejectedmaystats,
    rejectedjunstats: rejectedjunstats,
    rejectedjulstats: rejectedjulstats,
    rejectedaugstats: rejectedaugstats,
    rejectedsepstats: rejectedsepstats,
    rejectedoctstats: rejectedoctstats,
    rejectednovstats: rejectednovstats,
    rejecteddecstats: rejecteddecstats
    )

  end
  def individual_dashboard(conn, _params) do
    users = Accounts.list_tbl_users()
  #  user = Accounts.get_user!(conn.assigns.user.id).id
  # last_logged_in = Logs.last_logged_in(user)
    render(conn, "individual_dashboard.html", users: users)
  end

  def sme_dashboard(conn, _params) do
    current_user_role = get_session(conn, :current_user_role)
    query = from cl in LoanSavingsSystem.Companies.Company, where: cl.id == ^current_user_role.companyId, select: cl
        company = Repo.all(query);
        company = Enum.at(company, 0)
    users = Accounts.list_tbl_users()
  #  user = Accounts.get_user!(conn.assigns.user.id).id
  # last_logged_in = Logs.last_logged_in(user)
    render(conn, "sme_dashboard.html", users: users, company: company)
  end

  def create_user(conn, %{"username" => username} = params) do
    params = Map.put(params, "status", "ACTIVE")
    params = Map.put(params, "auto_password", "Y")
    get_username = Repo.get_by(User, username: username)
    case is_nil(get_username) do
      true ->
        Ecto.Multi.new()
        |> Ecto.Multi.insert(:create_user, User.changeset(%User{}, params))
        |> Ecto.Multi.run(:user_role, fn (_, %{create_user: user}) ->

            generate_otp = to_string(Enum.random(1111..9999))
          #Push Data To User Roles
          user_role = %{
            userId: user.id,
            roleType: params["roleType"],
            clientId: conn.assigns.user.clientId,
            status: user.status,
            otp: generate_otp
          }
          UserRole.changeset(%UserRole{}, user_role)
          |> Repo.insert()

        end)
        |> Ecto.Multi.run(:user_bio_data, fn (_, %{create_user: user}) ->
            #Push Data To Bio Data
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
              mobileNumber: params["username"],
              emailAddress: user.username,
              clientId: conn.assigns.user.clientId,
            }
          UserBioData.changeset(%UserBioData{}, user_bio_data)
          |> Repo.insert()
        end)
        |> Ecto.Multi.run(:user_log, fn (_, %{create_user: user}) ->
          activity = "created user with id \"#{user.id}\" "
            #Push Data To User Logs
            user_log = %{
              user_id: conn.assigns.user.id,
              activity: activity
            }

            UserLogs.changeset(%UserLogs{}, user_log)
            |> Repo.insert()
        end)
        |> Ecto.Multi.run(:sms, fn (_, %{user_bio_data: bio_data, user_role: user_role}) ->
          otp = user_role.otp
          sms = %{
            mobile: bio_data.mobileNumber,
            msg: "Dear customer, Your Login Credentials. username: #{params["username"]}, password: #{params["password"]}, OTP: #{otp}",
            status: "READY",
            type: "SMS",
            msg_count: "1",
            }
            Sms.changeset(%Sms{}, sms)
            |> Repo.insert()
        end)
        |> Repo.transaction()
          |> case do
            {:ok, %{create_user: _user, user_log: _user_log}} ->
              Email.send_email(params["emailAddress"], params["password"], params["firstName"])

              conn
              |> put_flash(:info, "Bank Staff User Account created Successfully")
              |> redirect(to: Routes.user_path(conn,  :user_mgt))

            {:error, _failed_operation, failed_value, _changes} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
                |> put_flash(:error, reason)
                |> redirect(to: Routes.user_path(conn,  :user_mgt))

          end
      _ ->
        # userId = Enum.at(get_username, 0).id;
        # roleType = params["roleType"];
        # #get_userrole = Repo.get_by(UserRole, userId: userId)#, roleType: roleType}
        # get_userrole =
        # User
        #   |> where(userId: ^userId)
        #   |> where(roleType: ^roleType)
        #   |> Repo.one
        # case is_nil(get_userrole) do
        #   true ->
        #     create_new_user_role_for_existing_user(conn, params, userId)

        #   _ ->
        #     conn
        #     |> put_flash(:error, "User Role Already Exists")
        #     |> redirect(to: Routes.user_path(conn,  :user_mgt))
        # end
        conn
            |> put_flash(:error, "User Role Already Exists")
            |> redirect(to: Routes.user_path(conn,  :user_mgt))
    end

  end

  def create_new_user_role_for_existing_user(conn, params, userId) do
    generate_otp = to_string(Enum.random(1111..9999))
    #Push Data To User Roles
    user_role = %{
      userId: userId,
      roleType: params["roleType"],
      clientId: conn.assigns.user.clientId,
      status: conn.assigns.user.status,
      otp: generate_otp
    }
    UserRole.changeset(%UserRole{}, user_role)
    |> Repo.insert()

    #Push Data To Bio Data
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
      clientId: params["clientId"],
    }
    UserBioData.changeset(%UserBioData{}, user_bio_data)
    |> Repo.insert()

    |> Repo.transaction()
    |> case do
      {:ok, %{create_user: _user}} ->
        conn
        |> put_flash(:info, "User created Successfully")
        |> redirect(to: Routes.user_path(conn,  :user_mgt))

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to create user.")
        |> redirect(to: Routes.user_path(conn,  :user_mgt))
    end
  end

	#def savings_dashboard(conn, _params) do
	#  users = Accounts.list_tbl_users()
	#  get_bio_datas = Accounts.get_logged_user_details
	#  user = Accounts.get_user!(conn.assigns.user.id).id
	#  last_logged_in = Logs.last_logged_in(user)
	# render(conn, "savings_dashboard.html", users: users, get_bio_datas: get_bio_datas)
	#end

  def month(m) do
    year = Date.utc_today().year|> to_string()
    {:ok, result} = Timex.parse(year<>"-"<>m<>"-01", "{YYYY}-{0M}-{D}")
    DateTime.from_naive!(result, "Etc/UTC")
  end

  def savings_dashboard(conn, _params) do
        users = Accounts.list_tbl_users()
        get_bio_datas = Accounts.get_logged_user_details
        #  user = Accounts.get_user!(conn.assigns.user.id).id
        # last_logged_in = Logs.last_logged_in(user)
        todays_transactions = Transactions.list_today_transactions()
        matured_transactions = FixedDeposit.list_matured_transactions()

        #for_fixed_transaction
        jandate = month("01")
        fxdjanstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(jandate) and au.inserted_at <= ^Timex.end_of_month(jandate) and au.fixedDepositStatus == "Active", select: count(au.id))

        febdate = month("02")
        fxdfebstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(febdate) and au.inserted_at <= ^Timex.end_of_month(febdate) and au.fixedDepositStatus == "Active", select: count(au.id))

        mardate = month("03")
        fxdmrcstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(mardate) and au.inserted_at <= ^Timex.end_of_month(mardate) and au.fixedDepositStatus == "Active", select: count(au.id))

        aprdate = month("04")
        fxdaprstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(aprdate) and au.inserted_at <= ^Timex.end_of_month(aprdate) and au.fixedDepositStatus == "Active", select: count(au.id))

        maydate = month("05")
        fxdmaystats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(maydate) and au.inserted_at <= ^Timex.end_of_month(maydate) and au.fixedDepositStatus == "Active", select: count(au.id))

        jundate = month("06")
        fxdjunstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(jundate) and au.inserted_at <= ^Timex.end_of_month(jundate) and au.fixedDepositStatus == "Active", select: count(au.id))

        juldate = month("07")
        fxdjulstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(juldate) and au.inserted_at <= ^Timex.end_of_month(juldate) and au.fixedDepositStatus == "Active", select: count(au.id))

        augdate = month("08")
        fxdaugstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(augdate) and au.inserted_at <= ^Timex.end_of_month(augdate) and au.fixedDepositStatus == "Active", select: count(au.id))

        sepdate = month("09")
        fxdsepstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(sepdate) and au.inserted_at <= ^Timex.end_of_month(sepdate) and au.fixedDepositStatus == "Active", select: count(au.id))

        octdate = month("10")
        fxdoctstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(octdate) and au.inserted_at <= ^Timex.end_of_month(octdate) and au.fixedDepositStatus == "Active", select: count(au.id))

        novdate = month("11")
        fxdnovstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(novdate) and au.inserted_at <= ^Timex.end_of_month(novdate) and au.fixedDepositStatus == "Active", select: count(au.id))

        decdate = month("12")
        fxddecstats = Repo.one(from au in FixedDeposits, where: au.inserted_at >= ^Timex.beginning_of_month(decdate) and au.inserted_at <= ^Timex.end_of_month(decdate) and au.fixedDepositStatus == "Active", select: count(au.id))
        #end_of_fixed_transaction

        #Divestment_transaction

        jandate = month("01")
        divjanstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(jandate) and au.inserted_at <= ^Timex.end_of_month(jandate) and au.divestmentType == "Active", select: count(au.id))

        febdate = month("02")
        divfebstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(febdate) and au.inserted_at <= ^Timex.end_of_month(febdate) and au.divestmentType == "Full Divestment", select: count(au.id))

        mardate = month("03")
        divmrcstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(mardate) and au.inserted_at <= ^Timex.end_of_month(mardate) and au.divestmentType == "Full Divestment", select: count(au.id))

        aprdate = month("04")
        divaprstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(aprdate) and au.inserted_at <= ^Timex.end_of_month(aprdate) and au.divestmentType == "Full Divestment", select: count(au.id))

        maydate = month("05")
        divmaystats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(maydate) and au.inserted_at <= ^Timex.end_of_month(maydate) and au.divestmentType == "Full Divestment", select: count(au.id))

        jundate = month("06")
        divjunstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(jundate) and au.inserted_at <= ^Timex.end_of_month(jundate) and au.divestmentType == "Full Divestment", select: count(au.id))

        juldate = month("07")
        divjulstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(juldate) and au.inserted_at <= ^Timex.end_of_month(juldate) and au.divestmentType == "Full Divestment", select: count(au.id))

        augdate = month("08")
        divaugstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(augdate) and au.inserted_at <= ^Timex.end_of_month(augdate) and au.divestmentType == "Full Divestment", select: count(au.id))

        sepdate = month("09")
        divsepstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(sepdate) and au.inserted_at <= ^Timex.end_of_month(sepdate) and au.divestmentType == "Full Divestment", select: count(au.id))

        octdate = month("10")
        divoctstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(octdate) and au.inserted_at <= ^Timex.end_of_month(octdate) and au.divestmentType == "Full Divestment", select: count(au.id))

        novdate = month("11")
        divnovstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(novdate) and au.inserted_at <= ^Timex.end_of_month(novdate) and au.divestmentType == "Full Divestment", select: count(au.id))

        decdate = month("12")
        divdecstats = Repo.one(from au in Divestment, where: au.inserted_at >= ^Timex.beginning_of_month(decdate) and au.inserted_at <= ^Timex.end_of_month(decdate) and au.divestmentType == "Full Divestment", select: count(au.id))

        #End_Divestment_transaction
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
                divdecstats: divdecstats
                )


  end


  def dashboard(conn, _params) do
    users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details
  #  user = Accounts.get_user!(conn.assigns.user.id).id
  # last_logged_in = Logs.last_logged_in(user)
    render(conn, "dashboard.html", users: users, get_bio_datas: get_bio_datas)
  end

  def user_mgt(conn, _params) do
    bank_roles = Accounts.list_tbl_bank_staff_role()
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details
  # roles = Accounts.list_tbl_user_role()
    render(conn, "user_mgt.html", system_users: system_users, get_bio_datas: get_bio_datas, bank_roles: bank_roles)
  end

  def savings_user_mgt(conn, _params) do
    bank_roles = Accounts.list_tbl_bank_staff_role()
    system_users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details
  # roles = Accounts.list_tbl_user_role()
    render(conn, "user_mgt.html", system_users: system_users, get_bio_datas: get_bio_datas, bank_roles: bank_roles)
  end



  def loans_admin_dashboard(conn, _params) do
    users = Accounts.list_tbl_users()
    get_bio_datas = Accounts.get_logged_user_details
  #  user = Accounts.get_user!(conn.assigns.user.id).id
  # last_logged_in = Logs.last_logged_in(user)
    render(conn, "loans_dashboard.html", users: users, get_bio_datas: get_bio_datas)
  end










  def user_roles(conn, _params) do
    bank_roles = Accounts.list_tbl_bank_staff_role()
    render(conn, "user_roles.html", bank_roles: bank_roles)
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
    users_approve = Accounts.get_user!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "ACTIVE" }))
    |> Ecto.Multi.run(:user_log, fn (_, %{users: _users}) ->
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
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "DEACTIVATED" }))
    |> Ecto.Multi.run(:user_log, fn (_, %{users: _users}) ->
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
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "BLOCKED" }))
    |> Ecto.Multi.run(:user_log, fn (_, %{users: _users}) ->
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
      mobileNumber = params["mobileNumber"];
      roleType = params["roleType"];
      companyId = params["companyId"];
      userStatus = "ACTIVE";

      query = from cl in LoanSavingsSystem.Accounts.User, where: (cl.username== ^mobileNumber and cl.status == ^userStatus), select: cl
      users = Repo.all(query);

      if(Enum.count(users)==0) do
          response = %{
              status: 0
          }
          LoanSavingsSystemWeb.ProductController.send_response(conn, response);
      else
          user = Enum.at(users, 0);
          query = from cl in LoanSavingsSystem.Accounts.UserRole, where: (cl.userId== ^user.id and cl.roleType == ^roleType and
                  cl.companyId == ^companyId and cl.status == ^userStatus), select: cl
          userRoles = Repo.all(query);
          if(Enum.count(userRoles)==0) do
              query = from cl in LoanSavingsSystem.Client.UserBioData, where: (cl.userId== ^user.id), select: cl
              userBioDatas = Repo.all(query);
              userBioData = Enum.at(userBioDatas, 0);


              query = from cl in LoanSavingsSystem.Accounts.UserRole, where: (cl.userId== ^user.id and
                  cl.companyId == ^companyId and cl.status == ^userStatus), select: cl.roleType
              userRoles = Repo.all(query);

              response = %{
                  status: 1,
                  userBioData: userBioData,
                  userRoles: Enum.join(userRoles, ", ")
              }
              LoanSavingsSystemWeb.ProductController.send_response(conn, response);
          else
              response = %{
                  status: -1,
                  message: "A company administrator of the same company having the same number already exists"
              }
              LoanSavingsSystemWeb.ProductController.send_response(conn, response);
          end
      end




  end








  def create_employer_admin(conn, params) do
    current_user = get_session(conn, :current_user);
    mobileNumber = params["mobileNumber"];
    companyId = params["companyId"];
    title = params["title"];
    first_name = params["first_name"];
    last_name = params["last_name"];
    email = params["email"];
    id_type = params["id_type"];
    id_no = params["id_no"];
    address = params["address"];
    sex = params["sex"];
    user_role = params["user_role"];
    age = params["age"];
    userStatus = "ACTIVE";
    roleType = "COMPANY ADMIN"
    clientId = get_session(conn, :client_id)

    query = from cl in LoanSavingsSystem.Accounts.User, where: (cl.username== ^mobileNumber and cl.status == ^userStatus), select: cl
    users = Repo.all(query);

    Logger.info "User Count ... #{Enum.count(users)}"

    if(Enum.count(users)==0) do

        query = from cl in LoanSavingsSystem.Companies.Company, where: (cl.id== ^companyId), select: cl
        companies = Repo.all(query);
        company = Enum.at(companies, 0);
        registrationNumber = company.registrationNumber

        current_user = get_session(conn, :current_user);
        mobileNumber = params["mobileNumber"];
        companyId = params["companyId"];
        title = params["title"];
        first_name = params["first_name"];
        last_name = params["last_name"];
        email = params["email"];
        id_type = params["id_type"];
        id_no = params["id_no"];
        address = params["address"];
        sex = params["sex"];
        user_role = params["user_role"];
        age = params["age"];
        userStatus = "ACTIVE";
        roleType = "COMPANY ADMIN"
        clientId = get_session(conn, :client_id)
        age = Date.from_iso8601!(age)

        user = %LoanSavingsSystem.Accounts.User{
            username: mobileNumber,
            clientId: conn.assigns.user.clientId,
            createdByUserId: current_user,
            status: userStatus,
        }

        case Repo.insert(user) do
            {:ok, user} ->
                user_bio_data = %LoanSavingsSystem.Client.UserBioData{
                    firstName: first_name,
                    lastName: last_name,
                    userId: user.id,
                    otherName: nil,
                    dateOfBirth: (age),
                    meansOfIdentificationType: id_type,
                    meansOfIdentificationNumber: id_no,
                    title: title,
                    gender: sex,
                    mobileNumber: mobileNumber,
                    emailAddress: email,
                    clientId: conn.assigns.user.clientId,
                }
                case Repo.insert(user_bio_data) do
                    {:ok, user_bio_data} ->
                        otp = Enum.random(1_000..9_999)
                        otp = Integer.to_string(otp)


                        appUserRole = %LoanSavingsSystem.Accounts.UserRole{
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
                                  |> put_flash(:info, "Company Administrator role could not be be created for the user")
                                  |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")
                        end
                    {:error, changeset} ->
                        conn
                          |> put_flash(:info, "Company Administrator profile could not be be created for the user")
                          |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")
                end
            {:error, changeset} ->
                conn
                  |> put_flash(:info, "Company Administrator profile could not be be created for the user")
                  |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")
        end


    else
        us = Enum.at(users, 0);

        query = from cl in LoanSavingsSystem.Companies.Company, where: (cl.id== ^companyId), select: cl
        companies = Repo.all(query);
        company = Enum.at(companies, 0);
        registrationNumber = company.registrationNumber

        conn
          |> put_flash(:error, "Use the option to add a role to this user instead")
          |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")

    end
end



def add_employer_admin_role(conn, params) do
    mobileNumber = params["mobileNumber"];
    companyId = params["companyId"];
    userStatus = "ACTIVE";
    roleType = "COMPANY ADMIN"
    clientId = get_session(conn, :client_id)

    query = from cl in LoanSavingsSystem.Accounts.User, where: (cl.username== ^mobileNumber and cl.status == ^userStatus), select: cl
    users = Repo.all(query);

    if(Enum.count(users)==0) do
        response = %{
            status: 0
        }
        LoanSavingsSystemWeb.ProductController.send_response(conn, response);
    else
        user = Enum.at(users, 0);
        query = from cl in LoanSavingsSystem.Companies.Company, where: (cl.id== ^companyId), select: cl
        companies = Repo.all(query);
        company = Enum.at(companies, 0);
        registrationNumber = company.registrationNumber

        query = from cl in LoanSavingsSystem.Accounts.UserRole, where: (cl.userId== ^user.id and cl.roleType == ^roleType and
                cl.companyId == ^companyId and cl.status == ^userStatus), select: cl
        userRoles = Repo.all(query);
        if(Enum.count(userRoles)==0) do
            otp = Enum.random(1_000..9_999)
            otp = Integer.to_string(otp)


            appUserRole = %LoanSavingsSystem.Accounts.UserRole{
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
                      |> put_flash(:info, "Company Administrative role could not be been added to the users profile")
                      |> redirect(to: "/Add/Employer/Admin?company_id=#{registrationNumber}")
            end

        else
            response = %{
                status: -1,
                message: "A company administrator of the same company having the same number already exists"
            }
            LoanSavingsSystemWeb.ProductController.send_response(conn, response);
        end
    end
end


def add_employer_employee_role(conn, params) do
    mobileNumber = params["mobileNumber"];
    companyId = params["companyId"];
    netPay = params["netPay"];
    userStatus = "ACTIVE";
    roleType = "EMPLOYEE"
    clientId = get_session(conn, :client_id)
    netPay = elem Float.parse(netPay), 0

    query = from cl in LoanSavingsSystem.Accounts.User, where: (cl.username== ^mobileNumber and cl.status == ^userStatus), select: cl
    users = Repo.all(query);

    if(Enum.count(users)==0) do
        response = %{
            status: 0
        }
        LoanSavingsSystemWeb.ProductController.send_response(conn, response);
    else
        user = Enum.at(users, 0);
        query = from cl in LoanSavingsSystem.Companies.Company, where: (cl.id== ^companyId), select: cl
        companies = Repo.all(query);
        company = Enum.at(companies, 0);
        registrationNumber = company.registrationNumber

        query = from cl in LoanSavingsSystem.Accounts.UserRole, where: (cl.userId== ^user.id and cl.roleType == ^roleType and
                cl.companyId == ^companyId and cl.status == ^userStatus), select: cl
        userRoles = Repo.all(query);
        if(Enum.count(userRoles)==0) do
            otp = Enum.random(1_000..9_999)
            otp = Integer.to_string(otp)


            appUserRole = %LoanSavingsSystem.Accounts.UserRole{
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
                      |> put_flash(:info, "Company Employee role could not be been added to the users profile")
                      |> redirect(to: "/Add/Employer/Staff?company_id=#{companyId}")
            end

        else
            response = %{
                status: -1,
                message: "A company employee of the same company having the same number already exists"
            }
            LoanSavingsSystemWeb.ProductController.send_response(conn, response);
        end
    end
end


def loans_add_employer_employee_role(conn, params) do
  mobileNumber = params["mobileNumber"];
  companyId = params["companyId"];
  netPay = params["netPay"];
  userStatus = "ACTIVE";
  roleType = "EMPLOYEE"
  clientId = get_session(conn, :client_id)
  netPay = elem Float.parse(netPay), 0

  query = from cl in LoanSavingsSystem.Accounts.User, where: (cl.username== ^mobileNumber and cl.status == ^userStatus), select: cl
  users = Repo.all(query);

  if(Enum.count(users)==0) do
      response = %{
          status: 0
      }
      LoanSavingsSystemWeb.ProductController.send_response(conn, response);
  else
      user = Enum.at(users, 0);
      query = from cl in LoanSavingsSystem.Companies.Company, where: (cl.id== ^companyId), select: cl
      companies = Repo.all(query);
      company = Enum.at(companies, 0);
      registrationNumber = company.registrationNumber

      query = from cl in LoanSavingsSystem.Accounts.UserRole, where: (cl.userId== ^user.id and cl.roleType == ^roleType and
              cl.companyId == ^companyId and cl.status == ^userStatus), select: cl
      userRoles = Repo.all(query);
      if(Enum.count(userRoles)==0) do
          otp = Enum.random(1_000..9_999)
          otp = Integer.to_string(otp)


          appUserRole = %LoanSavingsSystem.Accounts.UserRole{
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
                    |> redirect(to: "/Loans/Maintenence/Companies/Create/Customer/Employee?company_id=#{companyId}")
              {:error, changeset} ->
                  conn
                    |> put_flash(:info, "Company Employee role could not be been added to the users profile")
                    |> redirect(to: "/Loans/Maintenence/Companies/Create/Customer/Employee?company_id=#{companyId}")
          end

      else
          response = %{
              status: -1,
              message: "A company employee of the same company having the same number already exists"
          }
          LoanSavingsSystemWeb.ProductController.send_response(conn, response);
      end
  end
end




def getUserBioDataById(conn, params) do
  bioDataId = params["bioDataId"];


  query = from cl in LoanSavingsSystem.Client.UserBioData, where: (cl.id== ^bioDataId), select: cl
      userBioData = Repo.all(query);
      userBioData = Enum.at(userBioData, 0);

  uB = %{"First Name"=>userBioData.firstName, "Last Name"=>userBioData.lastName, "Date Of Birth"=>userBioData.dateOfBirth,
      "Means Of Identification Type"=>userBioData.meansOfIdentificationType, "Means Of Identification Number"=>userBioData.meansOfIdentificationNumber,
      "Mobile Number"=>userBioData.mobileNumber, "Email Address"=>userBioData.emailAddress
  };

  response = %{
      bioData: uB,
      status: 1
  }

  LoanSavingsSystemWeb.ProductController.send_response(conn, response);
end


def getUserAddressesById(conn, params) do
  userId = params["userId"];


  query = from cl in LoanSavingsSystem.Client.Address, where: (cl.userId== ^userId), order_by: [desc: cl.isCurrent], select: cl
      addresses = Repo.all(query);

  response = %{
      addresses: addresses,
      status: 1
  }

  LoanSavingsSystemWeb.ProductController.send_response(conn, response);
end



def getNextOfKinByUserId(conn, params) do
  userId = params["userId"];


  query = from cl in LoanSavingsSystem.Client.NextOfKin, where: (cl.userId== ^userId), order_by: [desc: cl.inserted_at], select: cl
      nextOfKins = Repo.all(query);

  response = %{
      nextOfKins: nextOfKins,
      status: 1
  }

  LoanSavingsSystemWeb.ProductController.send_response(conn, response);
end



def getEmployerUserByMobileNumberAndRoleType(conn, params) do
  mobileNumber = params["mobileNumber"];
  roleType = params["roleType"];
  companyId = params["companyId"];
  userStatus = "ACTIVE";

  query = from cl in LoanSavingsSystem.Accounts.User, where: (cl.username== ^mobileNumber and cl.status == ^userStatus), select: cl
  users = Repo.all(query);

  if(Enum.count(users)==0) do
      response = %{
          status: 0
      }
      LoanSavingsSystemWeb.ProductController.send_response(conn, response);
  else
      user = Enum.at(users, 0);
      query = from cl in LoanSavingsSystem.Accounts.UserRole, where: (cl.userId== ^user.id and cl.roleType == ^roleType and
              cl.companyId == ^companyId and cl.status == ^userStatus), select: cl
      userRoles = Repo.all(query);
      if(Enum.count(userRoles)==0) do
          query = from cl in LoanSavingsSystem.Client.UserBioData, where: (cl.userId== ^user.id), select: cl
          userBioDatas = Repo.all(query);
          userBioData = Enum.at(userBioDatas, 0);


          query = from cl in LoanSavingsSystem.Accounts.UserRole, where: (cl.userId== ^user.id and
              cl.companyId == ^companyId and cl.status == ^userStatus), select: cl.roleType
          userRoles = Repo.all(query);

          response = %{
              status: 1,
              userBioData: userBioData,
              userRoles: Enum.join(userRoles, ", ")
          }
          LoanSavingsSystemWeb.ProductController.send_response(conn, response);
      else
          response = %{
              status: -1,
              message: "A company administrator of the same company having the same number already exists"
          }
          LoanSavingsSystemWeb.ProductController.send_response(conn, response);
      end
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
    spec =Enum.to_list(?2..?9)
    length = 2
    Enum.take_random(spec, length)
  end
  def number2 do
    spec =Enum.to_list(?1..?9)
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
    Enum.take_random(spec, length)|> to_string()|> String.replace("'", "^")|> String.replace("(", "!")|> String.replace(")", "@")
  end

  def random_string do
    smll = to_string(small_latter())
    smll2 = to_string(small_latter2())
    nmb = to_string(number())
    nmb2 = to_string(number2())
    spc = to_string(special())
    cpl = to_string(caplock())
    smll<>""<>nmb<>""<>spc<>""<>cpl<>""<>nmb2<>""<>smll2
  end

  def generate_random_password(conn, _param) do
    account = random_string()
    json(conn, %{"account" => account})
  end

  def user_logs(conn, _params) do
    user_activity = Logs.list_tbl_user_activity_logs()
    render(conn, "user_logs.html", user_activity: user_activity)
  end

  def loans_user_logs(conn, _params) do
    user_activity = Logs.list_tbl_user_activity_logs()
    render(conn, "loans_user_logs.html", user_activity: user_activity)
  end

  def ussd_logs(conn, _params) do
    query = from au in LoanSavingsSystem.UssdLogs.UssdLog,
		join: userBioData in UserBioData,
		on:
		au.userId == userBioData.userId,
		select: %{au: au, userBioData: userBioData}
	ussdLogs = Repo.all(query);
    render(conn, "ussd_logs.html", ussdLogs: ussdLogs)
  end

  def loans_ussd_logs(conn, _params) do
    query = from au in LoanSavingsSystem.UssdLogs.UssdLog,
		join: userBioData in UserBioData,
		on:
		au.userId == userBioData.userId,
		select: %{au: au, userBioData: userBioData}
	ussdLogs = Repo.all(query);
    render(conn, "loans_ussd_logs.html", ussdLogs: ussdLogs)
  end








  #-----------------------------------------------------------------LoansUserManagement -------->>>>System Users
def loans_user_mgt(conn, _params) do # permissions
  bank_roles = Accounts.list_tbl_user_roles() |> IO.inspect
  system_users = Accounts.list_tbl_users() # |> Enum.map(fn map -> Map.put(map, :permissions, String.split(map.permissions, "~") ) end) |> IO.inspect
  get_bio_datas = Accounts.get_logged_user_details() |> IO.inspect
  roles = LoanSavingsSystem.Accounts.list_tbl_roles
  render(conn, "loans_user_mgt.html", system_users: system_users, get_bio_datas: get_bio_datas, bank_roles: bank_roles, roles: roles)
end
# LoanSavingsSystemWeb.UserController.Client.get_user_bio_data!(1)

def test do #  LoanSavingsSystemWeb.UserController.test
  p =
  %{
    "_csrf_token" => "J0R6HTA4XyQmZSE7dSwIHH0JHERSLylUF-9pJZ7rA3PNGK8q8yF01iql",
    "address" => "zccm",
    "auth_level" => "1",
    "createdByUserId" => 1,
    "dateOfBirth" => "2021-12-16",
    "emailAddress" => "musengamvula1@gmail.com",
    "firstName" => "musenga",
    "gender" => "MALE",
    "lastName" => "Mvula",
    "meansOfIdentificationNumber" => "111/11/123",
    "meansOfIdentificationType" => "NRC",
    "mobileNumber" => "0975136899",
    "otherName" => "base",
    "password" => "n%IUK105G",
    "permissions" => "super_admin~deactivator~approver~creator",
    "roleType" => "ADMIN",
    "status" => "ACTIVE",
    "title" => "Mr",
    "userId" => 60,
    "username" => "musengamvula1@gmail.com"
  }

  Repo.insert(UserBioData.changeset(%UserBioData{},  p ))
end



def loans_create_user(conn, params) do
  password = LoanSavingsSystem.Workers.Resource.random_string(3)
  otp = to_string(Enum.random(1111..9999))


   username = params["emailAddress"]
    role_Type = String.split(params["roleType"], "|||")
    params = Map.put(params, "auto_password", "Y")
    IO.inspect(role_Type, label: "Check roletype here ")
    # IO.inspect(username, label: "Check Email ^^^^^^^^^^^^^\n ")

    params =
      Map.merge(params, %{
        "roleType" => Enum.at(role_Type, 1),
        "role_id" => Enum.at(role_Type, 0),
        "username" => username
      })


  case Repo.get_by(User, username: params["emailAddress"]) do
    nil ->

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:create_user, User.changeset(%User{}, params))
      |> Ecto.Multi.run(:user_role, fn _repo, %{create_user: create_user} ->

        case Repo.insert(UserRole.changeset(%UserRole{}, %{userId: create_user.id, status: "ACTIVE", roleType: params["roleType"], otp: otp } ) ) do
          {:ok, role} -> {:ok, role}
          {:error, changeset} -> {:error, changeset}
        end
      end)
      |> Ecto.Multi.run(:boi_data, fn _repo, %{create_user: create_user} ->
        case Repo.insert(UserBioData.changeset(%UserBioData{},  Map.put(params, "userId", create_user.id) )) do
            {:ok, boi_data} -> {:ok, boi_data}
            {:error, changeset} -> {:error, changeset}
          end
        end)
      |> Ecto.Multi.run(:emails, fn _repo, %{create_user: create_user} ->
          email = %{
                    first_name: params["firstName"],
                    last_name: params["lastName"],
                    email: params["emailAddress"],
                    msg: "Dear #{params["firstName"]} #{params["lastName"]}, your account has been created username: #{create_user.username} password: #{password}",
                    msg_count: "0",
                    status: "READY",
                    type: "SME",
                    date_sent: NaiveDateTime.utc_now
                  }
          case Repo.insert(Emails.changeset(%Emails{}, email)) do
            {:ok, resp} -> {:ok, resp}
            {:error, msg} -> {:error, msg}
          end
      end)
      |> Ecto.Multi.run(:notification, fn _repo, %{boi_data: _boi_data} ->
          notify =  %{
                        url: "/Loans/User/Management",
                        message: "profile registration",
                        belongs_to: "BACK_OFFICE",
                        type: "REGISTRATION",
                        creator_id: conn.assigns.user.id,
                        creator_user_id: conn.assigns.user.id,
                        status: false,
                        recipient_id: nil
                      }
          case Repo.insert(LoanSavingsSystem.Notification.OnPlatformNotification.changeset(%LoanSavingsSystem.Notification.OnPlatformNotification{}, notify)) do
            {:ok, resp} -> {:ok, resp}
            {:error, msg} -> {:error, msg}
          end
      end)
      |> Ecto.Multi.run(:user_log, fn _repo, %{create_user: create_user} ->
        case Repo.insert( UserLogs.changeset(%UserLogs{}, %{user_id: conn.assigns.user.id, activity: "created user with id \"#{create_user.id}\" " }) ) do
          {:ok, resp} -> {:ok, resp}
          {:error, msg} -> {:error, msg}
        end
      end)
      |> Ecto.Multi.run(:sms, fn _repo, %{boi_data: _boi_data} ->
        sms = %{mobile: params["mobileNumber"],
          msg: "Dear customer, Your Login Credentials. username: #{params["username"]}, password: #{password}, OTP: #{otp}",
          status: "READY", type: "SMS", msg_count: "1", }
          case Repo.insert( Sms.changeset(%Sms{}, sms) ) do
            {:ok, resp} -> {:ok, resp}
            {:error, msg} -> {:error, msg}
          end
      end)
      |> Repo.transaction()
      |> case do
          {:ok, %{user_log: _user_log}} ->
            conn |> put_flash(:info, "User Account created Successfully") |> redirect(to: Routes.user_path(conn,  :loans_user_mgt))
          {:error, _failed_operation, failed_value, _changes} ->
            reason = traverse_errors(failed_value.errors) |> List.first()
            conn |> put_flash(:error, reason) |> redirect(to: Routes.user_path(conn,  :loans_user_mgt))
        end
    user -> conn |> put_flash(:error, "User #{user.username} Already Exists") |> redirect(to: Routes.user_path(conn,  :loans_user_mgt))
  end
end

def loans_update_user(conn, params) do

    params = Map.put(params, "permissions", Enum.reduce(params["permissions"], fn x, acc -> x <> "~" <> acc end) )

    user = Repo.get_by(UserBioData, userId: params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, UserBioData.changeset(user, params))
    |> Ecto.Multi.run(:user_log, fn (_, %{user: user}) ->
        activity = "Updated user with ID \"#{user.id}\""
        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }
        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_details, fn (_, _) ->
      case update_user_details(Repo.get_by(User, id: params["id"] ), %{username: params["emailAddress"]}) do
        {:ok, resp} -> {:ok, resp}
        {:error, msg} -> {:error, msg}
      end
    end)
    |> Ecto.Multi.run(:user_role, fn (_, _) ->
      case update_user_role(Repo.get_by(UserRole, userId: params["id"] ) ,params) do
        {:ok, resp} -> {:ok, resp}
        {:error, msg} -> {:error, msg}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user_role: _user_role, user: _user, user_log: _user_log, user_details: _user_details}} ->
        conn
        |> put_flash(:info, "User updated successfully")
        |> redirect(to: Routes.user_path(conn, :loans_user_mgt))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.user_path(conn, :loans_user_mgt))
    end
  end

  def update_user_details(%User{} = user_details, changes), do: Repo.update( User.changeset(user_details, changes) )
  def update_user_role(%UserRole{} = user_role, changes), do: Repo.update( UserRole.changeset(user_role, changes) )


  def traverse_errors(errors) do
    IO.inspect errors
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end



        ########################################################################## RUSSELL #############################################################################

        # def update_employee(conn, params) do
        #   student = Acoounts.get_user!(params["id"])


        #   query = from au in Rhema.Accounts.UserBioData, where: (au.meansOfIdentificationNumber == ^rec), select: au
        #   user_bio_data = Repo.one(query)
        #   new_params = Map.merge(params, %{"firstName" => (params["nameFirst"]),
        #   "lastName" => (params["nameLast"]),
        #   "otherName" => (params["nameMiddle"]),
        #   "dateOfBirth" => (params["dateBirthday"]),
        #   "meansOfIdentificationNumber" => (params["studentinfosid"]),
        #   "mobileNumber" => (params["commbyMobile_Home"]),
        #   "emailAddress" => (params["pref_Email"]) })

        #   #Push Data To student
        #   Ecto.Multi.new()
        #   |> Ecto.Multi.update(:student, Students.changeset(student, params))
        #   |> Ecto.Multi.run(:user_log, fn (_, %{student: student}) ->
        #       activity = "Updated student with code \"#{student.id}\""

        #       user_logs = %{
        #         user_id: conn.assigns.user.id,
        #         activity: activity
        #       }
        #       UserLogs.changeset(%UserLogs{}, user_logs)
        #       |> Repo.insert()
        #   end)

        #   #Push Data To user_bio_data
        #   |> Ecto.Multi.update(:user_bio_data, UserBioData.changeset(user_bio_data, new_params))
        #   |> Repo.transaction()
        #     |> case do
        #       {:ok, %{student: _student, user_log: _user_log}} ->
        #         conn
        #         |> put_flash(:info, "Student updated successfully.")
        #         |> redirect(to: Routes.students_path(conn, :index ))

        #       {:error, _failed_operation, failed_value, _changes_so_far} ->
        #         reason = traverse_errors(failed_value.errors) |> List.first()

        #         conn
        #         |> put_flash(:error, reason)
        #         |> redirect(to: Routes.students_path(conn, :index ))
        #     end
        # end

   ########################################################################## RUSSELL #############################################################################



  #  ---------------------------------------------------------------------------MIZ--------------------------------------------------------
  alias LoanSavingsSystem.Accounts.Role


  def user_roles_mgt(conn, _params) do
    bank_roles = Accounts.list_tbl_bank_staff_role()
    user_roles = LoanSavingsSystem.Accounts.list_tbl_roles()
    render(conn, "user_roles_mgt.html", bank_roles: bank_roles, user_roles: user_roles)
  end


def edit_user_roles(conn, %{"id" => id}) do
  role =
    id
    |> Accounts.get_role!()
    |> Map.update!(:role_str, &AtomicMap.convert(&1, %{safe: false}))

  render(conn, "edit_user_roles_mgt.html", role: role)
end

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

  def view_user_roles(conn, %{"id" => id}) do
    role =
      id
      |> Accounts.get_role!()
      |> Map.update!(:role_str, &AtomicMap.convert(&1, %{safe: false}))

    render(conn, "view_roles.html", role: role)
  end

  defp handle_create(user, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :user_role,
      Role.changeset(%Role{status: "INACTIVE"}, params)
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




  # ------------------------------------------------------------------------------MIZ END-------------------------------------------------------------


end
