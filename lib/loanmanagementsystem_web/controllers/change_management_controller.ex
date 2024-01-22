defmodule LoanmanagementsystemWeb.ChangeManagementController do
  use LoanmanagementsystemWeb, :controller

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.{Repo, Logs.UserLogs}
  alias Loanmanagementsystem.Maintenance.Company_maintenance
  alias Loanmanagementsystem.Maintenance.Password_maintenance
  alias Loanmanagementsystem.Maintenance.Working_days
  alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Maintenance.Holiday_mgt
  alias Loanmanagementsystem.Alerts.Alert
  alias Loanmanagementsystem.Alerts
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole}
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Companies.Company


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
          :update_working_days,
          :handle_company_bulk_upload,
          :company_bulkupload_view

       ]

use PipeTo.Override

  def employee_maintianance(conn, _params) do
    render(conn, "employee_maintainence.html")
  end

  def company_maintainance(conn, _params) do
    render(conn, "company_maintainance.html",
      currencies: Loanmanagementsystem.Maintenance.list_tbl_currency(),
      countries: Loanmanagementsystem.Maintenance.list_tbl_country(),
      company: Maintenance.company_info()
    )

  end

  def company_bulkupload_view(conn, _params), do: render(conn, "company_bulkupload.html")

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
    |> Ecto.Multi.run(:user_logs, fn _repo, %{password_config: _password_config} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated the Password Configuration Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{password_config: _password_config, user_logs: _user_logs}} ->
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
    |> Ecto.Multi.run(:user_logs, fn _repo, %{holiday_details: _holiday_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Approved holiday Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{holiday_details: _holiday_details, user_logs: _user_logs}} ->
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
    |> Ecto.Multi.run(:user_logs, fn _repo, %{holiday_details: _holiday_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Holiday DISABLED Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{holiday_details: _holiday_details, user_logs: _user_logs}} ->
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
    |> Ecto.Multi.run(:user_logs, fn _repo, %{holiday_details: _holiday_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Holiday updated Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{holiday_details: _holiday_details, user_logs: _user_logs}} ->
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

  def role_maintianence(conn, _params), do: render(conn, "role_maintainence.html")

  def role_permision_maintianence(conn, _params),
    do: render(conn, "role_permision_maintainence.html")

  def maker_checker_configuration(conn, _params),
    do: render(conn, "maker_checker_configuration.html")

  def audit_trail(conn, _params), do: render(conn, "audit_trail.html")
  def report_maintianence(conn, _params), do: render(conn, "report_maintainence.html")
  def global_configurations(conn, _params), do: render(conn, "global_configurations.html")
  def account_number_generation(conn, _params), do: render(conn, "account_number_generation.html")

  def external_service_configuration(conn, _params),
    do: render(conn, "external_service_configuration.html")

  # ------------------------------- Prodcut Management--------------------

  def tax_configuration(conn, _params), do: render(conn, "tax_configuration.html")

  def alert_template_maintainence(conn, _params) do
    alert = Alerts.list_tbl_alert_templete()
    render(conn, "alert_template_maintainence.html", alert: alert)
  end

  def loyal_program_maintainence(conn, _params),
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







  # @headers ~w/ companyName	companyPhone contactEmail taxno	companyRegistrationDate	companyAccountNumber isEmployer	isOfftaker isSme title firstName lastName otherName	gender	idType idNumber	mobileNumber emailAddress marital_status nationality dateOfBirth number_of_dependants roleType accomodation_status year_at_current_address area house_number	street_name	town province  /a
    @headers ~w/ companyName	companyPhone contactEmail taxno	companyRegistrationDate	companyRegistration companyAccountNumber isEmployer	isOfftaker isSme title firstName lastName otherName	gender idType idNumber mobileNumber	emailAddress marital_status	nationality	dateOfBirth	number_of_dependants roleType accomodation_status year_at_current_address area house_number street_name town province /a

    @headers_list ["companyName", "companyPhone", "contactEmail", "┬á taxno",
                    "companyRegistrationDate", "companyRegistration", "companyAccountNumber",
                    "┬á isEmployer", "isOfftaker", "isSme", "title", "firstName", "lastName",
                    "otherName", "gender", "idType", "idNumber", "mobileNumber", "emailAddress",
                    "marital_status", "nationality", "dateOfBirth", "number_of_dependants",
                    "roleType", "accomodation_status", "year_at_current_address", "area",
                    "house_number", "street_name", "town", "province"]

  def handle_company_bulk_upload(conn, params) do
    user = conn.assigns.user
    {key, msg, _invalid} = handle_client_file_upload(user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.offtaker_management_path(conn, :employer_maintenance))
    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.change_management_path(conn, :company_bulkupload_view))
    end
  end

  defp handle_client_file_upload(user, params) do
    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
      user
      |> process_client_bulk_upload(filename, destin_path)
      |> case do
        {:ok, {invalid, _valid}} ->
          {:info, "Clients Uploaded Successful ", invalid}
          # {:info, "#{valid} Successful entrie(s) and #{invalid} invalid entrie(s)", valid}

        {:error, reason} ->
          {:error, reason, 0}
      end
    else
      {:error, reason} ->
        {:error, reason, 0}
    end
  end

  def process_client_bulk_upload(user, filename, path) do
    {:ok, items} = extract_xlsx(path)
    prepare_client_bulk_params(user, filename, items)
    |> Repo.transaction(timeout: :infinity)
    |> case do
      {:ok, multi_records} ->
        {invalid, valid} =
          multi_records
          |> Map.values()
          |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->
            case item do
              %{uploafile_name: _src} -> {invalid, valid + 1}
              %{col_index: _index} -> {invalid + 1, valid}
              _ -> {invalid, valid}
            end
          end)

        {:ok, {invalid, valid}}

      {:error, _, changeset, _} ->
        reason = traverse_errors(changeset.errors) |> Enum.join("\r\n")
        {:error, reason}

      {:error, reason} ->
          {:error, reason}
    end
  end

  defp prepare_client_bulk_params(user, filename, items) do
    IO.inspect(items, label: "check ma items")
    # validate_email = items |> Enum.map(fn records -> if UserBioData.exists?(emailAddress: records.emailAddress) == true do  "EXIST" else "PROCEED" end end)
    # validate_idNumber = items |> Enum.map(fn records -> if UserBioData.exists?(meansOfIdentificationNumber: records.idNumber) == true do "EXIST" else "PROCEED" end end)
    # validate_mobileNumber = items |> Enum.map(fn records -> if UserBioData.exists?(mobileNumber: records.mobileNumber) == true do "EXIST" else "PROCEED" end end)
    # case  Enum.member?(validate_email, "EXIST") do
    #   false ->
    #  case  Enum.member?(validate_idNumber, "EXIST") do
    #   false ->
    #  case  Enum.member?(validate_mobileNumber, "EXIST") do
    #   false ->
      Ecto.Multi.new()
      |> Ecto.Multi.run(:upload_entries, fn _repo, _changes_so_far ->
         user
         |> prepare_client_user_bulk_params(filename, items)
         |> prepare_client_address_detail_bulk_params(user, filename, items)
         |> prepare_client_userbio_bulk_params(user, filename, items)
         |> prepare_client_userrole_bulk_params(user, filename, items)
         |> prepare_Client_company_details_bulk_params(user, filename, items)
        #  |> prepare_client_customer_account_bulk_params(user, filename, items)
        #  |> prepare_client_employee_bulk_params(user, filename, items)
        #  |> prepare_client_employment_details_bulk_params(user, filename, items)
        #  |> prepare_client_nextofkin_bulk_params(user, filename, items)
        #  |> prepare_client_Personal_Bank_Details_bulk_params(user, filename, items)

         |> prepare_client_logs_bulk_params(user, filename, items)
         |> prepare_update_user_company_id_params_bulk_params(user, filename, items)
          |> case do
            nil ->
              {:ok, "UPLOAD COMPLETE"}

            error ->
              error
          end
      end)
      # true ->
      #   {:error, "emailAddress already exists!"}
      #   Ecto.Multi.new()
      # end
      # true ->
      #   {:error, "emailAddress already exists!"}
      #   Ecto.Multi.new()
      # end
      # true ->
      # {:error, "emailAddress already exists!"}
      # Ecto.Multi.new()

      # end
  end



  defp prepare_client_userbio_bulk_params(user_bio_resp, _user, _ , _) when not is_nil(user_bio_resp), do: user_bio_resp
  defp prepare_client_userbio_bulk_params(_user_bio_resp, user, _filename, items) do
      items
      |> Stream.with_index(1)
      |> Enum.map(fn {item, index} ->

        userbiodata_params = prepare_userbio_data_params(item, user)
        changeset_bio = UserBioData.changeset(%UserBioData{}, userbiodata_params)
        Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_bio)
      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
  end

  defp prepare_client_address_detail_bulk_params(address_resp, _user, _, _) when not is_nil(address_resp), do: address_resp
  defp prepare_client_address_detail_bulk_params(_address_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      address_details_params = prepare_address_details_params(item, user)
      changeset_address = Address_Details.changeset(%Address_Details{}, address_details_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_address)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp prepare_client_userrole_bulk_params(role_resp, _user, _, _) when not is_nil(role_resp), do: role_resp
  defp prepare_client_userrole_bulk_params(_role_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      otp = to_string(Enum.random(1111..9999))
      userrole_params = prepare_userrole_params(item, user, otp)
      changeset_role = UserRole.changeset(%UserRole{}, userrole_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_role)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp prepare_client_user_bulk_params(user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      otp = to_string(Enum.random(1111..9999))
      user_params = prepare_user_params(item, user, otp)
      changeset_user = User.changeset(%User{}, user_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_user)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end


  # defp prepare_client_employee_bulk_params(emplo_resp, _user, _, _) when not is_nil(emplo_resp), do: emplo_resp
  # defp prepare_client_employee_bulk_params(_emplo_resp, user, _filename, items) do
  #   items
  #   |> Stream.with_index(1)
  #   |> Enum.map(fn {item, index} ->
  #     employee_params = prepare_employee_params(item, user)
  #     changeset_employee = Employee.changeset(%Employee{}, employee_params)
  #     Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_employee)

  #   end)
  #   |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
  #   |> execute_multi()
  # end

  # defp prepare_client_employment_details_bulk_params(emplo_details_resp, _user, _, _) when not is_nil(emplo_details_resp), do: emplo_details_resp
  # defp prepare_client_employment_details_bulk_params(_emplo_details_resp, user, _filename, items) do
  #   items
  #   |> Stream.with_index(1)
  #   |> Enum.map(fn {item, index} ->
  #     maintenance_params = prepare_employment_details_params(item, user)
  #     maintenance_employee = Employment_Details.changeset(%Employment_Details{}, maintenance_params)
  #     Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)

  #   end)
  #   |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
  #   |> execute_multi()
  # end


  # defp prepare_client_nextofkin_bulk_params(nextofkin_resp, _user, _, _) when not is_nil(nextofkin_resp), do: nextofkin_resp
  # defp prepare_client_nextofkin_bulk_params(_nextofkin_resp, user, _filename, items) do
  #   items
  #   |> Stream.with_index(1)
  #   |> Enum.map(fn {item, index} ->
  #     maintenance_params = prepare_client_nextofkin_params(item, user)
  #     maintenance_employee = Nextofkin.changeset(%Nextofkin{}, maintenance_params)
  #     Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)

  #   end)
  #   |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
  #   |> execute_multi()
  # end

  defp prepare_Client_company_details_bulk_params(client_comp_resp, _user, _, _) when not is_nil(client_comp_resp), do: client_comp_resp
  defp prepare_Client_company_details_bulk_params(_client_comp_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      maintenance_params = prepare_Client_company_details_params(item, user)
      maintenance_employee = Company.changeset(%Company{}, maintenance_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  # defp prepare_client_Personal_Bank_Details_bulk_params(bank_details_resp, _user, _, _) when not is_nil(bank_details_resp), do: bank_details_resp
  # defp prepare_client_Personal_Bank_Details_bulk_params(_bank_details_resp, user, _filename, items) do
  #   items
  #   |> Stream.with_index(1)
  #   |> Enum.map(fn {item, index} ->
  #     maintenance_params = prepare_Personal_Bank_Details_params(item, user)
  #     maintenance_employee = Personal_Bank_Details.changeset(%Personal_Bank_Details{}, maintenance_params)
  #     Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)
  #   end)
  #   |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
  #   |> execute_multi()
  # end

  defp prepare_client_logs_bulk_params(logs_resp, _user, _, _) when not is_nil(logs_resp), do: logs_resp
  defp prepare_client_logs_bulk_params(_logs_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      user_logs_params = prepare_client_user_logs_params(item, user)
      changeset_userlogs = UserLogs.changeset(%UserLogs{}, user_logs_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_userlogs)


    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp prepare_userbio_data_params(item, _user) do
    %{
      dateOfBirth: item.dateOfBirth,
      emailAddress: item.emailAddress,
      firstName: item.firstName,
      gender: item.gender,
      lastName: item.lastName,
      meansOfIdentificationNumber: item.idNumber,
      meansOfIdentificationType: item.idType,
      mobileNumber: item.mobileNumber,
      otherName: item.otherName,
      title: item.title,
      userId: User.find_by(username: item.emailAddress).id,
      marital_status: item.marital_status,
      nationality: item.nationality,
      number_of_dependants: if  item.number_of_dependants == "" do 0 else String.to_integer(item.number_of_dependants) end,
      # age: item.age,
    }
  end

  defp prepare_address_details_params(item, _user) do
    IO.inspect item.firstName, label: "item., ---#{item.mobileNumber}---------------------"
    %{
      accomodation_status: item.accomodation_status,
      year_at_current_address: if item.year_at_current_address == "" do 0 else String.to_integer(item.year_at_current_address) end,
      area: item.area,
      house_number: item.house_number,
      street_name: item.street_name,
      town: item.town,
      userId: User.find_by(username: item.emailAddress).id,
      province: item.province,
    }
  end

  defp prepare_userrole_params(item, _user, otp) do
      %{
        roleType: String.upcase(item.roleType),
        status: "INACTIVE",
        userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
        otp: otp,
        isStaff: false,
        client_type: String.upcase(item.roleType),
      }
  end

  defp prepare_user_params(item, _user, otp) do
    # mou = if  String.upcase(item.with_mou) == "YES" do true else false end
    %{
      password: "Password123",
      status: "ACTIVE",
      username: item.emailAddress,
      pin: otp,
      #company_id: if item.companyName == "" do nil else Company.find_by(companyName: item.companyName).id end,
      auto_password: "Y",
      # with_mou: mou
    }
  end



  # defp prepare_employee_params(item, _user) do
  #   %{
  #     status: "INACTIVE",
  #     userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
  #     userRoleId: UserRole.find_by(userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId).id,
  #     loan_limit: Decimal.new(item.loan_limit),
  #     # companyId: if item.companyName == "" do nil else Company.find_by(companyName: item.companyName).id end,
  #     # employerId: if item.companyName == "" do nil else Company.find_by(companyName: item.companyName).id end,
  #   }
  # end

  # defp prepare_employment_details_params(item, _user) do
  #   %{
  #     area: item.area,
  #     # date_of_joining: item.date_of_joining,
  #     employee_number: item.mobileNumber,
  #     employement_type: item.employement_type,
  #     employer: String.upcase(item.companyName),
  #     employer_industry_type: item.employer_industry_type,
  #     employer_office_building_name: item.employer_office_building_name,
  #     employer_officer_street_name: item.employer_officer_street_name,
  #     hr_supervisor_email: item.hr_supervisor_email,
  #     hr_supervisor_mobile_number: item.hr_supervisor_mobile_number,
  #     hr_supervisor_name: item.hr_supervisor_name,
  #     # job_title: item.job_title,
  #     occupation: item.occupation,
  #     province: item.province,
  #     town: item.town,
  #     userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
  #   }
  # end

  # defp prepare_client_nextofkin_params(item, _user) do
  #   %{
  #     applicant_nrc: item.idNumber,
  #     kin_ID_number: item.kin_ID_number,
  #     kin_first_name: item.kin_first_name,
  #     kin_gender: item.kin_gender,
  #     kin_last_name: item.kin_last_name,
  #     kin_mobile_number: item.kin_mobile_number,
  #     kin_other_name: item.kin_other_name,
  #     kin_personal_email: item.kin_personal_email,
  #     kin_relationship: item.kin_relationship,
  #     kin_status: "ACTIVE",
  #     userID: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
  #   }
  # end

  defp prepare_Client_company_details_params(item, _user) do
    get_user_bio = Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber)

    %{

      companyName: item.companyName,
      companyPhone: item.companyPhone,
      registrationNumber: item.companyRegistration,
      companyRegistrationDate: Date.from_iso8601!(item.companyRegistrationDate),
      status: "ACTIVE",
      createdByUserId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
      createdByUserRoleId: UserRole.find_by(userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId).id,
      taxno: item.taxno,
      contactEmail: item.contactEmail,
      companyAccountNumber: item.companyAccountNumber,
      user_bio_id: get_user_bio.id,
      isEmployer: true
    }
  end

  # defp prepare_Personal_Bank_Details_params(item, _user) do
  #   %{
  #     accountName: item.accountName,
  #     accountNumber: item.accountNumber,
  #     bankName: item.bankName,
  #     branchName: item.branchName,
  #     mobile_number: item.mobileNumber,
  #     userId: Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId,
  #   }
  # end

  defp prepare_client_user_logs_params(item, user) do

    %{
      activity: "You have Successfully Added #{item.firstName} #{item.lastName} has a client",
      user_id: user.id
    }
  end

  # ---------------------- file persistence --------------------------------------

  def process_csv(file) do
    case File.exists?(file) do
      true ->
        data =
          File.stream!(file)
          |> CSV.decode!(separator: ?,, headers: true)
          |> Enum.map(& &1)

        {:ok, data}

      false ->
        {:error, "File does not exist"}
    end
  end

  # ---------------------- file persistence --------------------------------------
def is_valide_file(%{"uploafile_name" => params}) do
  if upload = params do
    case Path.extname(upload.filename) do
      ext when ext in ~w(.xlsx .XLSX .xls .XLS .csv .CSV) ->
        with {:ok, destin_path} <- persist(upload) do
          case ext not in ~w(.csv .CSV) do
            true ->
              case Xlsxir.multi_extract(destin_path, 0, false, extract_to: :memory) do
                {:ok, table_id} ->
                  row_count = Xlsxir.get_info(table_id, :rows)
                  first_row = Xlsxir.get_row(table_id, 1)

                  case @headers_list == first_row do
                    true ->
                            Xlsxir.close(table_id)
                            {:ok, upload.filename, destin_path, row_count - 1}

                            {:error, reason} ->
                              {:error, reason}
                    false ->

                      {:error, "Headers do not match. Please ensure the selected file is a Corparate bulk file."}
                  end
              end

            _ ->
              {:ok, upload.filename, destin_path, "N(count)"}
          end
        else
          {:error, reason} ->
            {:error, reason}
        end

      _ ->
        {:error, "Invalid File Format"}
    end
  else
    {:error, "No File Uploaded"}
  end
end

  def extract_xlsx(path) do
    case Xlsxir.multi_extract(path, 0, false, extract_to: :memory) do
      {:ok, id} ->
        items =
          Xlsxir.get_list(id)
          |> Enum.reject(&Enum.empty?/1)
          |> Enum.reject(&Enum.all?(&1, fn item -> is_nil(item) end))
          |> List.delete_at(0)
          |> Enum.map(
            &Enum.zip(
              Enum.map(@headers, fn h -> h end),
              Enum.map(&1, fn v -> strgfy_term(v) end)
            )
          )
          |> Enum.map(&Enum.into(&1, %{}))
          |> Enum.reject(&(Enum.join(Map.values(&1)) == ""))

        Xlsxir.close(id)
        {:ok, items}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp execute_multi(multi) do
    multi
    |> Repo.transaction()
    |> case do
      {:ok, _result} ->
        nil
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        IO.inspect(failed_value)
        {:error, failed_value}
    end
  end


  def persist(%Plug.Upload{filename: filename, path: path}) do
    destin_path = "C:/clientonboarding/file" |> default_dir()
    destin_path = Path.join(destin_path, filename)

    {_key, _resp} =
      with true <- File.exists?(destin_path) do
        {:error, "File with the same name aready exists"}
      else
        false ->
          File.cp(path, destin_path)
          {:ok, destin_path}
      end
  end

  def default_dir(path) do
    File.mkdir_p(path)
    path
  end

  defp strgfy_term(term) when is_tuple(term), do: term
  defp strgfy_term(term) when not is_tuple(term), do: String.trim("#{term}")

# LoanmanagementsystemWeb.ChangeManagementController.update_user_company_id(147, 47)
  def update_user_company_id(user_id, company_id) do

    # user_id = Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId
    # company_id = Loanmanagementsystem.Companies.Company.find_by(registrationNumber: item.companyRegistration).id
    user = Loanmanagementsystem.Accounts.get_user!(user_id)
    Loanmanagementsystem.Accounts.update_user(user, %{company_id: company_id})

  end

  defp prepare_update_user_company_id_params_bulk_params(user_company_id_resp, _user, _, _) when not is_nil(user_company_id_resp), do: user_company_id_resp
  defp prepare_update_user_company_id_params_bulk_params(_user_company_id_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      user_company_id_params = update_user_company_id_params(item, user)
      user = Loanmanagementsystem.Accounts.get_user!(user_company_id_params.get_user_bio)
      changeset_user_company_id = User.changeset(user, user_company_id_params)
      Ecto.Multi.update(Ecto.Multi.new(), Integer.to_string(index), changeset_user_company_id)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp update_user_company_id_params(item, _user) do
    get_user_bio = Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: item.mobileNumber).userId
    user_company_id = Loanmanagementsystem.Companies.Company.find_by(registrationNumber: item.companyRegistration).id

    %{

      company_id: user_company_id,
      get_user_bio: get_user_bio
    }
  end


  # defp prepare_user_params(item, _user, otp) do
  #   # mou = if  String.upcase(item.with_mou) == "YES" do true else false end
  #   %{
  #     password: "Password123",
  #     status: "INACTIVE",
  #     username: item.mobileNumber,
  #     pin: otp,
  #     #company_id: if item.companyName == "" do nil else Company.find_by(companyName: item.companyName).id end,
  #     auto_password: "Y",
  #     # with_mou: mou
  #   }
  # end


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
