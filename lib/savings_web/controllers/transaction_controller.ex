defmodule SavingsWeb.TransactionController do
  use SavingsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def all_transactions(conn, _params) do
    customer = Savings.Accounts.get_all_customer_details()
    render(conn, "all_transactions.html", customer: customer)
  end

  def fixed_deposits(conn, _params) do
    customer = Savings.Accounts.get_all_customer_details()
    render(conn, "fixed_deposits.html", customer: customer)
  end

  def full_divestment_withdraws(conn, _params) do
    customer = Savings.Accounts.get_all_customer_details()
    render(conn, "full_divestment_withdraws.html", customer: customer)
  end

  def partial_divestment_withdraws(conn, _params) do
    customer = Savings.Accounts.get_all_customer_details()
    render(conn, "partial_divestment_withdraws.html", customer: customer)
  end

  def all_withdrawals_transactions(conn, _params) do
    customer = Savings.Accounts.get_all_customer_details()
    render(conn, "all_withdrawals_transactions.html", customer: customer)
  end

  def customer_all_txn_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Savings.Transactions.get_all_clients_txn_details(search_params, start, length)
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

  def customer_all_full_withdraws_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results =
      Savings.Transactions.get_all_clients_full_divestment_withdraws(search_params, start, length)

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

  def customer_all_Withdraws_txn_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results =
      Savings.Transactions.get_all_clients_withdraws_txn_details(search_params, start, length)

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

  def customer_all_fixed_deposits_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results = Savings.Transactions.get_all_clients_fixed_deposits(search_params, start, length)

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


  def customer_all_partial_withdraws_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results =
      Savings.Transactions.get_all_clients_partial_withdraws_details(search_params, start, length)

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
end
