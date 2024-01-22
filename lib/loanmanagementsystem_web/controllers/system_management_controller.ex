defmodule LoanmanagementsystemWeb.SystemManagementController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Companies.Department
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Accounts.RoleDescription
  alias Loanmanagementsystem.Maintenance.Maker_checker
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Companies.Department
  alias Loanmanagementsystem.Charges.Charge
  alias Loanmanagementsystem.Maintenance.Country
  alias Loanmanagementsystem.Accounts
  import Ecto.Query, warn: false

  plug LoanmanagementsystemWeb.Plugs.Authenticate,
        [module_callback: &LoanmanagementsystemWeb.SystemManagementController.authorize_role/1]
        when action not in [
          :account_number_generation,
          :activate_role_description,
          :add_charge,
          :add_description,
          :admin_add_department,
          :admin_user_maintenance,
          :audit_trail,
          :change_status,
          :charge_maintenance,
          :commission_maintenance,
          :configure_maker_checker,
          :countries,
          :create_user_role,
          :csv,
          :default_dir,
          :disable_role_description,
          :district,
          :edit_maker_checker,
          :edit_user_roles,
          :extract_xlsx,
          :global_configurations,
          :handle__country_bulk_upload,
          :init,
          :is_valide_file,
          :maker_checker_configuration,
          :persist,
          :process_bulk_upload,
          :process_csv,
          :province,
          :report_maintianence,
          :role_maintianence,
          :role_permision_maintianence,
          :traverse_errors,
          :update,
          :update_charge,
          :view_user_roles,
       ]

use PipeTo.Override

  def admin_user_maintenance(conn, _params) do
    render(conn, "admin_user_maintenance.html",
      individual_customer: Loanmanagementsystem.Accounts.get_loan_customer_individual(),
      banks: Loanmanagementsystem.Maintenance.list_tbl_banks()
    )
  end

  def role_maintianence(conn, _params) do
    role = Loanmanagementsystem.Accounts.list_tbl_role_description()
    user_roles = Loanmanagementsystem.Accounts.list_tbl_roles()
    render(conn, "role_maintainence.html", role: role, user_roles: user_roles)
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
    render(conn, "charge_maintenance.html",
      currencies: Loanmanagementsystem.Maintenance.list_tbl_currency(),
      charges: Loanmanagementsystem.Charges.list_tbl_charges()
    )
  end

  def commission_maintenance(conn, _params) do
    render(conn, "commission_maintenance.html")
  end

  def countries(conn, _params) do
    countries = Loanmanagementsystem.Maintenance.list_tbl_country()
      render(conn, "country.html", countries: countries)
  end

  @headers ~w/ countryName	countryCode	countryAbreviation /a

  def handle__country_bulk_upload(conn, params) do
    user = conn.assigns.user
    {key, msg, _invalid} = handle_file_upload(user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.system_management_path(conn, :countries))
    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.system_management_path(conn, :countries))
    end
  end

  defp handle_file_upload(user, params) do
    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
      user
      |> process_bulk_upload(filename, destin_path)
      |> case do
        {:ok, {invalid, valid}} ->
          {:info, "#{valid} Successful entrie(s) and #{invalid} invalid entrie(s)", invalid}

        {:error, reason} ->
          {:error, reason, 0}
      end
    else
      {:error, reason} ->
        {:error, reason, 0}
    end
  end

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

  def process_bulk_upload(user, filename, path) do
    {:ok, items} = extract_xlsx(path)

    prepare_bulk_params(user, filename, items)
    |> Repo.transaction(timeout: 290_000)
    |> case do
      {:ok, multi_records} ->
        {invalid, valid} =
          multi_records
          |> Map.values()
          |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->
            case item do
              %{countryfile_name: _src} -> {invalid, valid + 1}
              %{col_index: _index} -> {invalid + 1, valid}
              _ -> {invalid, valid}
            end
          end)

        {:ok, {invalid, valid}}

      {:error, _, changeset, _} ->
        reason = traverse_errors(changeset.errors) |> Enum.join("\r\n")
        {:error, reason}
    end
  end

  defp prepare_bulk_params(_user, _filename, items) do
    items
    |> Stream.with_index(2)
    |> Stream.map(fn {item, index} ->
      other_details = %{
        name: item.countryName,
        code: item.countryCode,
        country_file_name: item.countryAbreviation
      }

      changeset = Country.changeset(%Country{}, Map.merge(item, other_details))
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset)
    end)
    |> Enum.reject(fn
      %{operations: [{_, {:run, _}}]} -> false
      %{operations: [{_, {_, changeset, _}}]} -> changeset.valid? == false
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
  end

  # ---------------------- file persistence --------------------------------------
  def is_valide_file(%{"countryfile_name" => params}) do
    if upload = params do
      case Path.extname(upload.filename) do
        ext when ext in ~w(.xlsx .XLSX .xls .XLS .csv .CSV) ->
          with {:ok, destin_path} <- persist(upload) do
            case ext not in ~w(.csv .CSV) do
              true ->
                case Xlsxir.multi_extract(destin_path, 0, false, extract_to: :memory) do
                  {:ok, table_id} ->
                    row_count = Xlsxir.get_info(table_id, :rows)
                    Xlsxir.close(table_id)
                    {:ok, upload.filename, destin_path, row_count - 1}

                  {:error, reason} ->
                    {:error, reason}
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

  def csv(path, upload) do
    case process_csv(path) do
      {:ok, data} ->
        row_count = Enum.count(data)

        case row_count do
          rows when rows in 1..100_000 ->
            {:ok, upload.filename, path, row_count}

          _ ->
            {:error, "File records should be between 1 to 100,000"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def persist(%Plug.Upload{filename: filename, path: path}) do
    destin_path = "C:/CountriesUploads/file" |> default_dir()
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

  defp strgfy_term(term) when is_tuple(term), do: term
  defp strgfy_term(term) when not is_tuple(term), do: String.trim("#{term}")


  def province(conn, _params),
    do:
      render(conn, "province.html",
        provinces: Loanmanagementsystem.Services.Services.get_all_provinces(),
        countries: Loanmanagementsystem.Maintenance.list_tbl_country()
      )

  def district(conn, _params),
    do:
      render(conn, "district.html",
        districts: Loanmanagementsystem.Services.Services.get_all_districts(),
        provinces: Loanmanagementsystem.Maintenance.list_tbl_province(),
        countries: Loanmanagementsystem.Maintenance.list_tbl_country()
      )

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

  def add_charge(conn, params) do
    # host = conn.host
    # query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: (cl.domain== ^host), select: cl
    # clientTelco = Repo.one(query);

    code = to_string(Enum.random(1111..9999))

    account = to_string(Enum.random(1111..9999))

    IO.inspect(params["currency"])
    currency_ = String.split(params["currency"], "|||")

    IO.inspect(currency_)

    params =
      Map.merge(params, %{
        "currency" => Enum.at(currency_, 1),
        "currencyId" => Enum.at(currency_, 0),

        "code" => code,
        "accountToCredit" => account
      })

    IO.inspect(params)
    chargeChangeSet = Charge.changeset(%Charge{}, params)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:charges, chargeChangeSet)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{charges: charges} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Created new Charges with ID \"#{charges.id}\"",
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

    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end

  def update_charge(conn, params) do

    currency_ = String.split(params["currency"], "|||")

    params =
      Map.merge(params, %{
        "currency" => Enum.at(currency_, 1),
        "currencyId" => Enum.at(currency_, 0),
        "effectiveDate" => params["effectiveDate"]
      })

    chargeChangeSet = Charge.changeset(%Charge{}, params)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:charges, chargeChangeSet)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{charges: charges} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated Charges with ID \"#{charges.id}\"",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Charge Updated successfully.")
        |> redirect(to: Routes.system_management_path(conn, :charge_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.system_management_path(conn, :charge_maintenance))
    end

    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end

  alias Loanmanagementsystem.Accounts.Role

  def create_user_role(conn, %{"user_role" => params, "role_str" => role_str}) do
    IO.inspect(role_str, label: "Am here ba TEDDY Masumbi\n\n\n\n\n\n\n\n\n\n")
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

  def edit_user_roles(conn, %{"id" => id}) do
    role =
      id
      |> Accounts.get_role!()
      |> Map.update!(:role_str, &AtomicMap.convert(&1, %{safe: false}))

    render(conn, "edit_roles.html", role: role)
  end

  def view_user_roles(conn, %{"id" => id}) do
    role =
      id
      |> Accounts.get_role!()
      |> Map.update!(:role_str, &AtomicMap.convert(&1, %{safe: false}))

    render(conn, "view_roles.html", role: role)
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


  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")

    def authorize_role(conn) do
      case Phoenix.Controller.action_name(conn) do
        act when act in ~w(new create)a -> {:system_mgt, :create}
        act when act in ~w(index view)a -> {:system_mgt, :view}
        act when act in ~w(update edit)a -> {:system_mgt, :edit}
        act when act in ~w(change_status)a -> {:system_mgt, :change_status}
        _ -> {:system_mgt, :unknown}
      end
    end

end
