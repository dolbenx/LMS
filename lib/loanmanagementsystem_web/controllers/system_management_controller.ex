defmodule LoanmanagementsystemWeb.SystemManagementController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Companies.Department
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Accounts.RoleDescription
  alias Loanmanagementsystem.Maintenance.Maker_checker
  alias Loanmanagementsystem.Repo
  import Ecto.Query, warn: false

  def admin_user_maintenance(conn, _params) do
    render(conn, "admin_user_maintenance.html",
      individual_customer: Loanmanagementsystem.Accounts.get_loan_customer_individual(),
      banks: Loanmanagementsystem.Maintenance.list_tbl_banks()
    )
  end

  def role_maintianence(conn, _params) do
    role = Loanmanagementsystem.Accounts.list_tbl_role_description()
    render(conn, "role_maintainence.html", role: role)
  end

  def add_description(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_description,
      RoleDescription.changeset(%RoleDescription{}, %{
        role_description: params["role_description"],
        role_id: params["role_id"],
        status: "INACTIVE",
        user_Id: conn.assigns.user.id
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_description: _add_description} ->
      UserLogs.changeset(%UserLogs{}, %{
        inerted_at: params["inserted_at"],
        activity: "Added Description Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      # {:ok, _} ->
      {:ok, %{add_description: _add_description}} ->
        conn
        |> put_flash(:info, "You have Successfully Added a Description")
        |> redirect(to: Routes.system_management_path(conn, :role_maintianence))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :role_maintianence))
    end
  end

  def activate_role_description(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_description,
      RoleDescription.changeset(
        Loanmanagementsystem.Accounts.get_role_description!(params["id"]),
        Map.merge(params, %{"status" => "ACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_description: _activate_description} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated Role Description Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Role Description Activated Successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def disable_role_description(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_description,
      RoleDescription.changeset(
        Loanmanagementsystem.Accounts.get_role_description!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_description: _activate_description} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Disabled Role Description Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Role Description Disabled Successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def role_permision_maintianence(conn, _params),
    do: render(conn, "role_permision_maintainence.html")

  def maker_checker_configuration(conn, _params) do
    makechecker = Loanmanagementsystem.Maintenance.list_tbl_maker_checker()
    render(conn, "maker_checker_configuration.html", makechecker: makechecker)
  end

  def configure_maker_checker(conn, params) do
    IO.inspect(params, label: "*********************************")

    module =
      if params["module_code"] == "RMGT" do
        "Relationship Management"
      else
        if params["module_code"] == "CRMGT" do
          "Credit Management"
        else
          if params["module_code"] == "FMGT" do
            "Financial Management"
          else
            if params["module_code"] == "CMGT" do
              "Change Management"
            end
          end
        end
      end

    param = Map.merge(params, %{"module" => module})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :maker_checker_configuration,
      Maker_checker.changeset(%Maker_checker{}, param)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{maker_checker_configuration: _maker_checker_configuration} ->
      UserLogs.changeset(%UserLogs{}, %{
        inerted_at: params["inserted_at"],
        activity: "You have Successfully Added module ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{maker_checker_configuration: _maker_checker_configuration}} ->
        conn
        |> put_flash(:info, "You have Successfully Added module ")
        |> redirect(to: Routes.system_management_path(conn, :maker_checker_configuration))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :maker_checker_configuration))
    end
  end

  def edit_maker_checker(conn, params) do
    update_maker_checker = Loanmanagementsystem.Maintenance.get_maker_checker!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_maker_checker,
      Maker_checker.changeset(update_maker_checker, %{
        maker: params["maker"],
        checker: params["checker"]
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_maker_checker: _update_maker_checker} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated Maker_Checker Configuration Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _msg} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the Maker_Checker Configuration")
        |> redirect(to: Routes.system_management_path(conn, :maker_checker_configuration))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :maker_checker_configuration))
    end
  end

  def audit_trail(conn, _params),
    do:
      render(conn, "audit_trail.html",
        userlogs: Loanmanagementsystem.Logs.list_tbl_user_activity_logs()
      )

  def report_maintianence(conn, _params), do: render(conn, "report_maintainence.html")

  def global_configurations(conn, _params), do: render(conn, "global_configurations.html")

  def account_number_generation(conn, _params) do
    products = Loanmanagementsystem.Products.list_tbl_products()
    branchid = Loanmanagementsystem.Maintenance.list_tbl_branch()
    render(conn, "account_number_generation.html", products: products, branchid: branchid)
  end

  def charge_maintenance(conn, _params) do
    render(conn, "charge_maintenance.html")
  end

  def commission_maintenance(conn, _params) do
    render(conn, "commission_maintenance.html")
  end

  def countries(conn, _params),
    do:
      render(conn, "country.html", countries: Loanmanagementsystem.Maintenance.list_tbl_country())

  def province(conn, _params) do
      render(conn, "province.html")

end

  def district(conn, _params) do
      render(conn, "district.html")
  end

  def admin_add_department(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_department, Department.changeset(%Department{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_department: add_department} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully added #{add_department.name} as Department",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, add_department} ->
        conn
        |> put_flash(:info, "You have Successfully Added #{add_department.name}")
        |> redirect(to: Routes.system_management_path(conn, :admin_department))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :admin_department))
    end
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
