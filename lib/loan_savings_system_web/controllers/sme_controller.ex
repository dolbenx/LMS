defmodule LoanSavingsSystemWeb.SmeController do
  use LoanSavingsSystemWeb, :controller

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.{Repo, Sme, UserManagement}
  alias LoanSavingsSystem.Companies.{Documents, Company, Branch}
  alias LoanSavingsSystem.Accounts.{UserRole, User}
  alias LoanSavingsSystem.Products.Product
  alias LoanSavingsSystem.Loan.Loans
  alias LoanSavingsSystem.Workers.Resource
  alias LoanSavingsSystem.Registration
  alias LoanSavingsSystem.Logs.UserLogs
  alias LoanSavingsSystem.Client.UserBioData
  alias LoanSavingsSystem.Notifications.{Emails, Sms}
  alias LoanSavingsSystem.Companies.{Company, Documents}
  alias LoanSavingsSystem.Notification.Announcements
  alias LoanSavingsSystem.LoanApplications.LoanApplicationsSme

  # plug(
  #   LoanSavingsSystemWeb.Plugs.RequireSmeAccess
  #     when action not in [:add_documents]
  #   )

  plug(
    LoanSavingsSystemWeb.Plugs.RequireSme
      when action  in [
        :off_takers,
        :offtaker_document,
        :company_documents,
        :edit_company,
        :apply_for_loan,
        :sme_user_logs,
        :sme_announcements,
        :company_details
      ]
    )


    ######################################################################################################################################################################

  def sme_loan_products(conn, _params) do
    invoice = Intergrator.Intergrations.sme_product_list(1)
    orderfinance = Intergrator.Intergrations.sme_product_list(2)
    render(conn, "loan_product.html", invoice: invoice, orderfinance: orderfinance)
  end

  def sme_apply_loan(conn, params) do
        params = Map.put(params, "financetype", String.to_integer(params["financetype"]))
        params = Map.put(params, "invoicevalue", String.to_float(params["invoicevalue"]))
        params = Map.put(params, "loanamount", String.to_float(params["loanamount"]))
        params = Map.put(params, "collateralvalue", String.to_float(params["collateralvalue"]))
        params = Map.put(params, "appraisedvalue", String.to_float(params["appraisedvalue"]))
        params = Map.put(params, "documenttype", String.to_integer(params["documenttype"]))
        params = Map.put(params, "facility", String.to_float(params["facility"]))

        loans = Intergrator.Intergrations.sme_loan_init(conn, params)

        case loans do
            :ok ->
              Ecto.Multi.new()
              |> Ecto.Multi.insert(:loanApplicationsSme, LoanApplicationsSme.changeset(%LoanApplicationsSme{}, params))
              |> Ecto.Multi.run(:user_log, fn _repo, %{loanApplicationsSme: loanApplicationsSme} ->
              activity = "Created new document type with code \"{loanApplicationsSme.id}\""
              user_log = %{
                    user_id: conn.assigns.user.id,
                    activity: activity
              }
              UserLogs.changeset(%UserLogs{}, user_log)
              |> Repo.insert()
            end)

              |> Repo.transaction()
              |> case do
                {:ok, %{loanApplicationsSme: _loanApplicationsSme, user_log: _user_log}} ->
                  conn
                  |> put_flash(:info, "Your application has been submitted successfully.")
                  |> redirect(to: Routes.sme_path(conn, :sme_loan_products))

                {:error, _failed_operation, failed_value, _changes_so_far} ->
                  reason = traverse_errors(failed_value.errors) |> List.first()

                  conn
                  |> put_flash(:error, reason)
                  |> redirect(to: Routes.sme_path(conn, :sme_loan_products))
                end
          [] ->

              conn
              |> put_flash(:error, "There was a problem while processing your loan application. Please try again.")
              |> redirect(to: Routes.sme_path(conn, :sme_loan_products))

          :timeout ->

              conn
                |> put_flash(:error, "There was a problem while processing your loan application. Please try again.")
                |> redirect(to: Routes.sme_path(conn, :sme_loan_products))

          nil ->
              IO.inspect params
              conn
                |> put_flash(:error, "There was a problem while processing your loan application. Please try again.")
                |> redirect(to: Routes.sme_path(conn, :sme_loan_products))

          _->
              IO.inspect params
              conn
                |> put_flash(:error, loans)
                |> redirect(to: Routes.sme_path(conn, :sme_loan_products))


        end
    end

    def repay(conn, _params) do
      render(conn, "repay.html")
    end

    def sme_repayment(conn, params) do
      loans = Intergrator.Intergrations.pbl_payment_inititation(conn, params)

      case loans do
        :ok ->

          conn
            |> put_flash(:info, "Your loan repayment request has been submitted successfully.")
            |> redirect(to: Routes.sme_path(conn, :sme_loan_products))


        [] ->

          conn
          |> put_flash(:error, "There was a problem while processing your loan repayment. Please try again.")
          |> redirect(to: Routes.sme_path(conn, :repay))

        :timeout ->

            conn
            |> put_flash(:error, "There was a problem while processing your loan repayment. Please try again.")
              |> redirect(to: Routes.sme_path(conn, :repay))

        nil ->
            IO.inspect params
            conn
              |> put_flash(:error, "There was a problem while processing your loan repayment. Please try again.")
              |> redirect(to: Routes.sme_path(conn, :repay))

        _->
            IO.inspect params
            conn
              |> put_flash(:error, loans)
              |> redirect(to: Routes.sme_path(conn, :repay))
      end
    end

    def refund_loan(conn, _request) do
      render(conn, "refund_loan.html")
    end

    def sme_refund_request(conn, params) do
      loans = Intergrator.Intergrations.pbl_loan_refund(conn, params)
      IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< REFUND REQUEST<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      IO.inspect loans
      case loans do
        :ok ->
          Ecto.Multi.new()
            |> Ecto.Multi.insert(:loanApplicationsEmployee, LoanApplicationsSme.changeset(%LoanApplicationsSme{}, params))
            |> Ecto.Multi.run(:user_log, fn _repo, %{loanApplicationsEmployee: loanApplicationsEmployee} ->
            activity = "Loan Application Submitted with LoanId #{loanApplicationsEmployee.id} and user ID #{conn.assigns.user.id}"
            user_log = %{
                  user_id: conn.assigns.user.id,
                  activity: activity
            }
            UserLogs.changeset(%UserLogs{}, user_log)
            |> Repo.insert()
            end)

            |> Repo.transaction()
            |> case do
              {:ok, %{loanApplicationsEmployee: _loanApplicationsEmployee, user_log: _user_log}} ->
                conn
                |> put_flash(:info, "Your Loan Refund Request Has Been Submitted Successfully.")
                |> redirect(to: Routes.sme_path(conn, :refund_loan))

              {:error, _failed_operation, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors) |> List.first()

                conn
                |> put_flash(:error, reason)
                |> redirect(to: Routes.sme_path(conn, :refund_loan))
              end
        [] ->

            conn
            |> put_flash(:error, "There was a problem while processing your loan refund request. Please try again.")
            |> redirect(to: Routes.sme_path(conn, :refund_loan))

        :timeout ->

          conn
            |> put_flash(:error, "There was a problem while processing your loan refund request. Please try again.")
            |> redirect(to: Routes.employee_path(conn, :refund_loan))

        _->

          conn
            |> put_flash(:error, loans)
            |> redirect(to: Routes.employee_path(conn, :refund_loan))

        end
    end


    def min_statement(conn, _params) do
      render(conn, "min_statment.html")
    end

    def get_min_statement(conn, params) do
      data = Intergrator.Intergrations.pbl_mini_statement(conn, params)

      IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      IO.inspect data
      json(conn, Poison.encode!(%{resp: data}))
    end

    def historical_statement(conn, _params) do
      render(conn, "historical.html")
    end

    def get_historical_statement(conn, params) do
      data = Intergrator.Intergrations.pbl_loan_statement(conn, params)

      IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      IO.inspect data

      json(conn, Poison.encode!(%{resp: data}))
    end


      def sme360view(conn, _params) do
        render(conn, "sme360view.html",
          off: Repo.all(from m in Company, where: m.isOffTaker == ^true and m.createdByUserId == ^conn.private.plug_session["current_user_role"].companyId),
          doc: Repo.all(from m in Documents, where: m.companyID == ^conn.private.plug_session["current_user_role"].companyId, select: %{id: m.id, name: m.docName, path: m.path}) |> Enum.map(fn map -> %{id: map.id, name: map.name, path: Enum.at(Path.wildcard(map.path), 0) } end) |> Enum.filter(fn %{id: _id, name: _name, path: path} -> path != nil end)
        )
      end


    def sme_loan_trucking(conn, params) do
      render(conn, "loan_tracking.html")
    end

    # LoanSavingsSystemWeb.SmeController.get_sme_loan_trucking
    def get_sme_loan_trucking(conn, params) do
      data = Intergrator.Intergrations.pbl_loan_tracking(conn, params)

      case data do
        :ok ->

          json(conn, Poison.encode!(%{resp: data}))

        [] ->

          json(conn, Poison.encode!(%{resp: data}))

        :timeout ->

          json(conn, Poison.encode!(%{resp: data}))

        nil ->
            IO.inspect params
            json(conn, Poison.encode!(%{resp: data}))

        _->
            IO.inspect params
            json(conn, Poison.encode!(%{resp: data}))
      end



    end



    def get_sme_affordable_amoutn(conn, params) do

      data = Intergrator.Intergrations.pbl_affordable_amount(conn, params)
      IO.inspect data

        IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

      json(conn, Poison.encode!(%{resp: data}))
    end












  def update_permissions(conn, params) do
    case Resource.update_permissions(Repo.all(from m in UserRole, where: m.userId == type(^params["user_id"], :integer) and m.roleType == ^"SME") |> Enum.at(0), params["data"]) do
      {:ok, _resp} -> json(conn, %{status: "SUCCESS"})
      _ -> json(conn, %{status: "FAILED"})
    end
  end

  def get_permissions(conn, request), do: json(conn, %{status: "SUCCESS", permissions: Repo.one(from m in UserRole, where: m.userId == ^request["user_id"] and m.roleType == ^"SME", select: m.permissions) } )

  def company_details(conn, _params), do: render(conn, "company_details.html")

  def off_takers(conn, _params) do
    IO.inspect conn
    render(conn, "off_takers.html", offtaker: Repo.all(from m in Company, where: m.isOffTaker == true and m.status == "ACTIVE"), doc_type: [%{document_type: "NRC"}, %{document_type: "PACRA"}] )
  end

  def register_offtaker(conn, params) do
    if Repo.one(from m in Company, where: m.registrationNumber == ^params["registrationNumber"], select: m.registrationNumber) == nil do
      case Sme.register_offtaker(conn, params) do
        {:ok, resp} -> conn |> put_flash(:info, resp) |> redirect(to: Routes.sme_path(conn, :off_takers))
        {:error, msg} -> conn |> put_flash(:info, msg) |> redirect(to: Routes.sme_path(conn, :off_takers))
      end
    else
      conn |> put_flash(:error, "Offtaker Already Exist") |> redirect(to: Routes.sme_path(conn, :off_takers))
    end
    conn |> put_flash(:info, "Offtaker has been registered successfully") |> redirect(to: Routes.sme_path(conn, :off_takers))
  end

  def add_documents(conn, params) do
    company = Repo.get_by(Company, id: conn.private.plug_session["current_user_role"].companyId)
    case Registration.insert_documents(params, company, conn.assigns.user, params["document"], params["docname"], "Company", company.companyName) do
      {:ok, _num} -> conn |> put_flash(:info, "Document successfully uploaded") |> redirect(to: Routes.sme_path(conn, :company_documents))
      {:error, _msg} -> conn |> put_flash(:error, "Something went wrong while uploading the document.") |> redirect(to: Routes.sme_path(conn, :company_documents))
    end
  end

  def disable_document(conn, %{"id" => id}) do
   case update_document(Repo.get_by(Documents, id: id), %{status: "DISABLED"}) do
    {:ok, _resp} -> conn |> put_flash(:info, "Document has been disabled successfully") |> redirect(to: Routes.sme_path(conn, :company_documents))
    {:error, _msg} -> conn |> put_flash(:error, "Failed to disable document") |> redirect(to: Routes.sme_path(conn, :company_documents))
   end
  end

  def update_document(%Documents{} = document, changes), do: Repo.update(Documents.changeset(document, changes))

  def activate_documents(conn, %{"id" => id}) do
    case activatedocument(Repo.all(from m in Documents, where: m.id  == type(^id, :integer) ) |> Enum.at(0), %{status: "ACTIVE"}) do
      {:ok, _doc} -> conn |> put_flash(:info, "Document has been activated successfully") |> redirect(to: Routes.sme_path(conn, :company_documents))
       {:error, _msg} -> conn |> put_flash(:error, "failed to activate document") |> redirect(to: Routes.sme_path(conn, :company_documents))
    end
  end

  def activatedocument(%Documents{} = document, changes), do: Repo.update(Documents.changeset(document, changes))

  def company_documents( %{private: %{:plug_session => private}} = conn, _params), do: render(conn, "company_documents.html", doc: Repo.all(from m in Documents, where: m.companyID == ^private["current_user_role"].companyId, select: %{id: m.id, status: m.status, name: m.docName, path: m.path}) |> Enum.map(fn map -> %{id: map.id, status: map.status, name: map.name, path: Enum.at(Path.wildcard(map.path), 0) } end) |> Enum.filter(fn %{id: _id, status: _status, name: _name, path: path} -> path != nil end) )

  def offtaker_document(conn, %{"id" => id}), do: render(conn, "offtaker_document.html", id: id, doc: Repo.all(from m in Documents, where: m.companyID == ^id, select: %{id: m.id, name: m.docName, path: m.path}) |> Enum.map(fn map -> %{id: map.id, name: map.name, path: Enum.at(Path.wildcard(map.path), 0) } end) |> Enum.filter(fn %{id: _id, name: _name, path: path} -> path != nil end) |> IO.inspect)

  @spec view_documents(Plug.Conn.t(), map) :: Plug.Conn.t()
  def view_documents(conn, %{"path" => path}), do: render(conn, "view_documents.html", path: path)

  def display_pdf(conn, %{"path" => path}), do: send_file( put_resp_header(conn, "content-type", "application/pdf"), 200, path)

  def edit_company(conn, %{"id" => id}), do: render(conn, "edit_company.html", company: Repo.get_by(Company, id: id))

  def update_company(conn, params) do
    case Sme.update_company(Repo.get_by(Company, id: params["id"]), params) do
      {:ok, _resp} -> conn |> put_flash(:info, "company updated successfully.") |> redirect(to: Routes.sme_path(conn, :company_details))
      {:error, msg} -> conn |> put_flash(:info, msg) |> redirect(to: Routes.sme_path(conn, :edit_company, params["id"]))
    end
  end

  def apply_for_loan(conn, _params) do

    invoice = Intergrator.Intergrations.sme_product_list(1)
    orderfinance = Intergrator.Intergrations.sme_product_list(2)
        IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        IO.inspect invoice

     render(conn, "loan_product.html", invoice: invoice, orderfinance: orderfinance)
  end

  def submit_loan_application(conn, params) do
    user = conn.assigns.user
    multiple = Ecto.Multi.new()
    map = %{currency_code: params["currency_code"], currency_description: params["currency_description"],currency_acronym: params["currency_acronym"],currency_country: params["currency_country"], status: 1}
      multiple
      |> Ecto.Multi.insert(:insert, Loans.changeset(%Loans{}, map))
      |> Repo.transaction()
      |> case do
           {:ok, _trans} ->  json(conn, %{data: "Loan Application Submitted Successful!"})
           {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first
            json(conn, %{error: reason})
        end
  end

  def traverse_errors(errors), do: for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"

  def existance_of_offtaker(conn, %{"regnum" => regnum}) do
    if Repo.one(from m in Company, where: m.registrationNumber == ^regnum, select: m.registrationNumber) == nil do
        json(conn, %{status: "NIL"})
    else
      json(conn, %{status: "EXIST", msg: "OffTaker Already Exist"})
    end
  end


############################################################
def user_management(%{private: %{:plug_session => private}} = conn, _params) do

  IO.inspect " ====================================================="
  IO.inspect private["current_user_role"].companyId
  IO.inspect " ====================================================="
  user =
  User
  |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
  |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
  |> where([uA, uB, uR], uR.roleType == "SME" and uR.companyId == ^private["current_user_role"].companyId)
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
    # physical_address: uB.physical_address,
    # auth_level: uR.auth_level,
    # permissions: uR.permissions
  })
  |> Repo.all()
  |> IO.inspect
  render(conn, "user_management.html", user: user)
end

def disable_user(conn, %{"id" => id}) do
   user = Repo.get_by(User, id: id)
  Ecto.Multi.new()
  |> Ecto.Multi.update(:user, User.changeset(user, %{status: "DISABLED"}))
  |> Ecto.Multi.run(:user_log, fn (_, %{user: user}) ->
    case Repo.insert( UserLogs.changeset(%UserLogs{}, %{user_id: conn.assigns.user.id, activity: "Add user with ID \"#{user.id}\""} ) ) do
      {:ok, resp} -> {:ok, resp}
      {:error, msg} -> {:error, msg}
    end
  end)
  |> Repo.transaction()
  |> case do
    {:ok, %{user: _user, user_log: _user_log}} -> conn |> put_flash(:info, "User Suucessfuly Disabled") |> redirect(to: Routes.sme_path(conn, :user_management))
    {:error, _} -> conn |> put_flash(:error, "failed to disable user") |> redirect(to: Routes.sme_path(conn, :user_management))
  end
end

def activate_user(conn, %{"id" => id}) do
  user = Repo.get_by(User, id: id)
 Ecto.Multi.new()
 |> Ecto.Multi.update(:user, User.changeset(user, %{status: "ACTIVE"}))
 |> Ecto.Multi.run(:user_log, fn (_, %{user: user}) ->
   case Repo.insert( UserLogs.changeset(%UserLogs{}, %{user_id: conn.assigns.user.id, activity: "Add user with ID \"#{user.id}\""} ) ) do
     {:ok, resp} -> {:ok, resp}
     {:error, msg} -> {:error, msg}
   end
 end)
 |> Repo.transaction()
 |> case do
   {:ok, %{user: _user, user_log: _user_log}} -> conn |> put_flash(:info, "User Suucessfuly Activated") |> redirect(to: Routes.sme_path(conn, :user_management))
   {:error, _} -> conn |> put_flash(:error, "failed to activate user") |> redirect(to: Routes.sme_path(conn, :user_management))
 end
end

def update_user(conn, %{"id" => id} = params) do
   bio_data = Repo.get_by(UserBioData, userId: id)
   params = Map.put(params, "permissions", Enum.reduce(params["permissions"], fn x, acc -> x <> "~" <> acc end) )
   Ecto.Multi.new()
   |> Ecto.Multi.update(:bio_data, UserBioData.changeset(bio_data, params) )
   |> Ecto.Multi.run(:user, fn (_, %{bio_data: _bio_data}) ->
      case update_user(Repo.get_by(User, id: params["id"]), %{username: params["emailAddress"]}) do
        {:ok, resp} -> {:ok, resp}
        {:error, msg} -> {:error, msg}
      end
    end)
    |> Ecto.Multi.run(:user_role, fn (_, %{user: _user}) ->
      case update_user_role(Repo.one(from m in UserRole, where: m.userId == ^id and m.roleType == ^"SME", select: m), params) do
        {:ok, resp} -> {:ok, resp}
        {:error, msg} -> {:error, msg}
      end
    end)
    |> Ecto.Multi.run(:user_log, fn (_, %{user: user}) ->
      case Repo.insert( UserLogs.changeset(%UserLogs{}, %{user_id: conn.assigns.user.id, activity: "Updated user with ID \"#{user.id}\""} ) ) do
        {:ok, resp} -> {:ok, resp}
        {:error, msg} -> {:error, msg}
      end
    end)
    |> Repo.transaction()
    |> case do
     {:ok, %{user: _user, user_log: _user_log}} -> conn |> put_flash(:info, "User Suucessfuly has been updated successfull") |> redirect(to: Routes.sme_path(conn, :user_management))
     {:error, _} -> conn |> put_flash(:error, "failed to updated user") |> redirect(to: Routes.sme_path(conn, :user_management))
    end
end

def update_user(%User{} = user, changes), do: Repo.update(User.changeset(user, changes))
def update_user_role(%UserRole{} = user_role, changes), do: Repo.update(UserRole.changeset(user_role, changes))

#####################################################
def add_user(conn, params) do
  password = Resource.random_string(3)
  params = Map.put(params, "permissions", Enum.reduce(params["permissions"], fn x, acc -> x <> "~" <> acc end)) |> Map.put("createdByUserId", conn.assigns.user.id) |> Map.put("companyId", conn.private.plug_session["current_user_role"].companyId) |> Map.put("otp", Integer.to_string(Enum.random(1_000..9_999)) )
  Ecto.Multi.new()
  |> Ecto.Multi.insert(:user, User.changeset(%User{}, %{username: params["emailAddress"], password: password, status: "ACTIVE", auto_password: "Y"}))
  |> Ecto.Multi.run(:boi_data, fn _repo, %{user: user} ->
    case Repo.insert(UserBioData.changeset(%UserBioData{}, Map.put(params, "userId", user.id))) do
      {:ok, _user} ->
        Repo.insert(Emails.changeset(%Emails{}, prepare_emails(Resource.to_atomic_map(params), user, password) ))
        Repo.insert(Sms.changeset(%Sms{}, prepare_sms(Resource.to_atomic_map(params), user, password) ))
        {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end)
  |> Ecto.Multi.run(:role, fn _repo, %{boi_data: _boi_data, user: user} ->
    case Repo.insert(UserRole.changeset(%UserRole{}, %{otp: params["otp"], userId: user.id, roleType: "SME", companyId: conn.private.plug_session["current_user_role"].companyId, status: "ACTIVE"} )) do
      {:ok, role} -> {:ok, role}
      {:error, changeset} -> {:error, changeset}
    end
  end)
  |> Ecto.Multi.run(:user_log, fn (_, %{user: user}) ->
    case Repo.insert( UserLogs.changeset(%UserLogs{}, %{user_id: conn.assigns.user.id, activity: "Add user with ID \"#{user.id}\""} ) ) do
      {:ok, resp} -> {:ok, resp}
      {:error, msg} -> {:error, msg}
    end
end)
  |> Repo.transaction()
  |> case do
    {:ok, %{user: _company, boi_data: _user}} -> conn |> put_flash(:info, "User Suucessfuly added") |> redirect(to: Routes.sme_path(conn, :user_management))
    {:error, _} -> conn |> put_flash(:error, "failed to add user") |> redirect(to: Routes.sme_path(conn, :user_management))
  end
end

def prepare_emails(params, user, password) do
  %{
    email: params.email_address,
    msg: "Dear #{params.first_name} #{params.last_name}, your account has been created username: #{user.username} password: #{password}, opt: #{params["otp"]}",
    msg_count: "0",
    status: "READY",
    type: "SME",
    date_sent: NaiveDateTime.utc_now
  }
end
def prepare_sms(params, user, password) do
  %{
    mobile: params.mobile_number,
    msg: "Dear #{params.first_name} #{params.last_name}, your account has been created username: #{user.username} password: #{password}, otp: #{params["otp"]}",
    msg_count: "0",
    status: "READY",
    type: "SME",
    date_sent: NaiveDateTime.utc_now
  }
end
############################################################
  def change_password(conn, params) do
    user = conn.assigns.user
    if user.password == User.encrypt_password(params["current_password"]) do
      if params["new_password"] == params["confirm_password"] do
        Ecto.Multi.new()
        |> Ecto.Multi.update(:user_password, User.changeset(user, %{password: params["confirm_password"]}))
        |> Ecto.Multi.run(:username, fn (_, %{user_password: _user_password}) ->
          if String.length(Enum.at(params["username"], 0)) == 0 do
            {:ok, " "}
          else
            case update_user(user, %{username: Enum.at(params["username"], 0) }) do
              {:ok, resp} -> {:ok, resp}
              {:error, msg} -> {:error, msg}
            end
          end
        end)
        |> Ecto.Multi.run(:user_log, fn (_, %{user_password: _user_password}) ->
          case Repo.insert( UserLogs.changeset(%UserLogs{}, %{user_id: conn.assigns.user.id, activity: "has changed password or username"} ) ) do
            {:ok, resp} -> {:ok, resp}
            {:error, msg} -> {:error, msg}
          end
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{user_password: _user_password} } -> conn |> configure_session(drop: true) |> redirect(to: Routes.session_path(conn, :username))
          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()
            conn |> put_flash(:error, reason) |> redirect(to: Routes.user_path(conn, :sme_dashboard))
        end
      else
        conn |> put_flash(:error, "new and confirmation password doesn't match") |> redirect(to: Routes.user_path(conn, :sme_dashboard))
      end
    else
      conn |> put_flash(:error, "current and existing password doesn't match.") |> redirect(to: Routes.user_path(conn, :sme_dashboard))
    end
  end
  def update_user(%User{} = user, changes), do: Repo.update(User.changeset(user, changes))

  def sme_user_logs(conn, _params) do
    user_activity = LoanSavingsSystem.Logs.sme_user_logs(conn.private.plug_session["current_user_role"].companyId)
    render(conn, "user_logs.html", user_activity: user_activity)
  end



  def sme_announcements(conn, _params), do: render(conn, "announcement.html", announcements: Repo.all(from m in Announcements, where: m.recipient == ^"SME"))


end
