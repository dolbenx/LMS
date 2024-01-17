defmodule LoanmanagementsystemWeb.SystemManagementController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Companies.Department
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Accounts.RoleDescription
  alias Loanmanagementsystem.Maintenance.Maker_checker
  alias Loanmanagementsystem.Maintenance.{Currency, Country, Province, District}
  alias Loanmanagementsystem.Charges.Charge
  alias Loanmanagementsystem.Repo
  import Ecto.Query, warn: false


  #################################################################################################################################
  #################################################################################################################################

  def charge_maintenance(conn, _params) do
    currencies = Loanmanagementsystem.Maintenance.list_tbl_currency()
    charges = Loanmanagementsystem.Charges.list_tbl_charges()
    render(conn, "charge_maintenance.html", currencies: currencies, charges: charges)
  end

  def add_charge(conn, params) do

    IO.inspect(params["currency"])
    currency_ = String.split(params["currency"], "|||")

    params = Map.merge(params, %{
              "currency" => Enum.at(currency_, 1),
              "currencyId" => Enum.at(currency_, 0)
            })
    chargeChangeSet = Charge.changeset(%Charge{}, params)
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:charges, chargeChangeSet)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{charges: charges} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Created new Charge with ID \"#{charges.id}\"",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Charge Created successfully.")
        |> redirect(to: Routes.system_management_path(conn, :charge_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :charge_maintenance))
    end
  end

  def update_charge(conn, params) do
    charges = Loanmanagementsystem.Charges.get_charge!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:charges, Charge.changeset(charges, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{charges: charges} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "updated  Charges with ID \"#{charges.id}\"",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{charges: _charges, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Charge updated successfully")
        |> redirect(to: Routes.system_management_path(conn, :charge_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :charge_maintenance))
    end
  end

  def sms_configs(conn, _params) do
    render(conn, "sms_configs.html")
  end


  def countries(conn, _params) do
    countries = Loanmanagementsystem.Maintenance.list_tbl_country()
    render(conn, "country.html", countries: countries)
  end

  def admin_create_country(conn, params) do
    IO.inspect(params, label: "ffffffffffffffffffffffffffffffffff")

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_country, Country.changeset(%Country{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_country: _add_country} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Admin with id #{conn.assigns.user.id} Added A Country Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_country: _add_country, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "You Have Successfully added a Country")
        |> redirect(to: Routes.system_management_path(conn, :countries))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :countries))
    end
  end

  def province(conn, _params) do
    provinces = Loanmanagementsystem.Maintenance.list_tbl_province()
    countries = Loanmanagementsystem.Maintenance.list_tbl_country()
    render(conn, "province.html", countries: countries, provinces: provinces)
  end

  def admin_create_province(conn, params) do
    province_ = String.split(params["country"], "|||")

    params =
      Map.merge(params, %{
        "countryId" => Enum.at(province_, 0),
        "countryName" => Enum.at(province_, 1)
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_province, Province.changeset(%Province{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_province: _add_province} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Admin with id #{conn.assigns.user.id} Added Province Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_province: _add_province, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "You Have Successfully added a Province")
        |> redirect(to: Routes.system_management_path(conn, :province))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :province))
    end
  end

  def district(conn, _params) do
    districts = Loanmanagementsystem.Maintenance.list_tbl_district()
    provinces = Loanmanagementsystem.Maintenance.list_tbl_province()
    countries = Loanmanagementsystem.Maintenance.list_tbl_country()
    render(conn, "district.html", districts: districts, provinces: provinces, countries: countries)
  end

  def admin_create_district(conn, params) do
    province_ = String.split(params["province"], "|||")

    params =
      Map.merge(params, %{
        "provinceId" => Enum.at(province_, 0),
        "provinceName" => Enum.at(province_, 1)
      })

    country_ = String.split(params["country"], "|||")

    params =
      Map.merge(params, %{
        "countryId" => Enum.at(country_, 0),
        "countryName" => Enum.at(country_, 1)
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_district,
      District.changeset(%District{}, %{
        countryId: params["countryId"],
        countryName: params["countryName"],
        name: params["name"],
        provinceId: params["provinceId"],
        provinceName: params["provinceName"]
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_district: _add_district} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Added District Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_district: _add_district, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "You Have Successfully added a District")
        |> redirect(to: Routes.system_management_path(conn, :district))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :district))
    end
  end

  def currency_maintenance(conn, _params) do
    render(conn, "currency_maintenance.html")
  end

  def admin_create_currency(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_currency, Currency.changeset(%Currency{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_currency: _add_currency} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Add Currency Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_currency: _add_currency, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "You Have Successfully added a currency")
        |> redirect(to: Routes.system_management_path(conn, :currency))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :currency))
    end
  end



  #################################################################################################################################
  #################################################################################################################################


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

  def audit_trail(conn, _params) do
    userlogs = Loanmanagementsystem.Logs.list_tbl_user_activity_logs()
    render(conn, "audit_trail.html", userlogs: userlogs)
  end


  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
