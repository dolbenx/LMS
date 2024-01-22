defmodule SavingsWeb.MaintenanceController do
  use SavingsWeb, :controller
  use Ecto.Schema
  alias Savings.Repo
  import Ecto.Query, warn: false
  # alias Savings.Charges.Charge
  alias Savings.Maintenance.Branch
  alias Savings.Logs.UserLogs
  alias Savings.Accounts.SecurityQuestions
  alias Savings.Accounts
  alias Savings.SystemSetting.Currency
  alias Savings.Charges.Charge
  alias Savings.EndOfDay.Calendar

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def currency_maintenance(conn, _params) do
    currency = Savings.SystemSetting.currency_name()
    render(conn, "currency.html", currency: currency)
  end

  def charge_maintenance(conn, _params) do
    charges = Savings.Charges.list_tbl_charge()
    render(conn, "charges.html", charges: charges)
  end

  def countries_maintenance(conn, _params) do
    currency = Savings.SystemSetting.currency_name()
    render(conn, "countries.html", currency: currency)
  end

  def security_questions(conn, _params) do
    questions = Savings.Accounts.list_tbl_security_questions()
    render(conn, "security_questions.html", questions: questions)
  end

  def branch_maintenance(conn, _params) do
    branches = Savings.Maintenance.list_tbl_branch()
    render(conn, "branches.html", branches: branches)
  end

  def create_branch(conn, params) do
    params = Map.merge(params, %{"status" => "INACTIVE"})
    # params = Map.merge(params, %{"created_by" => conn.assigns.user.id})
    # params = Map.merge(params, %{"status" => "INACTIVE"})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:branches, Branch.changeset(%Branch{}, params))
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
        |> put_flash(:info, "Branch '#{branches.branchName}' Created successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :branch_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :branch_maintenance))
    end
  end

  def calender_maintenance(conn, _params) do
    calender = Savings.EndOfDay.list_calendars()
    render(conn, "calender.html", calender: calender)
  end

  def add_security_questions(conn, params) do
    SavingsWeb.MaintenanceController.push_to_security_questions(params)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :user_logs,
      UserLogs.changeset(
        %UserLogs{},
        %{
          user_id: conn.assigns.user.id,
          activity: "Security Question created"
        }
      )
    )
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You Have Successfully added Security Questions")
        |> redirect(to: Routes.maintenance_path(conn, :security_questions))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :security_questions))
    end
  end

  def push_to_security_questions(params) do
    question_status = "ACTIVE"

    for x <- 0..(Enum.count(params["question"]) - 1) do
      IO.inspect(">>>>>>++++++++++++++++++>>>>>>")

      security_questions = %{
        question: Enum.at(params["question"], x),
        status: question_status
      }

      SecurityQuestions.changeset(%SecurityQuestions{}, security_questions)
      |> Repo.insert()
    end
  end

  def update_questions(conn, params) do
    questions = Accounts.get_security_questions!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:questions, SecurityQuestions.changeset(questions, params))
    |> Ecto.Multi.run(:user_log, fn _, %{questions: questions} ->
      activity = "Updated Question with ID \"#{questions.id}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{questions: _questions, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Question updated successfully")
        |> redirect(to: Routes.maintenance_path(conn, :security_questions))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :security_questions))
    end
  end

  def question_disable(conn, params) do
    questions = Accounts.get_security_questions!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:question, SecurityQuestions.changeset(questions, %{status: "DISABLED"}))
    |> Ecto.Multi.run(:user_log, fn _, %{question: questions} ->
      activity = "Question Disabled with ID \"#{questions.id}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{question: _question, user_log: _user_log}} ->
        conn |> json(%{message: "Question Disabled successfully", status: 0})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
    end
  end

  def question_activate(conn, params) do
    questions = Accounts.get_security_questions!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:question, SecurityQuestions.changeset(questions, %{status: "ACTIVE"}))
    |> Ecto.Multi.run(:user_log, fn _, %{question: questions} ->
      activity = "Question Activated with ID \"#{questions.id}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{question: _question, user_log: _user_log}} ->
        conn |> json(%{message: "Question Activated successfully", status: 0})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
    end
  end

  def create_currency(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:currency, Currency.changeset(%Currency{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{currency: currency} ->
      activity = "Created new currency with ID \"#{currency.id}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{currency: currency, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Currency '#{currency.name}' Created successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :currency_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :currency_maintenance))
    end
  end

  def update_currency(conn, params) do
    currency = Savings.SystemSetting.get_currency!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:currency, Currency.changeset(currency, params))
    |> Ecto.Multi.run(:user_log, fn _, %{currency: currency} ->
      activity = "Updated Question with ID \"#{currency.id}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{currency: _currency, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Currency updated successfully")
        |> redirect(to: Routes.maintenance_path(conn, :currency_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :currency_maintenance))
    end
  end

  def create_charge(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:charge, Charge.changeset(%Charge{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{charge: charge} ->
      activity = "Created new Branch with ID \"#{charge.id}\""

      user_log = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{charge: charge, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Charge '#{charge.chargeName}' Created successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :charge_maintenance))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :charge_maintenance))
    end
  end

  def create_calendar(conn, params) do
    user = conn.assigns.user
    IO.inspect("Create End Of Day calender")
    IO.inspect(params)
    start_date = params["start_date"]
    end_date = params["end_date"]
    name = params["name"]

    startDateStr = String.split(start_date, "-")
    IO.inspect(startDateStr)
    startDateStrYr = Enum.at(startDateStr, 0)
    startDateStrMn = Enum.at(startDateStr, 1)
    startDateStrDd = Enum.at(startDateStr, 2)
    startDateStr = startDateStrYr <> "-" <> startDateStrMn <> "-" <> startDateStrDd
    IO.inspect(startDateStr)

    endDateStr = String.split(end_date, "-")
    IO.inspect(endDateStr)
    endDateStrYr = Enum.at(endDateStr, 0)
    endDateStrMn = Enum.at(endDateStr, 1)
    endDateStrDd = Enum.at(endDateStr, 2)
    endDateStr = endDateStrYr <> "-" <> endDateStrMn <> "-" <> endDateStrDd

    d1 = Date.from_iso8601(startDateStr)
    IO.inspect(d1)

    start_date =
      case d1 do
        {:ok, start_date} ->
          start_date

        {:error, :invalid_format} ->
          nil
      end

    IO.inspect(start_date)

    end_date =
      case Date.from_iso8601(endDateStr) do
        {:ok, end_date} ->
          end_date

        {:error, :invalid_format} ->
          nil
      end

    query =
      from au in Calendar,
        where: au.start_date <= type(^start_date, :date),
        where: au.end_date >= type(^end_date, :date),
        order_by: [desc: :inserted_at],
        select: au

    calendarList = Repo.all(query)

    IO.inspect("calendarList")
    IO.inspect(Enum.count(calendarList))

    if Enum.count(calendarList) > 0 do
      conn
      |> put_flash(
        :error,
        "You can not create this calendar as the start and or end dates fall within an existing calendar"
      )
      |> redirect(to: "/Get/Calender/Maintenance/View")
    else
      attrs = %Calendar{
        start_date: start_date,
        end_date: end_date,
        name: name,
        createdby_id: user.id
      }

      Repo.insert!(attrs)

      conn
      |> put_flash(:info, "Calendar created successfully")
      |> redirect(to: "/Get/Calender/Maintenance/View")
    end
  end

  def update_calendar(conn, params) do
    param =
      Map.merge(params, %{
        "name" => params["name"],
        "start_date" => params["start_date"],
        "end_date" => params["end_date"],
        "createdby_id" => conn.assigns.user.id
      })

    update_calendar = Savings.EndOfDay.get_calendar!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_calendar, Calendar.changeset(update_calendar, param))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_calendar: update_calendar} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated Calendar with ID \"#{update_calendar.id}\"",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _msg} ->
        conn
        |> put_flash(:info, "You have Successfully Updated the Calendar")
        |> redirect(to: Routes.maintenance_path(conn, :calender_maintenance))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :calender_maintenance))
    end
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end
end
