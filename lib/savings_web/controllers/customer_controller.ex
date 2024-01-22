defmodule SavingsWeb.CustomerController do
  use SavingsWeb, :controller

  alias Savings.Accounts.Account
  use Ecto.Schema
  alias Savings.Repo
  import Ecto.Query, warn: false
  alias Savings.Logs.UserLogs
  alias Savings.Accounts

  plug(
    SavingsWeb.Plugs.RequireAuth
    when action not in [:unknown]
  )

  plug(
    SavingsWeb.Plugs.EnforcePasswordPolicy
    when action not in [:unknown]
  )

  plug(
    SavingsWeb.Plugs.Authenticate,
    [module_callback: &SavingsWeb.CustomerController.authorize_role/1]
    when action not in [
           :index,
           :customer_list,
           :user_creation,
           :customer_item_lookup,
           :view_customer
         ]
  )

  plug SavingsWeb.Plugs.Authenticate,
    [module_callback: &SavingsWeb.ReportController.authorize_reports/1]
    when action not in [
          :index,
          :customer_list,
          :user_creation,
          :customer_item_lookup,
          :view_customer
        ]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def view_customer(conn, %{"userId" => userId}) do
    customer_data = Savings.Service.StatsQueries.get_all_savings_customer_details(userId)
    total_balance = Savings.Service.StatsQueries.get_customer_balance(userId)
    fixed_deps = Savings.Service.StatsQueries.customer_fix_dep_export(userId)
    all_tnx = Savings.Service.StatsQueries.customer_transactions_export(userId)
    mature_withdraw = Savings.Service.StatsQueries.customer_mature_withdraw_export(userId)
    total_withdraw = Savings.Service.StatsQueries.get_customer_withdraws_balance(userId)
    render(conn, "customer_details.html",
    customer_data: customer_data,
    total_balance: total_balance,
    fixed_deps: fixed_deps,
    all_tnx: all_tnx,
    mature_withdraw: mature_withdraw,
    total_withdraw: total_withdraw
    )
  end

  def customer_list(conn, _params) do
    render(conn, "customers.html")
  end

  def customer_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Savings.Accounts.get_all_clients_details(search_params, start, length)
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

  def change_status(conn, %{"id" => id} = params) do
    account = Savings.Accounts.get_account!(id)
    user = conn.assigns.user

    handle_update(user, account, Map.put(params, "checker_id", user.id))
    |> Repo.transaction()
    |> case do
      {:ok, %{update: _update, insert: _insert}} ->
        json(conn, %{"info" => "Changes applied successfully!"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{"error" => reason})
    end
  end

  defp handle_update(user, account, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update, Account.changeset(account, params))
    |> Ecto.Multi.run(:insert, fn repo, %{update: update} ->
      activity = "Updated station with acronym \"#{update.destin}\""

      user_log = %{
        user_id: user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> repo.insert()
    end)
  end

  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(savings_dashboard edit_user_roles)a ->
        {:client, :savings_dashboard}

      act when act in ~w(new edit_user_roles)a ->
        {:client, :view}

      act when act in ~w(update edit_user_roles edit)a ->
        {:client, :edit}

      act when act in ~w(change_user_status)a ->
        {:client, :change_status}

      # act when act in ~w(index show)a -> {:user, :index}
      _ ->
        {:client, :unknown}
    end
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end
end
