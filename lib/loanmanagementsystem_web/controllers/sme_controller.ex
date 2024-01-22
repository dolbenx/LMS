defmodule LoanmanagementsystemWeb.SmeController do
  use LoanmanagementsystemWeb, :controller
  use Ecto.Schema
  alias Loanmanagementsystem.Repo
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Logs.UserLogs
  # alias Loanmanagementsystem.Emails.Email
  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Loan.LoanRepayment
  alias Loanmanagementsystem.Loan.Loans
  require Logger

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


  plug LoanmanagementsystemWeb.Plugs.Authenticate,
		       [module_callback: &LoanmanagementsystemWeb.SmeController.authorize_role/1]
		       when action not in [
              :admin_edit_user,
              :admin_register_offtaker,
              :calculate_page_num,
              :calculate_page_size,
              :create_user,
              :display,
              :entries,
              :make_repayment,
              :run,
              :search_options,
              :select_loan,
              :sme_360,
              :sme_activate_company,
              :sme_activate_document,
              :sme_activate_loan,
              :sme_activate_offtaker,
              :sme_activate_user,
              :sme_announcements,
              :sme_apply_for_loans,
              :sme_company_details,
              :sme_company_documents,
              :sme_deactivate_company,
              :sme_deactivate_document,
              :sme_deactivate_loan,
              :sme_deactivate_offtaker,
              :sme_deactivate_user,
              :sme_loan_product,
              :sme_loan_tracking,
              :sme_mini_statement,
              :sme_off_taker,
              :sme_offtaker_lookup,
              :sme_pending_loans,
              :sme_repayment,
              :sme_statement_lookup,
              :sme_update_company,
              :sme_update_offtaker,
              :sme_user_logs,
              :sme_user_management,
              :total_entries,
              :traverse_errors,
		            ]

		  use PipeTo.Override


  def sme_pending_loans(conn, _request), do: render(conn, "pending_loans.html")

  def select_loan(conn, _params),
    do:
      render(conn, "select_loan_product.html",
        products:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "ACTIVE"))
      )

  def sme_apply_for_loans(conn, %{"product_id" => product_id}) do
    product_details = Loanmanagementsystem.Products.otc_product_details_lookup(product_id)
    get_bio_datas = Loanmanagementsystem.Accounts.get_details(conn.assigns.user.id)

    render(conn, "apply_for_loans.html",
      product_details: product_details,
      get_bio_datas: get_bio_datas
    )
  end

  def sme_repayment(conn, _params) do
    IO.inspect("rrrrrrrrrrrrrrrrrrrrrrrrr")

    repayment =
      Loan.get_loan_repayment_schedule(conn.private.plug_session["current_user_role"].userId)

    repayment_scheduled =
      Loan.list_tbl_loan_repayment(conn.private.plug_session["current_user_role"].userId)

    current_user_role = get_session(conn, :current_user_role)
    current_user = get_session(conn, :current_user)

    render(conn, "repayment.html",
      repayment: repayment,
      current_user_role: current_user_role,
      current_user: current_user,
      repayment_scheduled: repayment_scheduled
    )
  end

  def make_repayment(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :repayment,
      LoanRepayment.changeset(%LoanRepayment{}, %{
        id: params["id"],
        repayment: "123",
        dateOfRepayment: params["dateOfRepayment"],
        modeOfRepayment: params["modeOfRepayment"],
        amountRepaid: "1500",
        chequeNo: params["chequeNo"],
        receiptNo: params["receiptNo"],
        registeredByUserId: "3",
        recipientUserRoleId: "12",
        company_id: "3"
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{repayment: _repayment} ->
      UserLogs.changeset(%UserLogs{}, %{
        inerted_at: params["inserted_at"],
        activity: "Repayment made Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      # {:ok, _} ->
      {:ok, %{repayment: _repayment}} ->
        conn
        |> put_flash(:info, "You have Successfully Made A Repayment")
        |> redirect(to: Routes.sme_path(conn, :sme_repayment))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.sme_path(conn, :sme_repayment))
    end
  end

  def sme_loan_tracking(conn, _request), do: render(conn, "loan_tracking.html")

  def sme_360(conn, _params) do
    currentUserRole = get_session(conn, :current_user_role)
    user_details = Loanmanagementsystem.Accounts.get_details(currentUserRole.userId)
    render(conn, "sme360.html", user_details: user_details, currentUserRole: currentUserRole)
  end

  # def sme_update_360_profile(conn, params) do
  #   update_360 = Loanmanagementsystem.Accounts.get_details(params["id"])
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.update(:update_360, UserBioData.changeset(update_360, %{

  #     title: params["title"],
  #     firstName: params["firstName"],
  #     lastName: params["lastName"],
  #     otherName: params["otherName"],
  #     gender: params["gender"],
  #     meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
  #     emailAddress: params["emailAddress"],
  #     mobileNumber: params["mobileNumber"]

  #   }))

  #   |>Ecto.Multi.run(:user_logs, fn _repo, %{update_360: _update_360 }->
  #     UserLogs.changeset(%UserLogs{}, %{
  #       activity: "Updated Profile Successfully",
  #       user_id: conn.assigns.user.id
  #     })|>Repo.insert()

  #   end)

  #   |>Repo.transaction()

  #   |>case  do
  #     {:ok, _msg} ->
  #       conn
  #       |>put_flash(:info, "You have Successfully Updated the Profile")
  #       |>redirect(to: Routes.sme_path(conn, :sme_360))

  #   {:error, _failed_operations , failed_value , _changes_so_far}->
  #      reason = traverse_errors(failed_value.errors)

  #      conn
  #      |>put_flash(:error, reason)
  #      |>redirect(to: Routes.sme_path(conn, :sme_360))
  #   end
  # end

  def sme_off_taker(conn, _prams) do
    current_user_details =
      Loanmanagementsystem.Accounts.current_user_details(conn.assigns.user.id)

    off_taker =
      Loanmanagementsystem.Companies.list_tbl_sme_offtaker(current_user_details.company_id)

    render(conn, "off_taker.html", off_taker: off_taker)
  end

  def sme_activate_offtaker(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_offtaker,
      Company.changeset(
        Loanmanagementsystem.Companies.get_company!(params["id"]),
        Map.merge(params, %{"status" => "ACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_offtaker: _activate_offtaker} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated Offtaker Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Offtaker activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def sme_deactivate_offtaker(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_offtaker,
      Company.changeset(
        Loanmanagementsystem.Companies.get_company!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_offtaker: _activate_offtaker} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated Offtaker Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Offtaker Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_register_offtaker(conn, params) do
    current_user_role = get_session(conn, :current_user_role)
    otp = to_string(Enum.random(1111..9999))

    IO.inspect(params["defaultSwitchRadioExample"])
    # company_type_ = String.split(params["defaultSwitchRadioExample"],"|||");

    params =
      Map.merge(params, %{
        "createdByUserId" => conn.assigns.user.id,
        "createdByUserRoleId" => current_user_role.id,
        "status" => "INACTIVE"
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_company, Company.changeset(%Company{}, params))
    |> Ecto.Multi.run(:add_admin_user, fn _repo, %{add_company: add_company} ->
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y",
        company_id: add_company.id,
        isOfftaker: "true"
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_company: _add_company,
                                           add_admin_user: add_admin_user
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: "OFFTAKER",
        status: "INACTIVE",
        userId: add_admin_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                             %{
                                               add_user_role: _add_user_role,
                                               add_company: _add_company,
                                               add_admin_user: add_admin_user
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
        userId: add_admin_user.id,
        idNo: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_user_role: _add_user_role,
                                       add_company: _add_company,
                                       add_admin_user: _add_admin_user,
                                       add_user_bio_data: _add_user_bio_data
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Added OffTaker Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok,
       %{
         add_user_role: _add_user_role,
         add_company: _add_company,
         add_admin_user: _add_admin_user,
         add_user_bio_data: _add_user_bio_data,
         user_logs: _user_logs
       }} ->
        # Email.send_email(params["emailAddress"], params["password"])

        conn
        |> put_flash(:info, "You Have Successfully added a New OffTaker")
        |> redirect(to: Routes.sme_path(conn, :off_taker))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.sme_path(conn, :off_taker))
    end
  end

  def sme_update_offtaker(conn, params) do
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
        |> redirect(to: Routes.sme_path(conn, :sme_company_details))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.sme_path(conn, :sme_company_details))
    end
  end

  def sme_company_documents(conn, _request) do
    document = Loanmanagementsystem.Companies.list_tbl_company_documents()
    render(conn, "company_documents.html", document: document)
  end

  def sme_activate_document(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_document,
      Loanmanagementsystem.Companies.Documents.changeset(
        Loanmanagementsystem.Companies.get_documents!(params["id"]),
        Map.merge(params, %{"status" => "ACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_document: _activate_document} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated Document Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Document Activated Successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def sme_deactivate_document(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :deactivate_document,
      Loanmanagementsystem.Companies.Documents.changeset(
        Loanmanagementsystem.Companies.get_documents!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{deactivate_document: _deactivate_document} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated Document Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Document Deactivated Successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def sme_company_details(conn, _request) do
    company = Loanmanagementsystem.Companies.list_tbl_company()
    render(conn, "company_details.html", company: company)
  end

  def sme_activate_company(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_company,
      Company.changeset(
        Loanmanagementsystem.Companies.get_company!(params["id"]),
        Map.merge(params, %{"status" => "ACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_company: _activate_company} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated Company Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Company activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def sme_update_company(conn, params) do
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
        |> redirect(to: Routes.sme_path(conn, :sme_company_details))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.sme_path(conn, :sme_company_details))
    end
  end

  def sme_deactivate_company(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_company,
      Company.changeset(
        Loanmanagementsystem.Companies.get_company!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_company: _activate_company} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated Company Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Company deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def sme_user_logs(conn, _params) do
    user_activity =
      Loanmanagementsystem.Logs.list_tbl_user_activity_logs(conn.assigns.user.company_id)

    render(conn, "user_logs.html", user_activity: user_activity)
  end

  def sme_announcements(conn, _request), do: render(conn, "announcements.html")

  def sme_user_management(conn, _params) do
    users = Loanmanagementsystem.Logs.sme_user_management(2)
    render(conn, "user_management.html", users: users)
  end

  def admin_edit_user(conn, params) do
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])
    user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])
    otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_user,
      User.changeset(user, %{
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y"
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

  def sme_activate_user(conn, params) do
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
        activity: "Activated User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "User activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def sme_deactivate_user(conn, params) do
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

  def create_user(conn, params) do
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
        # roleType: params["roleType"],
        status: "INACTIVE",
        roleType: "SME",
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
        activity: "Added New User Successfully",
        user_id: conn.assigns.user.id
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
        |> redirect(to: Routes.sme_path(conn, :sme_user_management))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.sme_path(conn, :sme_user_management))
    end
  end

  def sme_mini_statement(conn, _request), do: render(conn, "mini_statement.html")

  def sme_activate_loan(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_loan,
      Loans.changeset(
        Loanmanagementsystem.Loan.get_loans!(params["id"]),
        Map.merge(params, %{"loan_status" => "ACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_loan: _activate_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated Loan Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Loan activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def sme_deactivate_loan(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :deactivate_loan,
      Loans.changeset(
        Loanmanagementsystem.Loan.get_loans!(params["id"]),
        Map.merge(params, %{"loan_status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{deactivate_loan: _deactivate_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated Loan Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Loan Deactivated Successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def sme_loan_product(conn, _request), do: render(conn, "loan_product.html")

  def run(conn, %{"file" => params}) do
    case Loanmanagementsystem.Services.Uploads.run(%{
           "process_documents" => params,
           "conn" => conn
         }) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Uploaded a New Document")
        |> redirect(to: Routes.sme_path(conn, :sme_company_documents))

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.sme_path(conn, :sme_company_documents))
    end
  end

  def display(conn, %{"content_type" => content_type, "path" => path}),
    do: send_file(put_resp_header(conn, "content-type", content_type), 200, path)

  def sme_statement_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.sme_lookup(search_params, start, length)
    total_entries = total_entries(results)
    entries = entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }

    json(conn, results)
  end

  def sme_offtaker_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Companies.sme_lookup_offtaker(search_params, start, length)
    total_entries = total_entries(results)
    entries = entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }

    json(conn, results)
  end

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

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")

    def authorize_role(conn) do
      case Phoenix.Controller.action_name(conn) do
        act when act in ~w(new create)a -> {:client, :create}
        act when act in ~w(index view)a -> {:client, :view}
        act when act in ~w(update edit)a -> {:client, :edit}
        act when act in ~w(change_status)a -> {:client, :change_status}
        _ -> {:client, :unknown}
      end
    end

end
