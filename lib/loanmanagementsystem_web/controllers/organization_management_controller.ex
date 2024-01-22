defmodule LoanmanagementsystemWeb.OrganizationManagementController do
  use LoanmanagementsystemWeb, :controller

  alias Loanmanagementsystem.Companies.Department
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Loan.Loan_Provisioning_Criteria
  alias Loanmanagementsystem.Maintenance.Alert_Maintenance
  alias Loanmanagementsystem.Payment.Collection
  alias Loanmanagementsystem.Payment.Payments
  alias Loanmanagementsystem.Maintenance.Qfin_Brance_maintenance
  alias Loanmanagementsystem.Employment.Employee_Maintenance
  alias Loanmanagementsystem.Companies.Employee
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Accounts.{User, UserRole, UserBioData}
  alias Loanmanagementsystem.Accounts.Customer_account
  alias Loanmanagementsystem.Maintenance.Currency

  def admin_department(conn, _params),
    do:
      render(conn, "admin_department.html",
        departments: Loanmanagementsystem.Companies.list_tbl_departments()
      )

  def company_maintainance(conn, _params),
    do:
      render(conn, "company_maintainance.html",
        currencies: Loanmanagementsystem.Maintenance.list_tbl_currency(),
        countries: Loanmanagementsystem.Maintenance.list_tbl_country(),
        company: Loanmanagementsystem.Maintenance.company_info()
      )

  def holiday_maintianance(conn, _params),
    do:
      render(conn, "holiday_maintainence.html",
        holidays: Loanmanagementsystem.Maintenance.list_tbl_holiday_maintenance(),
        months: calendar_month()
      )

  def password_maintianance(conn, _params),
    do:
      render(conn, "password_management.html",
        password_configs: Loanmanagementsystem.Maintenance.list_tbl_password_maintenance()
      )

  # LoanmanagementsystemWeb.OrganizationManagementController.calendar_month
  def calendar_month do
    months =
      for month <- 1..12 do
        [a, b, c, d | _] = month |> Timex.month_name() |> String.split("")
        [(a <> b <> c <> d) |> String.upcase() | []]
      end

    months |> List.flatten()
  end

  def working_day_maintianance(conn, _params),
    do:
      render(conn, "working_day_maintainence.html",
        workingdays: Loanmanagementsystem.Maintenance.workingdays_maintenance_info()
      )

  def collection_maintianance(conn, _params) do
    render(conn, "collection_maintianance.html",
      collections: Loanmanagementsystem.Payment.list_tbl_collection_type()
    )
  end

  def bulk_loan_reassignment(conn, _params),
    do:
      render(conn, "bulk_loan_reassignment.html",
        crms: Loanmanagementsystem.OperationsServices.get_qfin_crm_employees()
      )

  def alert_maintianance(conn, _params),
    do:
      render(conn, "alert_maintainence.html",
        alerts: Loanmanagementsystem.Maintenance.list_tbl_alert_maintenance()
      )

  def currency_maintianance(conn, _params),
    do:
      render(conn, "currency_maintainence.html",
        currencies: Loanmanagementsystem.Services.Services.get_all_currencies(),
        countries: Loanmanagementsystem.Maintenance.list_tbl_country()
      )

  def admin_update_currency(conn, params) do
    currency = Loanmanagementsystem.Maintenance.get_currency!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_currency, Currency.changeset(currency, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_currency: _update_currency} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Updated A Currency",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Added a Currency")
        |> redirect(to: Routes.organization_management_path(conn, :currency_maintianance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :currency_maintianance))
    end
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
        |> redirect(to: Routes.organization_management_path(conn, :currency_maintianance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :currency_maintianance))
    end
  end

  def bulk_import(conn, _params), do: render(conn, "bulk_import.html")

  def loan_provisioning_definition(conn, _params),
    do:
      render(conn, "loan_provisioning_definition.html",
        accounts: Loanmanagementsystem.Chart_of_accounts.get_expense_and_liability_accounts(),
        products: Loanmanagementsystem.Products.list_tbl_products(),
        loan_provisionings: Loanmanagementsystem.Operations.get_provisioning_criteria()
      )

  def payment_type_maintianance(conn, _params),
    do:
      render(conn, "payment_type_maintainence.html",
        payments: Loanmanagementsystem.Payment.list_tbl_payment_type()
      )

  def branch_maintianance(conn, _params),
    do:
      render(conn, "branch_maintainence.html",
        branches: Loanmanagementsystem.Maintenance.list_tbl_branch(),
        provinces: Loanmanagementsystem.Maintenance.list_tbl_province(),
        districts: Loanmanagementsystem.Services.Services.get_all_districts()
      )

  def qfin_branch_maintianance(conn, _params),
    do:
      render(conn, "qfin_branch_maintianance.html",
        provinces: Loanmanagementsystem.Maintenance.list_tbl_province(),
        districts: Loanmanagementsystem.Services.Services.get_all_districts(),
        branches: Loanmanagementsystem.Maintenance.list_tbl_qfin_branches()
      )

  def add_alert_maintenance(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_alert, Alert_Maintenance.changeset(%Alert_Maintenance{}, params))
    |> Ecto.Multi.run(:user_logs, fn _, %{add_alert: add_alert} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully added #{add_alert.alert_description}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_alert: add_alert}} ->
        conn
        |> put_flash(:info, "You have Successfully added #{add_alert.alert_description}")
        |> redirect(to: Routes.organization_management_path(conn, :alert_maintianance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :alert_maintianance))
    end
  end

  def add_collection_type(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_collection_type, Collection.changeset(%Collection{}, params))
    |> Ecto.Multi.run(:user_logs, fn _, %{add_collection_type: add_collection_type} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "You have Successfully added #{add_collection_type.collection_type_description} as a Collection Type ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_collection_type: add_collection_type}} ->
        conn
        |> put_flash(
          :info,
          "You have Successfully added #{add_collection_type.collection_type_description} as a Collection Type"
        )
        |> redirect(to: Routes.organization_management_path(conn, :collection_maintianance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :collection_maintianance))
    end
  end

  def update_collection_type(conn, params) do
    collection = Loanmanagementsystem.Payment.get_collection!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_collection_type, Collection.changeset(collection, params))
    |> Ecto.Multi.run(:user_logs, fn _, %{update_collection_type: update_collection_type} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "You have Successfully update #{update_collection_type.collection_type_description} as a Collection Type ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_collection_type: update_collection_type}} ->
        conn
        |> put_flash(
          :info,
          "You have Successfully updated #{update_collection_type.collection_type_description} as a Collection Type"
        )
        |> redirect(to: Routes.organization_management_path(conn, :collection_maintianance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :collection_maintianance))
    end
  end

  def add_payment_type_maintianance(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_payment_type_maintianance, Payments.changeset(%Payments{}, params))
    |> Ecto.Multi.run(:user_logs, fn _,
                                     %{
                                       add_payment_type_maintianance:
                                         add_payment_type_maintianance
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "You have Successfully added #{add_payment_type_maintianance.payment_type_description} as a Collection Type ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_payment_type_maintianance: add_payment_type_maintianance}} ->
        conn
        |> put_flash(
          :info,
          "You have Successfully added #{add_payment_type_maintianance.payment_type_description} as a Collection Type"
        )
        |> redirect(to: Routes.organization_management_path(conn, :payment_type_maintianance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :payment_type_maintianance))
    end
  end

  def update_payment_type_maintianance(conn, params) do
    collection = Loanmanagementsystem.Payment.get_payments!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_payment_type_maintianance,
      Payments.changeset(collection, params)
    )
    |> Ecto.Multi.run(:user_logs, fn _,
                                     %{
                                       update_payment_type_maintianance:
                                         update_payment_type_maintianance
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "You have Successfully update #{update_payment_type_maintianance.payment_type_description} as a Collection Type ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_payment_type_maintianance: update_payment_type_maintianance}} ->
        conn
        |> put_flash(
          :info,
          "You have Successfully updated #{update_payment_type_maintianance.payment_type_description} as a Collection Type"
        )
        |> redirect(to: Routes.organization_management_path(conn, :payment_type_maintianance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :payment_type_maintianance))
    end
  end

  def admin_activate_department(conn, params) do
    department = Loanmanagementsystem.Companies.get_department!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_department,
      Department.changeset(department, Map.merge(params, %{"status" => "ACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_department: activate_department} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated #{activate_department.name} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_department: activate_department}} ->
        json(conn, %{data: "#{activate_department.name} activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_deactivate_department(conn, params) do
    department = Loanmanagementsystem.Companies.get_department!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :deactivate_department,
      Department.changeset(department, Map.merge(params, %{"status" => "INACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{deactivate_department: deactivate_department} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated #{deactivate_department.name} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{deactivate_department: deactivate_department}} ->
        json(conn, %{data: "#{deactivate_department.name}  Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_deactivate_alert_amintenance(conn, params) do
    alert_amintenance = Loanmanagementsystem.Maintenance.get_alert__maintenance!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :deactivate_alert_amintenance,
      Alert_Maintenance.changeset(alert_amintenance, Map.merge(params, %{"status" => "INACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _,
                                     %{deactivate_alert_amintenance: deactivate_alert_amintenance} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated #{deactivate_alert_amintenance.alert_description} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{deactivate_alert_amintenance: deactivate_alert_amintenance}} ->
        json(conn, %{
          data: "#{deactivate_alert_amintenance.alert_description}  Deactivated successfully"
        })

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_activate_alert_amintenance(conn, params) do
    alert_amintenance = Loanmanagementsystem.Maintenance.get_alert__maintenance!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :deactivate_alert_amintenance,
      Alert_Maintenance.changeset(alert_amintenance, Map.merge(params, %{"status" => "ACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _,
                                     %{deactivate_alert_amintenance: deactivate_alert_amintenance} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated #{deactivate_alert_amintenance.alert_description} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{deactivate_alert_amintenance: deactivate_alert_amintenance}} ->
        json(conn, %{
          data: "#{deactivate_alert_amintenance.alert_description}  Deactivated successfully"
        })

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_add_department(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_department, Department.changeset(%Department{}, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_department: add_department} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully added #{add_department.name}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_department: add_department}} ->
        conn
        |> put_flash(:info, "You have Successfully Added #{add_department.name}")
        |> redirect(to: Routes.organization_management_path(conn, :admin_department))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :admin_department))
    end
  end

  def admin_update_department(conn, params) do
    department = Loanmanagementsystem.Companies.get_department!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:add_department, Department.changeset(department, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_department: add_department} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully updated #{add_department.name}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_department: add_department}} ->
        conn
        |> put_flash(:info, "You have Successfully updated #{add_department.name}")
        |> redirect(to: Routes.organization_management_path(conn, :admin_department))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :admin_department))
    end
  end

  def change_mgt_employee_maintainence(conn, _params) do
    employees = Loanmanagementsystem.OperationsServices.get_qfin_employees()

    departments = Loanmanagementsystem.Companies.list_tbl_departments()

    roles = Loanmanagementsystem.Accounts.list_tbl_role_description()

    companies =
      Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isEmployer != true))

    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    branches = Loanmanagementsystem.Maintenance.list_tbl_qfin_branches()
    classifications = Loanmanagementsystem.Maintenance.list_tbl_classification()

    render(conn, "employee_maintainence.html",
      employees: employees,
      departments: departments,
      banks: banks,
      branches: branches,
      classifications: classifications,
      companies: companies,
      roles: roles,
      provinces: Loanmanagementsystem.Maintenance.list_tbl_province()
    )
  end

  def view_qfin_add_employee(conn, params) do
    employees = Loanmanagementsystem.OperationsServices.get_qfin_employees()

    departments = Loanmanagementsystem.Companies.list_tbl_departments()

    roles = Loanmanagementsystem.Accounts.list_tbl_role_description()

    companies =
      Loanmanagementsystem.Operations.get_company() |> Enum.reject(&(&1.isEmployer != true))

    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    branches = Loanmanagementsystem.Maintenance.list_tbl_qfin_branches()
    classifications = Loanmanagementsystem.Maintenance.list_tbl_classification()

    render(conn, "add_qfin_employee.html",
      employees: employees,
      departments: departments,
      banks: banks,
      branches: branches,
      classifications: classifications,
      companies: companies,
      roles: roles,
      provinces: Loanmanagementsystem.Maintenance.list_tbl_province()
    )
  end

  @spec add_provisioning_criteria(Plug.Conn.t(), any) :: Plug.Conn.t()
  def add_provisioning_criteria(conn, params) do
    IO.inspect(params, label: "param inspection ")

    # |> push_to_loan_prov(params)
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :user_logs,
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Added A Loan Provisioning Criteria",
        user_id: conn.assigns.user.id
      })
    )
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        LoanmanagementsystemWeb.OrganizationManagementController.push_to_loan_prov(conn, params)

        conn
        |> put_flash(:info, "You have Successfully Added A Loan Provisioning Criteria ")
        |> redirect(to: Routes.organization_management_path(conn, :loan_provisioning_definition))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :loan_provisioning_definition))
    end
  end

  def push_to_loan_prov(_conn, params) do
    for x <- 0..(Enum.count(params["st_min_age"]) - 1) do
      IO.inspect(">>>>>>++++++++++++++++++>>>>>>")

      notifications = %{
        maxAge: Enum.at(params["st_min_age"], x),
        minAge: Enum.at(params["st_max_age"], x),
        category: Enum.at(params["st_category"], x),
        criteriaName: params["provisioning_criteria"],
        expense_account_id: Enum.at(params["st_expense"], x),
        liability_account_id: Enum.at(params["st_liability"], x),
        percentage: Enum.at(params["st_percentage"], x)
        # productId: params["productId"]
      }

      Loan_Provisioning_Criteria.changeset(%Loan_Provisioning_Criteria{}, notifications)
      |> Repo.insert()
    end
  end

  # defp push_to_device(multi, params) do

  #   agent_lines = Enum.with_index(params["deviceAgentLine"], 1)
  #   agent_device = Enum.with_index(params["deviceIMEI"], 1)

  #   Ecto.Multi.merge(multi, fn %{:add_mobile_money_agent => %{id: merchantId}} =
  #                                _changes ->
  #     Enum.reduce(agent_lines, Ecto.Multi.new(), fn {line, index}, multi ->
  #       Enum.reduce(agent_device, Ecto.Multi.new(), fn {agent_device, index}, multi ->
  #         IO.inspect(index, label: "Line here")
  #         IO.inspect(agent_lines, label: "Lines Lines")
  #         params =  %{
  #           deviceType: line,
  #           deviceModel: line,
  #           deviceAgentLine: line,
  #           deviceIMEI: agent_device,
  #           status: "ACTIVE",
  #           merchantId: merchantId,

  #         }

  #         Ecto.Multi.insert(
  #           multi,
  #           {:line, index, agent_device: index},
  #           Merchants_device.changeset(%Merchants_device{}, params)
  #         )
  #       end)
  #     end)
  #     end)
  # end

  def admin_qfin_add_branch(conn, params) do
    params = Map.merge(params, %{"status" => "INACTIVE"})
    params = Map.merge(params, %{"created_by" => conn.assigns.user.id})
    # params = Map.merge(params, %{"status" => "INACTIVE"})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :branches,
      Qfin_Brance_maintenance.changeset(%Qfin_Brance_maintenance{}, params)
    )
    |> Ecto.Multi.run(:user_log, fn _repo, %{branches: branches} ->
      activity = "Created new Branch with ID \"#{branches.id}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{branches: branches, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "#{branches.name} Created successfully.")
        |> redirect(to: Routes.organization_management_path(conn, :qfin_branch_maintianance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :qfin_branch_maintianance))
    end
  end

  def admin_qfin_update_branch(conn, params) do
    branch = Loanmanagementsystem.Maintenance.get_qfin__brance_maintenance!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_branches, Qfin_Brance_maintenance.changeset(branch, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{update_branches: update_branches} ->
      activity = "Updated Branch with ID \"#{update_branches.id}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_branches: _update_branches, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Branch Update successfully.")
        |> redirect(to: Routes.organization_management_path(conn, :qfin_branch_maintianance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.organization_management_path(conn, :qfin_branch_maintianance))
    end
  end

  def admin_ofin_activate_branch(conn, params) do
    branch = Loanmanagementsystem.Maintenance.get_qfin__brance_maintenance!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_branch,
      Qfin_Brance_maintenance.changeset(branch, Map.merge(params, %{"status" => "ACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_branch: activate_branch} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated #{activate_branch.name} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_branch: activate_branch}} ->
        json(conn, %{data: "#{activate_branch.name} activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_ofin_deactivate_branch(conn, params) do
    branch = Loanmanagementsystem.Maintenance.get_qfin__brance_maintenance!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_branch,
      Qfin_Brance_maintenance.changeset(branch, Map.merge(params, %{"status" => "INACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_branch: activate_branch} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated #{activate_branch.name} Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_branch: activate_branch}} ->
        json(conn, %{data: "#{activate_branch.name}  Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def parse_image(path) do
    path
    |> File.read!()
    |> Base.encode64()
  end

  def admin_qfin_employees(conn, params) do
    param =
      if params["isRm"] == "on" do
        true
      else
        false
      end

    params = Map.merge(params, %{"isRm" => param})

    account_number_gen =
      LoanmanagementsystemWeb.ClientManagementController.init_acc_no_generation(
        params["product_name"]
      )

    IO.inspect(params, label: "image params")
    image = params["nrc_image"]
    otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_user,
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["mobileNumber"],
        pin: otp
      })
    )
    |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
      UserRole.changeset(%UserRole{}, %{
        roleType: "EMPLOYEE",
        status: "INACTIVE",
        userId: add_user.id,
        otp: otp,
        isStaff: true
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:userBioDate, fn _repo,
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
        bank_id: params["bank_id"],
        bank_account_number: params["bank_account_number"],
        marital_status: params["marital_status"],
        nationality: params["nationality"],
        number_of_dependants: params["number_of_dependants"],
        age: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_employee_maintenance, fn _repo,
                                                    %{
                                                      add_user: add_user,
                                                      add_user_role: _add_user_role,
                                                      userBioDate: _userBioDate
                                                    } ->
      validate_img =
        if Loanmanagementsystem.Employment.get_employee__maintenance_by_userId(add_user.id) == nil do
          ""
        else
          Loanmanagementsystem.Employment.get_employee__maintenance_by_userId(add_user.id).nrc_image
        end

      IO.inspect(validate_img, label: "validate_img *************************************")

      encode_img =
        if image != nil || image != "" do
          parse_image(image.path)
        else
          validate_img
        end

      IO.inspect(encode_img, label: "encode_img *************************")

      departmentId = String.to_integer(params["departmentId"])
      # param = Map.merge(params, %{"nrc_image" => encode_img})

      Employee_Maintenance.changeset(%Employee_Maintenance{}, %{
        branchId: params["branchId"],
        departmentId: departmentId,
        employee_number: params["employee_number"],
        employee_status: params["employee_status"],
        mobile_network_operator: params["mobile_network_operator"],
        nrc_image: encode_img,
        registered_name_mobile_number: params["registered_name_mobile_number"],
        roleTypeId: params["roleTypeId"],
        userId: add_user.id,
        job_title: params["job_title"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_emplee_values, fn _repo,
                                             %{
                                               add_user: add_user,
                                               add_user_role: add_user_role,
                                               userBioDate: _userBioDate,
                                               add_employee_maintenance: _add_employee_maintenance
                                             } ->
      Employee.changeset(%Employee{}, %{
        status: "INACTIVE",
        userId: add_user.id,
        userRoleId: add_user_role.id,
        loan_limit: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_address_address, fn _repo,
                                               %{
                                                 add_user: add_user,
                                                 add_user_role: _add_user_role,
                                                 userBioDate: _userBioDate,
                                                 add_employee_maintenance:
                                                   _add_employee_maintenance,
                                                 add_emplee_values: _add_emplee_values
                                               } ->
      Address_Details.changeset(%Address_Details{}, %{
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        userId: add_user.id,
        year_at_current_address: params["year_at_current_address"],
        province: params["province"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:customer_accounts, fn _repo,
                                             %{
                                               add_user: add_user,
                                               add_user_role: _add_user_role,
                                               userBioDate: _suserBioDate,
                                               add_employee_maintenance:
                                                 _add_employee_maintenance,
                                               add_emplee_values: _add_emplee_values,
                                               add_address_address: _add_address_address
                                             } ->
      Customer_account.changeset(%Customer_account{}, %{
        account_number: account_number_gen,
        status: "ACTIVE",
        user_id: add_user.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_user: _add_user,
                                       add_user_role: _add_user_role,
                                       userBioDate: userBioDate,
                                       add_employee_maintenance: _add_employee_maintenance,
                                       add_emplee_values: _add_emplee_values,
                                       add_address_address: _add_address_address
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "You have Successfully Added #{userBioDate.firstName} #{userBioDate.lastName} as a Staff of Qfin",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{userBioDate: userBioDate}} ->
        conn
        |> put_flash(
          :info,
          "You have Successfully Added #{userBioDate.firstName} #{userBioDate.lastName} as a Staff of Qfin"
        )
        |> redirect(
          to: Routes.organization_management_path(conn, :change_mgt_employee_maintainence)
        )

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(
          to: Routes.organization_management_path(conn, :change_mgt_employee_maintainence)
        )
    end
  end

  def admin_qfin_update_employee(conn, params) do
    param =
      if params["isRm"] == "on" do
        true
      else
        false
      end

    params = Map.merge(params, %{"isRm" => param})

    IO.inspect(params, label: "hdjfkbkbskjbdkbf")
    userBiodata = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])
    address = Loanmanagementsystem.Accounts.get_address__details_by_userId(params["id"])
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])

    employee_mtc =
      Loanmanagementsystem.Employment.get_employee__maintenance_by_userId(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_user_bio_data,
      UserBioData.changeset(userBiodata, %{
        dateOfBirth: params["dateOfBirth"],
        emailAddress: params["emailAddress"],
        firstName: params["firstName"],
        gender: params["gender"],
        lastName: params["lastName"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
        mobileNumber: params["mobileNumber"],
        otherName: params["otherName"],
        title: params["title"],
        bank_id: params["bank_id"],
        bank_account_number: params["bank_account_number"],
        marital_status: params["marital_status"],
        nationality: params["nationality"],
        number_of_dependants: params["number_of_dependants"]
      })
    )
    |> Ecto.Multi.run(:user_update, fn _repo, %{update_user_bio_data: _update_user_bio_data} ->
      User.changeset(user, %{
        isRm: params["isRm"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:address_details, fn _repo,
                                           %{
                                             update_user_bio_data: _update_user_bio_data,
                                             user_update: _user_update
                                           } ->
      Address_Details.changeset(address, %{
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        year_at_current_address: params["year_at_current_address"],
        province: params["province"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_employee_mtc, fn _repo,
                                               %{
                                                 update_user_bio_data: _update_user_bio_data,
                                                 address_details: _address_details,
                                                 user_update: _user_update
                                               } ->
      Employee_Maintenance.changeset(employee_mtc, %{
        branchId: params["branchId"],
        departmentId: params["departmentId"],
        employee_number: params["employee_number"],
        employee_status: params["employee_status"],
        mobile_network_operator: params["mobile_network_operator"],
        job_title: params["job_title"],
        registered_name_mobile_number: params["registered_name_mobile_number"],
        roleTypeId: params["roleTypeId"],
        job_title: params["job_title"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:userlogs, fn _repo,
                                    %{
                                      update_user_bio_data: update_user_bio_data,
                                      address_details: _address_details,
                                      update_employee_mtc: _update_employee_mtc,
                                      user_update: _user_update
                                    } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "You have Successfully Updated #{update_user_bio_data.firstName} #{update_user_bio_data.lastName} as a Staff of Qfin",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_user_bio_data: update_user_bio_data, userlogs: _userlogs}} ->
        conn
        |> put_flash(
          :info,
          "You have Successfully Updated #{update_user_bio_data.firstName} #{update_user_bio_data.lastName} as a Staff of Qfin"
        )
        |> redirect(
          to: Routes.organization_management_path(conn, :change_mgt_employee_maintainence)
        )

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(
          to: Routes.organization_management_path(conn, :change_mgt_employee_maintainence)
        )
    end
  end

  def customer_loan_user_item_lookup(conn, params) do
    IO.inspect(params, label: "inspections")
    userId = params["userId"]
    {draw, start, length, search_params} = search_options(params)

    results =
      Loanmanagementsystem.Loan.customer_loan_user_item_lookup(
        search_params,
        start,
        length,
        userId
      )

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

  def customer_pending_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.customer_pending_list(search_params, start, length)
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

  def admin_bulk_re_assignment(conn, params) do
    clients =
      Loanmanagementsystem.OperationsServices.get_clients_for_re_assignemnt(params["userId"])

    render(conn, "admin_bulk_re_assignment.html",
      userId: params["userId"],
      crm_branch: params["crm_branch"],
      crms_names: params["firstname"] <> " " <> params["lastname"],
      clients: clients,
      crms: Loanmanagementsystem.OperationsServices.get_qfin_crm_employees(),
      branches: Loanmanagementsystem.Maintenance.list_tbl_qfin_branches()
    )
  end

  def admin_client_crm_re_assignment_bulk(conn, params) do
    with(
      clients when clients != [] <-
        Loanmanagementsystem.Accounts.get_customer_account_loan_officer_id(params["userId"])
    ) do
      clients
      |> Enum.map(fn clients_details ->
        client_bio_data =
          Loanmanagementsystem.Accounts.UserBioData.find_by(userId: clients_details.user_id)

        Ecto.Multi.new()
        |> Ecto.Multi.update(
          {:clients_details, "#{Ecto.UUID.generate()}"},
          Customer_account.changeset(clients_details, %{
            "loan_officer_id" => params["new_crm_userId"],
            "previous_Rm" => params["userId"]
          })
        )
        |> Ecto.Multi.insert(
          {:user_logs, "#{Ecto.UUID.generate()}"},
          UserLogs.changeset(%UserLogs{}, %{
            activity:
              "You have Succssfully Update a loan Officer for #{client_bio_data.firstName} #{client_bio_data.lastName}",
            user_id: conn.assigns.user.id
          })
        )
      end)
      |> List.flatten()
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi(conn)
    else
      _ ->
        conn
        |> put_flash(:error, "Failed to re-assign bulk")
        |> redirect(to: Routes.organization_management_path(conn, :bulk_loan_reassignment))
    end
  end

  defp execute_multi(multi, conn) do
    multi
    |> Repo.transaction()
    |> case do
      {:ok, _result} ->
        conn
        |> put_flash(
          :info,
          "You have Successfully Performed a Bulk Re Assignment"
        )
        |> redirect(to: Routes.organization_management_path(conn, :bulk_loan_reassignment))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        IO.inspect(failed_value)
        {:error, failed_value}
    end
  end

  # def admin_client_crm_re_assignment_bulk(conn, params) do
  #   clients = Loanmanagementsystem.Accounts.get_customer_account_loan_officer_id(params["userId"])

  #   Ecto.Multi.new()
  #   |>Ecto.Multi.update(:updatr_loan_officer, Customer_account.changeset(clients, %{"loan_officer_id" => params["userId"]}))
  #   |>Ecto.Multi.insert(:user_logs, UserLogs.changeset(%UserLogs{}, %{
  #     activity: "You have Succssfully Update a loan Officer",
  #     user_id: conn.assigns.user.id
  #   }
  #   ))
  #   |>Repo.transaction()
  #    |> case do
  #     {:ok, _ } ->

  #       conn
  #       |> put_flash(
  #         :info,
  #         "You have Successfully Performed a Bulk Re Assignment"
  #       )
  #       |> redirect(
  #         to: Routes.organization_management_path(conn, :bulk_loan_reassignment)
  #       )

  #     {:error, _failed_operation, failed_value, _changes_so_far} ->
  #       reason = traverse_errors(failed_value.errors)

  #       conn
  #       |> put_flash(:error, reason)
  #       |> redirect(
  #         to: Routes.organization_management_path(conn, :bulk_loan_reassignment)
  #       )
  #   end

  # end

  # defp get_customers(multi,params) do

  # end

  def client_manager_item_lookup(conn, %{
        "userId" => userId
      }) do
    user_details = Loanmanagementsystem.Accounts.client_relationship_manager_bulk_lookup(userId)

    json(conn, %{"data" => List.wrap(user_details)})
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
