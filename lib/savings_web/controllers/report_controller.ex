defmodule SavingsWeb.ReportController do
  use SavingsWeb, :controller

  alias Savings.Repo
  alias Savings.SystemSetting
  alias Savings.Companies
  # alias Savings.FixedDeposit.FixedDeposits
  #   alias Savings.Divestments
  #   alias Savings.FixedDeposit
  require Record
  require Logger
  import Ecto.Query, warn: false

  plug(
    SavingsWeb.Plugs.RequireAuth
    when action not in [:unknown]
  )

  plug(
    SavingsWeb.Plugs.EnforcePasswordPolicy
    when action not in [:unknown]
  )

  plug SavingsWeb.Plugs.Authenticate,
       [module_callback: &SavingsWeb.ReportController.authorize/1]
       when action not in [
              :fixed_deposit_reports,
              :generate_fixed_deposit_reports,
              :fixed_deposit_search,
              :transaction_reports,
              :generate_transaction_reports,
              :transaction_search,
              :customer_reports,
              :generate_customer_reports,
              :customer_search,
              :divestment_reports,
              :generate_divestment_reports,
              :compareProduct,
              :divestment_search,
              :fixed_deposit_item_lookup,
              :total_entries,
              :entries,
              :search_options,
              :calculate_page_num,
              :calculate_page_size,
              :divestment_item_lookup,
              :all_customer_txn_item_item_lookup,
              :all_customer_item_lookup,
              :all_customer_txn_item_lookup,
              :deposits_reports_summury,
              :deposit_reports_interest,
              :liqudated_reports,
              :all_customer_deposit_summary_item_lookup,
              :all_customer_liquid_item_lookup,
              :all_customer_deposit_interest_item_lookup
            ]

  plug SavingsWeb.Plugs.Authenticate,
       [module_callback: &SavingsWeb.ReportController.authorize_reports/1]
       when action not in [
              :fixed_deposit_reports,
              :generate_fixed_deposit_reports,
              :fixed_deposit_search,
              :transaction_reports,
              :generate_transaction_reports,
              :transaction_search,
              :customer_reports,
              :generate_customer_reports,
              :customer_search,
              :divestment_reports,
              :generate_divestment_reports,
              :compareProduct,
              :divestment_search,
              :fixed_deposit_item_lookup,
              :total_entries,
              :entries,
              :search_options,
              :calculate_page_num,
              :calculate_page_size,
              :divestment_item_lookup,
              :all_customer_txn_item_item_lookup,
              :all_customer_item_lookup,
              :all_customer_txn_item_lookup,
              :deposits_reports_summury,
              :deposit_reports_interest,
              :liqudated_reports,
              :all_customer_deposit_summary_item_lookup,
              :all_customer_liquid_item_lookup,
              :all_customer_deposit_interest_item_lookup
            ]

  def divestment_reports(conn, params) do
    curencies = SystemSetting.list_tbl_currency()
    products = Savings.Products.list_tbl_products()
    render(conn, "divestments.html", curencies: curencies, products: products)
  end

  def divestment_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Savings.Divestments.divestment_data_report(search_params, start, length)
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


  def transaction_reports(conn, params) do
    curencies = SystemSetting.list_tbl_currency()
    products = Savings.Products.list_tbl_products()
    render(conn, "transactions.html", curencies: curencies, products: products)
  end

  def all_customer_txn_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results =
      Savings.Transactions.all_customer_txn_data_report(search_params, start, length)

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

  def fixed_deposit_reports(conn, params) do
    curencies = SystemSetting.list_tbl_currency()
    products = Savings.Products.list_tbl_products()
    render(conn, "fixed_deposits.html", curencies: curencies, products: products)
  end

  def fixed_deposit_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Savings.FixedDeposit.fixed_deposits_report(search_params, start, length)
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


  def customer_reports(conn, params) do
    curencies = SystemSetting.list_tbl_currency()
    products = Savings.Products.list_tbl_products()
    render(conn, "customer_reports.html", curencies: curencies, products: products)
  end

  def all_customer_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results =
      Savings.Transactions.all_customer_data_report(search_params, start, length)

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


  def liqudated_reports(conn, params) do
    render(conn, "liquidated_reports.html")
  end

  def all_customer_liquid_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results =
      Savings.Transactions.all_customer_liquid_data_report(search_params, start, length)

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


  def deposit_reports_interest(conn, params) do
    render(conn, "deposits_reports_interest.html")
  end

  def all_customer_deposit_interest_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results =
      Savings.Transactions.customer_data_report_deposit_interest(search_params, start, length)

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

  def deposits_reports_summury(conn, params) do
    render(conn, "deposits_reports_summury.html")
  end

  def all_customer_deposit_summary_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results = Savings.Transactions.customer_data_report_deposit_summary(search_params, start, length)
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



  def authorize_reports(conn) do
    case Phoenix.Controller.action_name(conn) do
      act
      when act in ~w(fixed_deposit_search transaction_reports transaction_search customer_reports)a ->
        {:report, :view}

      act when act in ~w(change_user_status user_logs)a ->
        {:report, :change_status}

      # act when act in ~w(index show)a -> {:user, :index}
      _ ->
        {:report, :unknown}
    end
  end

end
