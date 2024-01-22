defmodule SavingsWeb.FcubeGeneralLedgerController do
  use SavingsWeb, :controller

  alias Savings.Repo
  alias Savings.Products
  alias Savings.Logs.UserLogs
  alias Savings.Divestments
  alias Savings.Divestments.DivestmentPackage
  alias Savings.Products.Product
  alias Savings.SystemSetting
  alias Savings.Charges
  alias Savings.Charges.Charge
  alias Savings.Products.ProductCharge
  alias Savings.Accounts.UserRole
  alias Savings.Accounts.User
  alias Savings.Client.UserBioData
  alias Savings.EndOfDay
  alias Savings.EndOfDay.FcubeGeneralLedger
  require Record
  require Logger
  import Ecto.Query, warn: false

  require Logger

  plug(
    SavingsWeb.Plugs.EnforcePasswordPolicy
    when action not in [:new_password, :change_password]
  )

  def index(conn, _params) do
    fcube_general_ledger = EndOfDay.get_tbl_fcube_general_ledger()
    render(conn, "index.html", fcube_general_ledger: fcube_general_ledger)
  end

  def new(conn, _params) do
    changeset = EndOfDay.change_fcube_general_ledger(%FcubeGeneralLedger{})
    render(conn, "new.html", changeset: changeset)
  end

  def edit(conn, _params) do
    changeset = EndOfDay.change_fcube_general_ledger(%FcubeGeneralLedger{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    for x <- 0..(Enum.count(params["account_name"]) - 1) do
      Logger.info(">>>>>>>>>>>>")

      fcubeGeneralLedger = %{
        account_name: Enum.at(params["account_name"], x),
        gl_account_no: Enum.at(params["gl_account_no"], x)
      }

      FcubeGeneralLedger.changeset(%FcubeGeneralLedger{}, fcubeGeneralLedger)
      |> Repo.insert()
    end

    conn
    |> put_flash(:info, "Flexcube General Ledger Accounts updated successfully.")
    |> redirect(to: Routes.fcube_general_ledger_path(conn, :index))
  end

  def create_gl(conn, params) do
    for x <- 0..(Enum.count(params["account_name"]) - 1) do
      Logger.info(">>>>>>>>>>>>")

      fcubeGeneralLedger = %{
        account_name: Enum.at(params["account_name"], x),
        gl_account_no: Enum.at(params["gl_account_no"], x)
      }

      FcubeGeneralLedger.changeset(%FcubeGeneralLedger{}, fcubeGeneralLedger)
      |> Repo.insert()
    end

    conn
    |> put_flash(:info, "Flexcube General Ledger Accounts created successfully.")
    |> redirect(to: Routes.fcube_general_ledger_path(conn, :index))

    # |> redirect(to: Routes.fcube_general_ledger_path(conn, :new))
  end

  def show(conn, %{"id" => id}) do
    fcube_general_ledger = EndOfDay.get_fcube_general_ledger!(id)
    render(conn, "show.html", fcube_general_ledger: fcube_general_ledger)
  end

  def edit(conn, %{"id" => id}) do
    fcube_general_ledger = EndOfDay.get_fcube_general_ledger!(id)
    changeset = EndOfDay.change_fcube_general_ledger(fcube_general_ledger)
    render(conn, "edit.html", fcube_general_ledger: fcube_general_ledger, changeset: changeset)
  end

  def update_gl_account(conn, params) do
    gl_acc = EndOfDay.get_fcube_general_ledger!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:gl_acc, FcubeGeneralLedger.changeset(gl_acc, params))
    |> Repo.transaction()
    |> case do
      {:ok, %{enable_gl: enable_gl}} ->
        conn
        |> put_flash(:info, "You Have Successfully Activated GL Account Settings With Account Name \"#{enable_gl.account_name}\"")
        |> redirect(to: Routes.fcube_general_ledger_path(conn, :index))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.fcube_general_ledger_path(conn, :index))
    end
  end

  def enable_gl_account(conn, params) do
    enable_gl = EndOfDay.get_fcube_general_ledger!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:enable_gl, FcubeGeneralLedger.changeset(enable_gl, %{status: "ACTIVE"}))
    |> Ecto.Multi.run(:user_log, fn _repo, %{enable_gl: enable_gl} ->
      activity = "Activated GL Account with Name \"#{enable_gl.account_name}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{enable_gl: _enable_gl, user_log: _user_log}} ->
        conn
        |> put_flash(
          :info,
          "You Have Successfully Activated GL Account Settings With Account Name \"#{enable_gl.account_name}\""
        )
        |> redirect(to: Routes.fcube_general_ledger_path(conn, :index))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.fcube_general_ledger_path(conn, :index))
    end
  end

  def disable_gl_account(conn, params) do
    enable_gl = EndOfDay.get_fcube_general_ledger!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :enable_gl,
      FcubeGeneralLedger.changeset(enable_gl, %{status: "DISABLED"})
    )
    |> Ecto.Multi.run(:user_log, fn _repo, %{enable_gl: enable_gl} ->
      activity = "Deactivated GL Account with Name \"#{enable_gl.account_name}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{enable_gl: enable_gl, user_log: _user_log}} ->
        conn
        |> put_flash(
          :info,
          "You Have Successfully Deactivated GL Account Settings With Account Name \"#{enable_gl.account_name}\""
        )
        |> redirect(to: Routes.fcube_general_ledger_path(conn, :index))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.fcube_general_ledger_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "fcube_general_ledger" => fcube_general_ledger_params}) do
    fcube_general_ledger = EndOfDay.get_fcube_general_ledger!(id)

    case EndOfDay.update_fcube_general_ledger(fcube_general_ledger, fcube_general_ledger_params) do
      {:ok, fcube_general_ledger} ->
        conn
        |> put_flash(:info, "Fcube general ledger updated successfully.")
        |> redirect(to: Routes.fcube_general_ledger_path(conn, :show, fcube_general_ledger))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", fcube_general_ledger: fcube_general_ledger, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fcube_general_ledger = EndOfDay.get_fcube_general_ledger!(id)
    {:ok, _fcube_general_ledger} = EndOfDay.delete_fcube_general_ledger(fcube_general_ledger)

    conn
    |> put_flash(:info, "Fcube general ledger deleted successfully.")
    |> redirect(to: Routes.fcube_general_ledger_path(conn, :index))
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end
end
