defmodule LoanmanagementsystemWeb.ChangeManagementController do
  use LoanmanagementsystemWeb, :controller

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.{Repo, Logs.UserLogs}
  alias Loanmanagementsystem.Maintenance.{Company_maintenance, Alert_Maintenance}
  alias Loanmanagementsystem.Maintenance.Password_maintenance
  alias Loanmanagementsystem.Maintenance.Working_days
  alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Maintenance.Holiday_mgt
  alias Loanmanagementsystem.Alerts.Alert
  alias Loanmanagementsystem.Alerts
  alias Loanmanagementsystem.Companies


  plug LoanmanagementsystemWeb.Plugs.Authenticate,
      [module_callback: &LoanmanagementsystemWeb.ChangeManagementController.authorize_role/1]
      when action not in [
          :account_number_generation,
          :admin_add_templete,
          :alert_template_maintainence,
          :approve_holiday,
          :audit_trail,
          :company_maintainance,
          :create_company_info,
          :create_holiday,
          :create_password_configuration,
          :create_working_days,
          :delete_holiday,
          :employee_maintianance,
          :external_service_configuration,
          :global_configurations,
          :loyal_program_maintainence,
          :maker_checker_configuration,
          :parse_image,
          :report_maintianence,
          :role_maintianence,
          :role_permision_maintianence,
          :tax_configuration,
          :traverse_errors,
          :update_holiday,
          :update_password_configuration,
          :update_working_days,#
          :admin_edit_alert_templete

       ]

use PipeTo.Override

  def employee_maintianance(conn, _params) do
    render(conn, "employee_maintainence.html")
  end

  def company_maintainance(conn, _params) do
    render(conn, "company_maintainance.html",
      currencies: Loanmanagementsystem.Maintenance.list_tbl_currency(),
      countries: Loanmanagementsystem.Maintenance.list_tbl_country(),
      company: Companies.list_tbl_company()
    )

  end

  def create_company_info(conn, params) do
    company = (params["id"] != "" && Maintenance.company_info()) || %Company_maintenance{}
    image = params["company_logo_img"]

    validate_img =
      if Loanmanagementsystem.Maintenance.Company_maintenance.all() == [] do
        ""
      else
        Loanmanagementsystem.Maintenance.Company_maintenance.first().company_logo
      end

    encode_img =
      if image != nil do
        parse_image(image.path)
      else
        validate_img
      end

    param = Map.merge(params, %{"company_logo" => encode_img})

    Ecto.Multi.new()
    |> Ecto.Multi.insert_or_update(:company, Company_maintenance.changeset(company, param))
    |> Ecto.Multi.run(:user_log, fn _, %{company: _company} ->
      activity = "Created/Updated company information"

      UserLogs.changeset(%UserLogs{}, %{
        user_id: conn.assigns.user.id,
        activity: activity
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{company: _company, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Operation successful!")
        |> redirect(to: Routes.change_management_path(conn, :company_maintainance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> Enum.join("\r\n")

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.change_management_path(conn, :company_maintainance))
    end
  end

  def parse_image(path) do
    path
    |> File.read!()
    |> Base.encode64()
  end

  def create_password_configuration(conn, params) do
    with(
      pwd_details when pwd_details == [] <-
        Loanmanagementsystem.Maintenance.Password_maintenance.all()
    ) do
      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :add_country,
        Password_maintenance.changeset(%Password_maintenance{}, params)
      )
      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_country: _add_country} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Created Password Configuration",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_country: _add_country, user_logs: _user_logs}} ->
          conn
          |> put_flash(:info, "Created Password Configuration Successfully")
          |> redirect(to: Routes.organization_management_path(conn, :password_maintianance))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = UserController.traverse_errors(failed_value.errors) |> Enum.join("\r\n")

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.organization_management_path(conn, :password_maintianance))
      end
    else
      _ ->
        conn
        |> put_flash(
          :error,
          "You can not create another password configuration, update existing. "
        )
        |> redirect(to: Routes.organization_management_path(conn, :password_maintianance))
    end
  end

  def update_password_configuration(conn, params) do
    password_config = Loanmanagementsystem.Maintenance.get_password_maintenance!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :password_config,
      Password_maintenance.changeset(password_config, params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{password_config: password_config} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated the Password Configuration Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{password_config: password_config, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Updated the Password Configuration Successfully!")
        |> redirect(to: Routes.organization_management_path(conn, :password_maintianance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> Enum.join("\r\n")

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :password_maintianance))
    end
  end

  def create_working_days(conn, params) do
    with(
      days_details when days_details == [] <-
        Loanmanagementsystem.Maintenance.Password_maintenance.all()
    ) do
      workingdays =
        (params["id"] != "" && Maintenance.workingdays_maintenance_info()) || %Working_days{}

      Ecto.Multi.new()
      |> Ecto.Multi.insert_or_update(:workingdays, Working_days.changeset(workingdays, params))
      |> Ecto.Multi.run(:user_log, fn _, %{workingdays: _workingdays} ->
        activity = "Created/Updated working days information"

        UserLogs.changeset(%UserLogs{}, %{
          user_id: conn.assigns.user.id,
          activity: activity
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{workingdays: _workingdays, user_log: _user_log}} ->
          conn
          |> put_flash(:info, "Operation successful!")
          |> redirect(to: Routes.organization_management_path(conn, :working_day_maintianance))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = UserController.traverse_errors(failed_value.errors) |> Enum.join("\r\n")

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.organization_management_path(conn, :working_day_maintianance))
      end
    else
      _ ->
        conn
        |> put_flash(:error, "You can not create working days, update existing.")
        |> redirect(to: Routes.organization_management_path(conn, :working_day_maintianance))
    end
  end

  def update_working_days(conn, params) do
    workingdays = Loanmanagementsystem.Maintenance.get_working_days!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:workingdays, Working_days.changeset(workingdays, params))
    |> Ecto.Multi.run(:user_log, fn _, %{workingdays: _workingdays} ->
      activity = "Updated working days information "

      UserLogs.changeset(%UserLogs{}, %{
        user_id: conn.assigns.user.id,
        activity: activity
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{workingdays: _workingdays, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Operation successful!")
        |> redirect(to: Routes.organization_management_path(conn, :working_day_maintianance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> Enum.join("\r\n")

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :working_day_maintianance))
    end
  end

  def create_holiday(conn, params) do
    IO.inspect(params, label: "hjsbjshbdjhbdjhdbjds")

    # date = String.split(params["holiday_date"], "-")

    month =
      params["holiday_date"] |> String.slice(5..6) |> String.to_integer() |> Timex.month_name()

    year = params["holiday_date"] |> String.slice(0..3)

    params = Map.merge(params, %{"month" => month, "year" => year})

    param = Map.merge(params, %{"status" => "PENDING_APPROVAL"})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:holiday_maintianance, Holiday_mgt.changeset(%Holiday_mgt{}, param))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{holiday_maintianance: _add_country} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Created holiday Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{holiday_maintianance: _holiday_maintianance, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Created holiday Successfully")
        |> redirect(to: Routes.organization_management_path(conn, :holiday_maintianance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> Enum.join("\r\n")

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :holiday_maintianance))
    end
  end

  def approve_holiday(conn, params) do
    holiday_details = Loanmanagementsystem.Maintenance.get_holiday_mgt!(params["id"])
    param = Map.merge(params, %{"status" => "APPROVED"})

    Ecto.Multi.new()
    |> Ecto.Multi.update(:holiday_details, Holiday_mgt.changeset(holiday_details, param))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{holiday_details: holiday_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Approved holiday Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{holiday_details: holiday_details, user_logs: _user_logs}} ->
        json(conn, %{data: "Approved holiday Successfully !"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def delete_holiday(conn, params) do
    holiday_details = Loanmanagementsystem.Maintenance.get_holiday_mgt!(params["id"])
    param = Map.merge(params, %{"status" => "DISABLED"})

    Ecto.Multi.new()
    |> Ecto.Multi.update(:holiday_details, Holiday_mgt.changeset(holiday_details, param))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{holiday_details: holiday_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Holiday DISABLED Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{holiday_details: holiday_details, user_logs: _user_logs}} ->
        json(conn, %{data: "Holiday deleted Successfully !"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def update_holiday(conn, params) do
    holiday_details = Loanmanagementsystem.Maintenance.get_holiday_mgt!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:holiday_details, Holiday_mgt.changeset(holiday_details, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{holiday_details: holiday_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Holiday updated Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{holiday_details: holiday_details, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Holiday updated Successfully ")
        |> redirect(to: Routes.organization_management_path(conn, :holiday_maintianance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> Enum.join("\r\n")

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :holiday_maintianance))
    end
  end

  # --------------------System Management-------------------

  def role_maintianence(conn, params), do: render(conn, "role_maintainence.html")

  def role_permision_maintianence(conn, params),
    do: render(conn, "role_permision_maintainence.html")

  def maker_checker_configuration(conn, params),
    do: render(conn, "maker_checker_configuration.html")

  def audit_trail(conn, params), do: render(conn, "audit_trail.html")
  def report_maintianence(conn, params), do: render(conn, "report_maintainence.html")
  def global_configurations(conn, params), do: render(conn, "global_configurations.html")
  def account_number_generation(conn, params), do: render(conn, "account_number_generation.html")

  def external_service_configuration(conn, params),
    do: render(conn, "external_service_configuration.html")

  # ------------------------------- Prodcut Management--------------------

  def tax_configuration(conn, params), do: render(conn, "tax_configuration.html")

  def alert_template_maintainence(conn, params) do
    alert = Alerts.list_tbl_alert_templete()
    render(conn, "alert_template_maintainence.html", alert: alert)
  end

  def loyal_program_maintainence(conn, params),
    do: render(conn, "loyal_program_maintainence.html")

  def admin_add_templete(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:alert, Alert.changeset(%Alert{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{alert: alert} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Admin User with ID #{conn.assigns.user.id} Add A Templete With ID #{alert.id}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{alert: _alert, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "You Have Successfully added a template")
        |> redirect(to: Routes.change_management_path(conn, :alert_template_maintainence))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.change_management_path(conn, :alert_template_maintainence))
    end
  end

  def admin_edit_alert_templete(conn, params) do

    update_alert_template = Loanmanagementsystem.Maintenance.get_alert__maintenance!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_alert_template,
    Alert_Maintenance.changeset(update_alert_template, %{
        alert_type: params["alert_type"],
        message: params["alert_message"]
      }))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_alert_template: update_alert_template} ->
      UserLogs.changeset(%UserLogs{}, %{
        inerted_at: params["inserted_at"],
        activity: "Successfully Updated MessaAlertge With ID #{update_alert_template.id}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      # {:ok, _} ->
      {:ok, %{update_alert_template: update_alert_template}} ->
        conn
        |> put_flash(:info, "Successfully Updated MessaAlertge With ID #{update_alert_template.id}")
        |> redirect(to: Routes.change_management_path(conn, :alert_template_maintainence))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.change_management_path(conn, :alert_template_maintainence))
    end
  end


  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:change_mgt, :create}
      act when act in ~w(index view)a -> {:change_mgt, :view}
      act when act in ~w(update edit)a -> {:change_mgt, :edit}
      act when act in ~w(change_status)a -> {:change_mgt, :change_status}
      _ -> {:change_mgt, :unknown}
    end
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
