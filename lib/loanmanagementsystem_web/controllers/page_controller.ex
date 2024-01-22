defmodule LoanmanagementsystemWeb.PageController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Statement
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Chart_of_accounts

  @current "tbl_loans"

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def loan_statement(conn, _params) do
    customer_accounts = Chart_of_accounts.list_all_customer_accounts()
    render(conn, "loan_statement.html", customer_accounts: customer_accounts)
  end

  def loan_statementpdf_exp(conn, params) do
    process_loan_statement(conn, @current, params)
  end

  defp process_loan_statement(conn, source, params) do
    if params["idno"] == "" || params["loanid"] == ""  do
      conn
      |> put_flash(:error, "Filter by Inputting ID No and Loan Number, try again!")
      |> redirect(to: Routes.page_path(conn, :loan_statement))
    else

    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=LOAN_STATEMENT_REPORT#{Timex.today()}.csv"
      )
      |> put_resp_content_type("text/csv")
      params
      |> Map.delete("_csrf_token")
      |> reports_generators(source)
      |> Repo.all()
      |> compute_running_balance_map()
      |> LoanSavingsSystem.Workers.LoanStatement.generate(params)
      |> process_loan_statement_pdf(conn)
    end
  end

  def compute_running_balance_map(entries) do
    case entries do
      [] -> []
      entries ->
          entries = Enum.map_reduce(entries, 0, fn result, running_balance ->
          running_balance =
          case result.drcr_ind do
            "D" ->
              running_balance -  (result.total_balance - result.payment)
            "C" ->
              IO.inspect result, label: "result ----------------------------"

              case result.module do
                "DISBURSEMENT" ->
                  result.total_balance
                "INSTALLMENT DUE" ->

                  IO.inspect running_balance, label: "running_balance ----------------------------"

                  if running_balance == 0  do
                    result.total_balance - result.payment
                  else
                    running_balance - result.payment
                  end

              end
          end
          {Map.merge(result, %{runningBalance: running_balance}), running_balance}
        end)
        {map, _}= entries
        map
    end
  end


  # def compute_running_balance_map(entries) do
  #   case entries do
  #     [] -> []
  #     entries ->
  #         entries = Enum.map_reduce(entries, 0, fn result, running_balance ->
  #         running_balance =
  #           case result.drcr_ind do
  #             "D" ->
  #               running_balance -  (result.payment - result.payment)
  #             "C" ->
  #                 running_balance + result.payment
  #           end
  #         {Map.merge(result, %{runningBalance: running_balance}), running_balance}
  #       end)
  #       {map, _}= entries
  #       map
  #   end
  # end

  defp process_loan_statement_pdf(content, conn) do
      datetime = Timex.now() |> DateTime.truncate(:second) |> DateTime.to_naive() |> Timex.shift(hours: 2)
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=LOAN_STATEMENT_REPORT As at #{datetime}.pdf"
      )
      |> put_resp_content_type("text/pdf")
    send_resp(conn, 200, content)
  end

  def reports_generators(search_params, source) do
    Statement.loan_statement_generation_lookup(source, Map.put(search_params, "isearch", ""))
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

  def calculate_page_size(nil), do: 20
  def calculate_page_size(length), do: String.to_integer(length)

  def loan_statement_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Statement.loan_statement_generation_lookup(search_params, start, length)
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


end
