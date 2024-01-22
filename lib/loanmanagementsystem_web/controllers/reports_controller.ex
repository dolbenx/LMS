defmodule LoanmanagementsystemWeb.ReportsController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Core_transaction.Journal_entries
  alias Loanmanagementsystem.Chart_of_accounts
  alias Loanmanagementsystem.{Repo, Logs.UserLogs}
  alias Loanmanagementsystem.Core_transaction
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Merchants


  plug LoanmanagementsystemWeb.Plugs.Authenticate,
       [module_callback: &LoanmanagementsystemWeb.ReportsController.authorize_role/1]
       when action not in [
        :all_loans,
        :disbursed_loans,
        :pending_loans,
        :divestment_reports,
        :transaction_reports,
        :fixed_deposits_reports,
        :customer_reports,
        :balance_sheet,
        :balancesheet_lookup,
        :confirms_report_type,
        :total_entries,
        :entries,
        :search_options,
        :calculate_page_num,
        :calculate_page_size,:total_entries,
        :entries,
        :search_options,
        :calculate_page_num,
        :calculate_page_size,

        :balancesheetpdf_exp,
        :process_report_balancesheet,
        :reports_generators,

        :get_all_complete_balance_sheet,
        :balance_sheet_report_filter,
        :balance_sheet_date_filter,
        :balancesheet_report_filter,
        :balance_sheet_fund_filters,
        :process_report_balance_sheet,
        :balance_sheet_csv_report_generator,
        :query_data_final,
        :compose_report_select,
        :handle_filter,
        :isearch_filter,
        :sanitize_term,

        :balancesheet_exp_csv,
        :balancesheet_exp_excel,
        :income_statement,
        :income_statement_lookup,
        :confirms_report_type_income_statement,
        :query_data_final_income_statement,
        :compose_report_select_income_statement,
        :trial_balance,

        :trial_balance_lookup,
        :confirms_report_type_trial_balance,
        :query_data_final_trial_balance,
        :compose_report_select_trial_balance,
        :general_ledger,
        :general_ledger_lookup,
        :confirms_report_type_general_ledger,

        :compose_report_select_general_ledger,
        :compute_running_balance_map,
        :loan_statement_item_lookup,
        :confirms_loan_statement_report_type,
        :searchs_loan_statement_options,
        :export_loan_statement_pdf,
        :process_report_loan_statement,
        :process_loan_statement,
        :reports_generators_loan_statement,
        :get_all_complete_loan_statement_pdf,
        :get_all_complete_loan_statement,
        :loan_statement_report_filter,
        :loan_statement_report_filter,
        :account_listing_date_filter,
        :account_listing_counter_filter,
        :account_listing_counter_filter,
        :account_listing_customer_no,
        :account_listing_email,
        :account_listing_isearch_filter,
        :loan_statement_report_select,
        :loan_statement_report_select_on_generating_pdf,
        :historic_loan_statement_item_lookup,
        :confirms_historic_loan_statement_report_type,
        :searchs_historic_loan_statement_options,
        :historic_statement_exp_pdf,
        :process_report_historic_loan_statement,
        :process_historic_loan_statement,
        :reports_generators_historic_loan_statement,
        :get_all_complete_historic_loan_statement,
        :get_all_complete_historic_loan_statement,
        :active_loans_summary,
        :active_loans_employer,
        :active_loans_emoney,
        :active_loans_corporate,
        :active_loans_product,
        :active_loans_relationship,
        :active_loans_installment,
        :client_summary,
        :employer_collection_schedule,
        :market_collection_schedule,
        :corporate_collection_schedule,
        :offtaker_information,
        :pending_approval,
        :awaiting_disbursement,
        :loans_past_due,
        :written_off_loans,
        :balance_outstanding,
        :source_of_funds,
        :service_out_let,
        :dv_employer,
        :dv_emoney,
        :dv_corporate_buyer,
        :dv_relationship_manager,
        :loan_classification,
        :consultant_transaction_detailed,
        :consultant_transaction_summary,
        :performance_summary,
        :loan_aiging_report,
        :aiging_summary,
        :clossed_loans,
        :clossed_loan_summary_sol,
        :clossed_loan_summary_rm,
        :inactive_clients,
        :mfi_progress,
        :funds_movement,
        :collection_summary,
        :active_loans_employer_lookup,
        :active_loans_product_lookup,
        :active_loans_emoney_lookup,
        :loan_pending_approval_lookup,
        :loan_offtaker_lookup,
        :loan_client_summary_lookup,
        :loan_waiting_disbursement_lookup,
        :loan_sol_brunch_lookup,
        :loan_balance_lookup,
        :loan_classification_product_lookup,
        :active_loans_dvc_employer_lookup,
        :active_loans_dvc_emoney_lookup,
        :active_loans_dvc_corporate_lookup,
        :active_loans_corporate_buyer_lookup,
        :loans_employer_collection_lookup,
        :loans_corporate_buyer_collection_lookup,
        :all_corparate_disbursed_loans,
        :corparate_disbursed_loans_look_up,
        :loan_application_report,
        :loan_credit_assessment_report,
        :admin_approved_loan_awaiting_disbursement,
        :loan_aging_report_item_lookup,
        :loan_application_report_item_lookup,
        :loan_credit_assessment_item_lookup,
        :approve_loan_awaiting_disbursement_item_lookup,
        :all_overdue_repayment_loans,
        :all_due_repayment_loans,
        :admin_debtors_analysis_report,
        :debtors_analysis_report_lookup,
        :loan_book_analysis_report_lookup,
        :individual_customer_reports,
        :corperate_customer_report_lookup,
        :individual_customer_report_lookup,
        :corparate_disbursed_loans_look_up,
        :corparate_over_due_loans_look_up,
        :transaction_report_item_lookup,
        :admin_user_logs,
        :admin_loan_book_report,
        :merchants_report,
        :employers_report,
        :employerees_by_employer_report,
        :blacklisted_employerees_report,
        :defaulters_reports,
        :defaulters_report_item_lookup,
        :employers_report_item_lookup,
        :blackliast_client_report_item_lookup,
        :employers_employees_report_item_lookup

            ]

  use PipeTo.Override

  def defaulters_report_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.defaulters_report_miz(search_params, start, length)
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

  def employers_employees_report_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.employers_employees_list_report_miz(search_params, start, length)
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

  def blackliast_client_report_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.blackliast_client_report_miz(search_params, start, length)
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


  def employers_report_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.employers_report_miz(search_params, start, length)
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

  def merchants_report(conn, params) do
    render(conn, "merchants_report.html")
  end

  def employers_report(conn, params) do
    render(conn, "employers_report.html")
  end

  def employerees_by_employer_report(conn, params) do
    render(conn, "employerees_by_employer_report.html")
  end

  def blacklisted_employerees_report(conn, params) do
    render(conn, "blacklisted_employerees_report.html")
  end

  def defaulters_reports(conn, params) do
    render(conn, "defaulters_reports.html")
  end






  def all_loans(conn, _params),
    do:
      render(conn, "all_loans.html", products: Loanmanagementsystem.Products.list_tbl_products())

  def disbursed_loans(conn, _params),
    do:
      render(conn, "disbursed_loan.html",
        loans: Loanmanagementsystem.Services.Services.admin_get_disbursed_loans()
      )

  def pending_loans(conn, _params),
    do:
      render(conn, "pending_loans.html",
        products:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "PENDING"))
      )

  def divestment_reports(conn, params) do
    IO.inspect("#############")
    IO.inspect(params)
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    curencies = Loanmanagementsystem.Maintenance.list_tbl_currency()
    products = Loanmanagementsystem.Products.list_tbl_products()
    i1 = 1

    reports = nil

    render(conn, "divestment_reports.html",
      reports: reports,
      curencies: curencies,
      branches: branches,
      params: params,
      products: products,
      i1: i1
    )
  end

  def admin_user_logs(conn, _params) do
    render(conn, "admin_user_logs.html")
  end


  def admin_debtors_analysis_report(conn, _params) do
    render(conn, "admin_debtors_analysis_report.html")
  end


  def admin_loan_book_report(conn, _params) do
    render(conn, "admin_loan_book_report.html")
  end

  def transaction_reports(conn, params) do
    IO.inspect("#############")
    IO.inspect(params)
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    curencies = Loanmanagementsystem.Maintenance.list_tbl_currency()
    products = Loanmanagementsystem.Products.list_tbl_products()
    i1 = 1

    reports = nil

    render(conn, "transaction_reports.html",
      reports: reports,
      curencies: curencies,
      branches: branches,
      params: params,
      products: products,
      i1: i1
    )
  end

  def fixed_deposits_reports(conn, params) do
    IO.inspect("#############")
    IO.inspect(params)
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    curencies = Loanmanagementsystem.Maintenance.list_tbl_currency()
    products = Loanmanagementsystem.Products.list_tbl_products()
    i1 = 1

    reports = nil

    render(conn, "fixed_deposits_reports.html",
      reports: reports,
      curencies: curencies,
      branches: branches,
      params: params,
      products: products,
      i1: i1
    )
  end

  def customer_reports(conn, params) do
    IO.inspect("#############")
    IO.inspect(params)
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    curencies = Loanmanagementsystem.Maintenance.list_tbl_currency()
    products = Loanmanagementsystem.Products.list_tbl_products()
    i1 = 1

    reports = nil

    render(conn, "customer_reports.html",
      reports: reports,
      curencies: curencies,
      branches: branches,
      params: params,
      products: products,
      i1: i1
    )
  end

  def individual_customer_reports(conn, params) do
    IO.inspect("#############")
    IO.inspect(params)
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    curencies = Loanmanagementsystem.Maintenance.list_tbl_currency()
    products = Loanmanagementsystem.Products.list_tbl_products()
    i1 = 1

    reports = nil

    render(conn, "individual_customer_reports.html",
      reports: reports,
      curencies: curencies,
      branches: branches,
      params: params,
      products: products,
      i1: i1
    )
  end

  # ------------------------------------------------------------Balance Sheet
  def balance_sheet(conn, _params),
    do:
      render(conn, "balance_sheet.html",
        general_ledger_accounts: Chart_of_accounts.list_tbl_chart_of_accounts_leaf(),
        total_balances: Core_transaction.get_balancesheet_aggreated_balances()
      )

  @current "tbl_trans_log"
  def balancesheet_lookup(conn, params) do
    {draw, start, length, search_params} = searchs_options(params)
    lookup = confirms_report_type(conn.request_path)

    results = lookup.(search_params, start, length)

    totals_entries = totals_entries(results)

    results = %{
      draw: draw,
      recordsTotal: totals_entries,
      recordsFiltered: totals_entries,
      data: entriess(results)
    }

    json(conn, results)
  end

  defp confirms_report_type("/balance/sheet/report"), do: &query_data_final/3

  def totals_entries(%{total_entries: total_entries}), do: total_entries
  def totals_entries(_), do: 0

  def entriess(%{entries: entries}), do: entries
  def entriess(_), do: []

  def searchs_options(params) do
    length = calculates_page_size(params["length"])
    page = calculates_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def calculates_page_num(nil, _), do: 1

  def calculates_page_num(start, length) do
    start = String.to_integer(start)
    round(start / length + 1)
  end

  def calculates_page_size(nil), do: 10
  def calculates_page_size(length), do: String.to_integer(length)

  def balancesheetpdf_exp(conn, params) do
    process_report_balancesheet(conn, @current, params)
  end

  defp process_report_balancesheet(conn, source, params) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=BALANCE_SHEET_#{Timex.today()}.csv"
      )
      |> put_resp_content_type("text/csv")

    params
    |> Map.delete("_csrf_token")
    |> reports_generators(source)
    |> Repo.all()
    # |> map(params)
    |> LoanSavingsSystem.Workers.BalanceSheet.generate()
    |> process_balance_sheet_pdf(conn)
  end

  # def map(response, search_params) do
  #   response
  #   |> case do
  #     [] -> []
  #       response ->
  #         result = fn resopnse  ->
  #           Enum.map(resopnse, &Map.merge(&1, %{local_total_credits: local_total_credits(search_params),
  #           local_total_debts: local_total_debts(search_params), foreign_total_debts: foreign_total_debts(search_params), foreign_total_credits: foreign_total_credits(search_params)}))
  #         end
  #         result.(response)
  #   end
  # end

  defp process_balance_sheet_pdf(content, conn) do
    datetime =
      Timex.now() |> DateTime.truncate(:second) |> DateTime.to_naive() |> Timex.shift(hours: 2)

    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename= BALANCE SHEET As at #{datetime}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

  def reports_generators(search_params, source) do
    get_all_complete_balance_sheet(source, Map.put(search_params, "isearch", ""))
  end

  #########################  BALANCE SHEET REPORT ####################################
  def get_all_complete_balance_sheet(search_params, page, size) do
    Journal_entries
    # |> balance_sheet_report_filter(search_params)
    # |> balance_sheet_date_filter(search_params)
    |> order_by(desc: :trans_date)
    # |> balancesheet_report_filter(search_params)
    |> where([a], a.account_category != "Income")
    |> where([a], a.account_category != "Expenses")
    # |> compose_report_select(search_params)
    |> Repo.paginate(page: page, page_size: size)
  end

  def get_all_complete_balance_sheet(_source, search_params) do
    Journal_entries
    # |> balance_sheet_report_filter(search_params)
    # |> balance_sheet_date_filter(search_params)
    |> order_by(desc: :trans_date)
    # |> balancesheet_report_filter(search_params)
    |> where([a], a.account_category != "Income")
    |> where([a], a.account_category != "Expenses")

    # |> compose_report_select(search_params)
  end

  defp balance_sheet_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> balance_sheet_date_filter(search_params)
    |> balance_sheet_fund_filters(search_params)
  end

  defp balance_sheet_date_filter(query, %{"start_date" => start_date})
       when start_date == "" or is_nil(start_date),
       do: query

  defp balance_sheet_date_filter(query, %{"start_date" => start_date}) do
    query
    |> where(
      [a],
      fragment("CAST(? AS DATE) <= ?", a.trans_date, ^start_date)
    )
  end

  defp balancesheet_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> balancsheet_date_filter(search_params)
  end

  defp balancesheet_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    isearch_filter(query, search_term)
  end

  defp balancsheet_date_filter(query, %{"start_date" => start_date})
       when start_date == "" or is_nil(start_date),
       do: query

  defp balancsheet_date_filter(query, %{"start_date" => start_date}) do
    query
    |> where(
      [a],
      fragment("CAST(? AS DATE) <= ?", a.trans_date, ^start_date)
    )
  end

  defp balance_sheet_fund_filters(query, %{"fund" => fund})
       when fund == "" or is_nil(fund),
       do: query

  defp balance_sheet_fund_filters(query, %{"fund" => fund}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.fund, ^"%#{fund}%"))
  end

  @current "tbl_trans_log"
  @headers ~w(
    gl_code account_category currency ledger_name fcy_dr_bal fcy_cr_bal lyc_dr_bal lyc_cr_bal
  )a

  defp process_report_balance_sheet(_conn, source, params) do
    params
    |> Map.delete("_csrf_token")
    |> balance_sheet_csv_report_generator(source)
    |> Repo.all()
  end

  def balance_sheet_csv_report_generator(search_params, source) do
    get_all_complete_balance_sheet(source, Map.put(search_params, "isearch", ""))
  end

  def query_data_final(search_params, page, size) do
    Journal_entries
    |> where([a], a.account_category != "Income")
    |> where([a], a.account_category != "Expenses")
    |> where([a], a.process_status == "APPROVED")
    |> where([a], a.batch_status == "APPROVED")
    |> order_by([a], a.trn_dt)
    |> group_by([a], [
      a.id,
      a.account_no,
      a.account_category,
      a.account_name,
      a.product,
      a.currency,
      a.trn_dt,
      a.drcr_ind
    ])
    |> compose_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def compose_report_select(query) do
    query
    |> select([a], %{
      id: a.id,
      account_no: a.account_no,
      account_category: a.account_category,
      account_name: a.account_name,
      product: a.product,
      currency: a.currency,
      trn_dt: a.trn_dt,
      drcr_ind: a.drcr_ind,
      dr_amount:
        fragment(
          "select case when  drcr_ind = ? then sum(lcy_amount + fcy_amount) else '0' end from tbl_trans_log where drcr_ind = 'D'  and account_no = ? and trn_dt = ? and id = ? group by drcr_ind, account_no, trn_dt",
          a.drcr_ind,
          a.account_no,
          a.trn_dt,
          a.id
        ),
      cr_amount:
        fragment(
          "select case when  drcr_ind = ? then sum(lcy_amount + fcy_amount) else '0' end  from tbl_trans_log where drcr_ind = 'C' and account_no = ? and trn_dt = ?  and id = ? group by drcr_ind, account_no, trn_dt",
          a.drcr_ind,
          a.account_no,
          a.trn_dt,
          a.id
        )
    })
  end

  defp handle_filter(query, params) do
    Enum.reduce(params, query, fn
      {"isearch", value}, query when byte_size(value) > 0 ->
        isearch_filter(query, sanitize_term(value))

      {"fund", value}, query when byte_size(value) > 0 ->
        where(query, [a], fragment("lower(?) LIKE lower(?)", a.fund, ^value))

      {"start_date", value}, query when byte_size(value) > 0 ->
        where(query, [a], fragment("CAST(? AS DATE) <= ?", a.trans_date, ^value))

      {_, _}, query ->
        query
    end)
  end

  defp isearch_filter(query, search_term) do
    where(
      query,
      [a],
      fragment("lower(?) LIKE lower(?)", a.gl_code, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.account_category, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.fund, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.fcy_cr_bal, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.fcy_dr_bal, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.lyc_cr_bal, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.lyc_dr_bal, ^search_term)
    )
  end

  defp sanitize_term(term), do: "%#{String.replace(term, "%", "\\%")}%"

  ################################# EXPORT TO CSV #####################################################################
  @current "tbl_trans_log"
  @headers ~w(
     gl_code account_category ledger_name fcy_dr_bal fcy_cr_bal lyc_dr_bal lyc_cr_bal
  )a

  def balancesheet_exp_csv(conn, params) do
    datetime =
      Timex.now() |> DateTime.truncate(:second) |> DateTime.to_naive() |> Timex.shift(hours: 2)

    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=BALANCE_SHEET As at #{datetime}.csv"
      )
      |> put_resp_content_type("text/csv")

    csv_content =
      conn
      |> process_report_balance_sheet(@current, params)
      |> CSV.encode(headers: @headers)
      |> Enum.to_list()
      |> to_string

    send_resp(conn, 200, csv_content)
  end

  ############################## BALANCESHEET EXCEL FORMAT ###########################
  def balancesheet_exp_excel(conn, params) do
    datetime =
      Timex.now() |> DateTime.truncate(:second) |> DateTime.to_naive() |> Timex.shift(hours: 2)

    entries = process_report_balance_sheet(conn, @current, params)

    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=BALANCE_SHEET As at #{datetime}.xlsx"
    )
    |> render("report.xlsx", %{entries: entries})
  end

  # --------------------------------------------------Income Statement
  def income_statement(conn, _params),
    do:
      render(conn, "income_statement.html",
        general_ledger_accounts: Chart_of_accounts.list_tbl_chart_of_accounts_leaf(),
        total_balances: Core_transaction.get_incomestatement_aggreated_balances()
      )

  @current "tbl_trans_log"
  def income_statement_lookup(conn, params) do
    {draw, start, length, search_params} = searchs_options(params)
    lookup = confirms_report_type_income_statement(conn.request_path)

    results = lookup.(search_params, start, length)

    totals_entries = totals_entries(results)

    results = %{
      draw: draw,
      recordsTotal: totals_entries,
      recordsFiltered: totals_entries,
      data: entriess(results)
    }

    json(conn, results)
  end

  defp confirms_report_type_income_statement("/income/statement/report"),
    do: &query_data_final_income_statement/3

  def query_data_final_income_statement(search_params, page, size) do
    Journal_entries
    |> where([a], a.account_category != "Assets")
    |> where([a], a.account_category != "Liabilities")
    |> where([a], a.process_status == "APPROVED")
    |> where([a], a.batch_status == "APPROVED")
    |> order_by([a], a.trn_dt)
    |> group_by([a], [
      a.id,
      a.account_no,
      a.account_category,
      a.account_name,
      a.product,
      a.currency,
      a.trn_dt,
      a.drcr_ind
    ])
    |> compose_report_select_income_statement()
    |> Repo.paginate(page: page, page_size: size)
  end

  def compose_report_select_income_statement(query) do
    query
    |> select([a], %{
      id: a.id,
      account_no: a.account_no,
      account_category: a.account_category,
      account_name: a.account_name,
      product: a.product,
      currency: a.currency,
      trn_dt: a.trn_dt,
      drcr_ind: a.drcr_ind,
      dr_amount:
        fragment(
          "select case when  drcr_ind = ? then sum(lcy_amount + fcy_amount) else '0' end from tbl_trans_log where drcr_ind = 'D'  and account_no = ? and trn_dt = ? and id = ?  group by drcr_ind, account_no, trn_dt",
          a.drcr_ind,
          a.account_no,
          a.trn_dt,
          a.id
        ),
      cr_amount:
        fragment(
          "select case when  drcr_ind = ? then sum(lcy_amount + fcy_amount) else '0' end  from tbl_trans_log where drcr_ind = 'C' and account_no = ? and trn_dt = ?  and id = ? group by drcr_ind, account_no, trn_dt",
          a.drcr_ind,
          a.account_no,
          a.trn_dt,
          a.id
        )
    })
  end

  # ------------------------------------------------------------ Trial Balance
  def trial_balance(conn, _params),
    do:
      render(conn, "trial_balance.html",
        general_ledger_accounts: Chart_of_accounts.list_tbl_chart_of_accounts_leaf(),
        total_balances: Core_transaction.get_trialbalance_aggreated_balances()
      )

  @current "tbl_trans_log"
  def trial_balance_lookup(conn, params) do
    {draw, start, length, search_params} = searchs_options(params)
    lookup = confirms_report_type_trial_balance(conn.request_path)

    results = lookup.(search_params, start, length)

    totals_entries = totals_entries(results)

    results = %{
      draw: draw,
      recordsTotal: totals_entries,
      recordsFiltered: totals_entries,
      data: entriess(results)
    }

    json(conn, results)
  end

  defp confirms_report_type_trial_balance("/trial/balance/report"),
    do: &query_data_final_trial_balance/3

  def query_data_final_trial_balance(search_params, page, size) do
    Journal_entries
    |> where([a], a.process_status == "APPROVED")
    |> where([a], a.batch_status == "APPROVED")
    |> order_by([a], a.trn_dt)
    |> group_by([a], [
      a.id,
      a.account_no,
      a.account_category,
      a.account_name,
      a.product,
      a.currency,
      a.trn_dt,
      a.drcr_ind
    ])
    |> compose_report_select_trial_balance()
    |> Repo.paginate(page: page, page_size: size)
  end

  def query_data_final_trial_balance(page, size) do
    Journal_entries
    |> where([a], a.process_status == "APPROVED")
    |> where([a], a.batch_status == "APPROVED")
    |> order_by([a], a.trn_dt)
    |> group_by([a], [
      a.id,
      a.account_no,
      a.account_category,
      a.account_name,
      a.product,
      a.currency,
      a.trn_dt,
      a.drcr_ind
    ])
    |> compose_report_select_trial_balance()
    |> Repo.paginate(page: page, page_size: size)
  end

  def compose_report_select_trial_balance(query) do
    query
    |> select([a], %{
      id: a.id,
      account_no: a.account_no,
      account_category: a.account_category,
      account_name: a.account_name,
      product: a.product,
      currency: a.currency,
      trn_dt: a.trn_dt,
      drcr_ind: a.drcr_ind,
      dr_amount:
        fragment(
          "select case when  drcr_ind = ? then sum(lcy_amount + fcy_amount) else '0' end from tbl_trans_log where drcr_ind = 'D'  and account_no = ? and trn_dt = ? and id = ? group by drcr_ind, account_no, trn_dt",
          a.drcr_ind,
          a.account_no,
          a.trn_dt,
          a.id
        ),
      cr_amount:
        fragment(
          "select case when  drcr_ind = ? then sum(lcy_amount + fcy_amount) else '0' end  from tbl_trans_log where drcr_ind = 'C' and account_no = ? and trn_dt = ?  and id = ? group by drcr_ind, account_no, trn_dt",
          a.drcr_ind,
          a.account_no,
          a.trn_dt,
          a.id
        )
    })
  end

  # ------------------------------------------------------------ General ledger
  def general_ledger(conn, _params),
    do:
      render(conn, "general_ledger.html",
        general_ledger_accounts: Chart_of_accounts.list_tbl_chart_of_accounts_leaf()
      )

  @current "tbl_trans_log"
  def general_ledger_lookup(conn, params) do
    {draw, start, length, search_params} = searchs_options(params)
    lookup = confirms_report_type_general_ledger(conn.request_path)

    results = lookup.(search_params, start, length)

    totals_entries = totals_entries(results)

    results = %{
      draw: draw,
      recordsTotal: totals_entries,
      recordsFiltered: totals_entries,
      data: entriess(results)
    }

    json(conn, results)
  end

  defp confirms_report_type_general_ledger("/general/ledger/report"),
    do: &query_data_final_general_ledger/3

  def query_data_final_general_ledger(search_params, page, size) do
    Journal_entries
    |> where([a], a.process_status == "APPROVED")
    |> where([a], a.batch_status == "APPROVED")
    |> order_by([a], a.trn_dt)
    |> group_by([a], [
      a.id,
      a.narration,
      a.account_no,
      a.account_category,
      a.account_name,
      a.product,
      a.currency,
      a.trn_dt,
      a.drcr_ind
    ])
    |> compose_report_select_general_ledger()
    |> Repo.paginate(page: page, page_size: size)
    |> compute_running_balance_map()
  end

  def compose_report_select_general_ledger(query) do
    query
    |> select([a], %{
      id: a.id,
      account_no: a.account_no,
      account_category: a.account_category,
      account_name: a.account_name,
      product: a.product,
      currency: a.currency,
      trn_dt: a.trn_dt,
      narration: a.narration,
      drcr_ind: a.drcr_ind,
      dr_amount:
        fragment(
          "select case when  drcr_ind = ? then sum(lcy_amount + fcy_amount) else '0' end from tbl_trans_log where drcr_ind = 'D'  and account_no = ? and trn_dt = ? and id = ? group by drcr_ind, account_no, trn_dt",
          a.drcr_ind,
          a.account_no,
          a.trn_dt,
          a.id
        ),
      cr_amount:
        fragment(
          "select case when  drcr_ind = ? then sum(lcy_amount + fcy_amount) else '0' end  from tbl_trans_log where drcr_ind = 'C' and account_no = ? and trn_dt = ?  and id = ? group by drcr_ind, account_no, trn_dt",
          a.drcr_ind,
          a.account_no,
          a.trn_dt,
          a.id
        )
    })
  end


   def compute_running_balance_map(map) do
    map
    |> (fn %{entries: entries} = results ->
    {formatted_entries, _total_balance} = Enum.map_reduce(entries, 0, fn result, running_balance ->
       running_balance = if(running_balance == 0, do: if result.drcr_ind == "D" do  result.dr_amount else result.cr_amount end, else: running_balance)
       running_balance =
        case result.drcr_ind do
          "D" ->
            if Journal_entries.first(1).id == result.id  do
               result.dr_amount
            else
              running_balance - result.dr_amount
            end
          "C" ->
            if Journal_entries.first(1).id == result.id  do
              result.cr_amount
            else
            running_balance  +  result.cr_amount
            end
        end
    {Map.merge(result, %{runningBalance: running_balance}), running_balance}
    end)
    %{results | entries: formatted_entries }
    end).()
    end

  # def compute_running_balance_map(map) do
  #   map
  #   |> (fn %{entries: entries} = results ->
  #   {formatted_entries, _total_balance} = Enum.map_reduce(entries, 0, fn result, running_balance ->
  #       running_balance = if(running_balance == 0, do: if result.drcr_ind == "D" do  result.dr_amount else result.cr_amount end, else: running_balance)

  #   running_balance =
  #       case result.drcr_ind do
  #         "D" ->
  #           IO.inspect running_balance, label: "running_balance D *********************************"

  #           running_balance - result.dr_amount

  #         "C" ->
  #           IO.inspect running_balance, label: "running_balance C *********************************"

  #           running_balance  +  result.cr_amount

  #       end
  #   {Map.merge(result, %{runningBalance: running_balance}), running_balance}
  #   end)
  #   %{results | entries: formatted_entries }
  #   end).()
  #   end


  @current "tbl_loans"
  def loan_statement_item_lookup(conn, params) do
    user_id = conn.assigns.user.id
    {draw, start, length, search_params} = searchs_loan_statement_options(params)
    lookup = confirms_loan_statement_report_type(conn.request_path)

    results = lookup.(search_params, start, length)

    totals_entries = totals_entries(results)

    results = %{
      draw: draw,
      recordsTotal: totals_entries,
      recordsFiltered: totals_entries,
      data: entriess(results)
    }

    json(conn, results)
  end

  defp confirms_loan_statement_report_type("/Individual/Mini-Statements"),
    do: &get_all_complete_loan_statement/3

  def searchs_loan_statement_options(params) do
    length = calculates_page_size(params["length"])
    page = calculates_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def export_loan_statement_pdf(conn, params) do
    process_report_loan_statement(conn, @current, params)
  end

  defp process_report_loan_statement(conn, source, params) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=LOAN_STATEMENT#{Timex.today()}.csv"
      )
      |> put_resp_content_type("text/csv")

    params
    |> Map.delete("_csrf_token")
    |> reports_generators_loan_statement(source)
    |> Repo.all()
    |> LoanSavingsSystem.Workers.LoanStatement.generate()
    |> process_loan_statement(conn)
  end

  defp process_loan_statement(content, conn) do
    datetime =
      Timex.now() |> DateTime.truncate(:second) |> DateTime.to_naive() |> Timex.shift(hours: 2)

    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=LOAN_STATEMENT As at #{datetime}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

  def reports_generators_loan_statement(search_params, source) do
    get_all_complete_loan_statement_pdf(source, Map.put(search_params, "isearch", ""))
  end

  def get_all_complete_loan_statement_pdf(_source, search_params) do
    loan_id = String.to_integer(search_params["id"])

    Loans
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.customer_id == u.userId)
    |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
    |> join(:left, [a, u, p], t in "tbl_loan_transaction", on: a.id == t.loan_id)
    |> where([a, u, p, t], t.loan_id == ^loan_id and a.customer_id == u.userId)
    |> order_by(desc: :inserted_at)
    |> loan_statement_report_select_on_generating_pdf()
  end

  def get_all_complete_loan_statement(search_params, page, size) do
    Loans
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.customer_id == u.userId)
    |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
    |> where([a, u, p], a.customer_id == u.userId)
    # |> loan_statement_report_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> loan_statement_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  # CSV Report
  # def get_all_complete_loan_statement(_source, search_params) do
  #   Loans
  #   |> join(:left, [a], u in "tbl_user_bio_data", on: a.customer_id == u.userId)
  #   |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
  #   |> where([a, u, p], a.customer_id == u.userId)
  #     # |> loan_statement_report_filter(search_params)
  #     |> order_by(desc: :inserted_at)
  #     |> loan_statement_report_select()
  # end

  defp loan_statement_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> account_listing_date_filter(search_params)
    |> account_listing_counter_filter(search_params)
    |> account_listing_customer_no(search_params)
    |> account_listing_email(search_params)
  end

  defp loan_statement_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    account_listing_isearch_filter(query, search_term)
  end

  defp account_listing_date_filter(query, %{"start_date" => start_date, "end_date" => end_date})
       when start_date == "" or is_nil(start_date) or end_date == "" or is_nil(end_date),
       do: query

  defp account_listing_date_filter(query, %{"start_date" => start_date, "end_date" => end_date}) do
    query
    |> where(
      [a],
      fragment("CAST(? AS DATE) >= ?", a.inserted_at, ^start_date) and
        fragment("CAST(? AS DATE) <= ?", a.inserted_at, ^end_date)
    )
  end

  defp account_listing_counter_filter(query, %{"fund_name" => fund_name})
       when fund_name == "" or is_nil(fund_name),
       do: query

  defp account_listing_counter_filter(query, %{"fund_name" => fund_name}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.fund_name, ^"%#{fund_name}%"))
  end

  # ------------------------------------------
  defp account_listing_customer_no(query, %{"customer_no" => customer_no})
       when customer_no == "" or is_nil(customer_no),
       do: query

  defp account_listing_customer_no(query, %{"customer_no" => customer_no}) do
    where(query, [a, u], fragment("lower(?) LIKE lower(?)", u.customer_no, ^"%#{customer_no}%"))
  end

  # ----------------------------------------------
  defp account_listing_email(query, %{"email" => email})
       when email == "" or is_nil(email),
       do: query

  defp account_listing_email(query, %{"email" => email}) do
    where(query, [a, u], fragment("lower(?) LIKE lower(?)", u.email, ^"%#{email}%"))
  end

  defp account_listing_isearch_filter(query, search_term) do
    query
    |> where(
      [a, u, r],
      fragment("lower(?) LIKE lower(?)", a.ac_no, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.ac_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", u.linked_account_category, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.unit_price, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.fund_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.currency, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.available_bal, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.current_units, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.market_value, ^search_term)
    )
  end

  defp loan_statement_report_select(query) do
    query
    |> select([a, u, p], %{
      sn: a.id,
      id: a.id,
      customer_id: a.customer_id,
      first_name: u.firstName,
      last_name: u.lastName,
      phone: u.mobileNumber,
      email_address: u.emailAddress,
      loan_status: a.loan_status,
      company_id: a.company_id,
      principal_amount: a.principal_amount,
      product_name: p.name,
      product_id: p.id,
      currency: p.currencyName,
      principal_amount: a.principal_amount,
      interest_outstanding_derived: a.interest_outstanding_derived,
      total_principal_repaid: a.total_principal_repaid,
      principal_outstanding_derived: a.principal_outstanding_derived,
      repayment_type: a.repayment_type,
      approvedon_date: a.approvedon_date,
      closedon_date: a.closedon_date,
      repayment_amount: a.repayment_amount,
      balance: a.balance,
      interest_amount: a.interest_amount
    })
  end

  defp loan_statement_report_select_on_generating_pdf(query) do
    query
    |> select([a, u, p, t], %{
      sn: a.id,
      id: a.id,
      customer_id: a.customer_id,
      first_name: u.firstName,
      last_name: u.lastName,
      phone: u.mobileNumber,
      email_address: u.emailAddress,
      loan_status: a.loan_status,
      company_id: a.company_id,
      principal_amount: a.principal_amount,
      product_name: p.name,
      product_id: p.id,
      currency: p.currencyName,
      principal_amount: a.principal_amount,
      interest_outstanding_derived: a.interest_outstanding_derived,
      total_principal_repaid: a.total_principal_repaid,
      principal_outstanding_derived: a.principal_outstanding_derived,
      repayment_type: a.repayment_type,
      approvedon_date: a.approvedon_date,
      closedon_date: a.closedon_date,
      repayment_amount: a.repayment_amount,
      balance: a.balance,
      interest_amount: a.interest_amount,
      amount: t.amount,
      transaction_date: t.transaction_date,
      mno_mobile_no: t.mno_mobile_no,
      bank_account_no: t.bank_account_no,
      narration: t.narration
    })
  end

  # Historic Loan Statement

  @current "tbl_loans"
  def historic_loan_statement_item_lookup(conn, params) do
    {draw, start, length, search_params} = searchs_historic_loan_statement_options(params)
    lookup = confirms_historic_loan_statement_report_type(conn.request_path)

    results = lookup.(search_params, start, length)

    totals_entries = totals_entries(results)

    results = %{
      draw: draw,
      recordsTotal: totals_entries,
      recordsFiltered: totals_entries,
      data: entriess(results)
    }

    json(conn, results)
  end

  defp confirms_historic_loan_statement_report_type("/Individual/Historic-Statements"),
    do: &get_all_complete_historic_loan_statement/3

  def searchs_historic_loan_statement_options(params) do
    length = calculates_page_size(params["length"])
    page = calculates_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def historic_statement_exp_pdf(conn, params) do
    process_report_historic_loan_statement(conn, @current, params)
  end

  defp process_report_historic_loan_statement(conn, source, params) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=HISTORIC_LOAN_STATEMENT#{Timex.today()}.csv"
      )
      |> put_resp_content_type("text/csv")

    params
    |> Map.delete("_csrf_token")
    |> reports_generators_historic_loan_statement(source)
    |> Repo.all()
    |> FundsMgt.Workers.Listing.generate()
    |> process_historic_loan_statement(conn)
  end

  defp process_historic_loan_statement(content, conn) do
    datetime =
      Timex.now() |> DateTime.truncate(:second) |> DateTime.to_naive() |> Timex.shift(hours: 2)

    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=HISTORIC_LOAN_STATEMENT As at #{datetime}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

  def reports_generators_historic_loan_statement(search_params, source) do
    get_all_complete_historic_loan_statement(source, Map.put(search_params, "isearch", ""))
  end

  def get_all_complete_historic_loan_statement(search_params, page, size) do
    Loans
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.id == u.userId)
    |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
    |> where([a], a.loan_status == "ARCHIVED")
    # |> loan_statement_report_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> loan_statement_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  # CSV Report
  def get_all_complete_historic_loan_statement(_source, search_params) do
    Loans
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.id == u.userId)
    |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
    |> where([a], a.loan_status == "ARCHIVED")
    # |> loan_statement_report_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> loan_statement_report_select()
  end

  defp loan_statement_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> account_listing_date_filter(search_params)
    |> account_listing_counter_filter(search_params)
    |> account_listing_customer_no(search_params)
    |> account_listing_email(search_params)
  end

  defp loan_statement_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    account_listing_isearch_filter(query, search_term)
  end

  defp account_listing_date_filter(query, %{"start_date" => start_date, "end_date" => end_date})
       when start_date == "" or is_nil(start_date) or end_date == "" or is_nil(end_date),
       do: query

  defp account_listing_date_filter(query, %{"start_date" => start_date, "end_date" => end_date}) do
    query
    |> where(
      [a],
      fragment("CAST(? AS DATE) >= ?", a.inserted_at, ^start_date) and
        fragment("CAST(? AS DATE) <= ?", a.inserted_at, ^end_date)
    )
  end

  defp account_listing_counter_filter(query, %{"fund_name" => fund_name})
       when fund_name == "" or is_nil(fund_name),
       do: query

  defp account_listing_counter_filter(query, %{"fund_name" => fund_name}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.fund_name, ^"%#{fund_name}%"))
  end

  # ------------------------------------------
  defp account_listing_customer_no(query, %{"customer_no" => customer_no})
       when customer_no == "" or is_nil(customer_no),
       do: query

  defp account_listing_customer_no(query, %{"customer_no" => customer_no}) do
    where(query, [a, u], fragment("lower(?) LIKE lower(?)", u.customer_no, ^"%#{customer_no}%"))
  end

  # ----------------------------------------------
  defp account_listing_email(query, %{"email" => email})
       when email == "" or is_nil(email),
       do: query

  defp account_listing_email(query, %{"email" => email}) do
    where(query, [a, u], fragment("lower(?) LIKE lower(?)", u.email, ^"%#{email}%"))
  end

  defp account_listing_isearch_filter(query, search_term) do
    query
    |> where(
      [a, u, r],
      fragment("lower(?) LIKE lower(?)", a.ac_no, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.ac_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", u.linked_account_category, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.unit_price, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.fund_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.currency, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.available_bal, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.current_units, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.market_value, ^search_term)
    )
  end

  def active_loans_summary(conn, _params) do
    branch = Loanmanagementsystem.Maintenance.list_tbl_branch()
    render(conn, "active_loans_summary.html", branch: branch)
  end

  def active_loans_employer(conn, _params) do
    role_type = Loanmanagementsystem.Accounts.list_tbl_user_roles()
    render(conn, "active_loans_employer.html", role_type: role_type)
  end

  def active_loans_emoney(conn, _params) do
    company = Loanmanagementsystem.Merchants.list_tbl_merchant()
    render(conn, "active_loans_emoney.html", company: company)
  end

  def active_loans_corporate(conn, _params) do

    product = Loanmanagementsystem.Products.list_tbl_products()

    render(conn, "active_loans_corporate.html", product: product)
  end

  def active_loans_product(conn, _params) do
    loan_product = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "active_loans_product.html", loan_product: loan_product)
  end

  def active_loans_relationship(conn, _params) do
    render(conn, "active_loans_relationship.html")
  end

  def active_loans_installment(conn, _params) do
    render(conn, "active_loans_installment.html")
  end

  def client_summary(conn, _params) do
    render(conn, "client_summary.html")
  end

  def employer_collection_schedule(conn, _params) do
    product = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "employer_collection_schedule.html", product: product)
  end

  def market_collection_schedule(conn, _params) do
    render(conn, "market_collection_schedule.html")
  end

  def corporate_collection_schedule(conn, _params) do
    render(conn, "corporate_collection_schedule.html")
  end

  def offtaker_information(conn, _params) do
    render(conn, "off_taker_information.html")
  end

  def pending_approval(conn, _params) do
    product = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "pending_approval.html", product: product)
  end

  def awaiting_disbursement(conn, _params) do
    product = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "awaiting_disbursement.html", product: product)
  end

  def loans_past_due(conn, _params) do
    render(conn, "loans_past_due.html")
  end

  def written_off_loans(conn, _params) do
    render(conn, "written_off_loans.html")
  end

  def balance_outstanding(conn, _params) do
    product = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "balance_outstanding.html", product: product)
  end

  def source_of_funds(conn, _params) do
    render(conn, "source_of_funds.html")
  end

  def service_out_let(conn, _params) do
    render(conn, "service_out_let.html")
  end

  def dv_employer(conn, _params) do
    product = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "dv_employer.html", product: product)
  end

  def dv_emoney(conn, _params) do
    product = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "dv_emoney.html", product: product)
  end

  def dv_corporate_buyer(conn, _params) do
    product = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "dv_corporate_buyer.html", product: product)
  end

  def dv_relationship_manager(conn, _params) do
    render(conn, "dv_relationship_manager.html")
  end

  def loan_classification(conn, _params) do
    product = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "loan_classification.html", product: product)
  end
  def consultant_transaction_detailed(conn, _params) do
    render(conn, "consultant_transaction_detailed.html")
  end
  def consultant_transaction_summary(conn, _params) do
    render(conn, "dv_relationship_manager.html")
  end
  def performance_summary(conn, _params) do
    render(conn, "performance_summary.html")
  end
  def loan_aiging_report(conn, _params) do
    render(conn, "loan_aiging_report.html")
  end

  def loan_application_report(conn, _params) do
    render(conn, "loan_application_report.html")
  end

  def loan_credit_assessment_report(conn, _params) do
    render(conn, "loan_credit_assessment_report.html")
  end

  def admin_approved_loan_awaiting_disbursement(conn, _params) do
    render(conn, "admin_approved_loan_awaiting_disbursement.html")
  end

  def aiging_summary(conn, _params) do
    render(conn, "aiging_summary.html")
  end
  def clossed_loans(conn, _params) do
    render(conn, "clossed_loans.html")
  end
  def clossed_loan_summary_sol(conn, _params) do
    render(conn, "clossed_loan_summary_sol.html")
  end
  def clossed_loan_summary_rm(conn, _params) do
    render(conn, "clossed_loan_summary_rm.html")
  end

  def inactive_clients(conn, _params) do
    render(conn, "inactive_clients.html")
  end
  def mfi_progress(conn, _params) do
    render(conn, "mfi_progress.html")
  end
  def funds_movement(conn, _params) do
    render(conn, "funds_movement.html")
  end
  def collection_summary(conn, _params) do
    render(conn, "collection_summary.html")
  end

  def active_loans_employer_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.active_loans_employer_lookup(search_params, start, length)
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

  def active_loans_product_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.active_loans_product_lookup(search_params, start, length)
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

  def active_loans_emoney_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.active_loans_emoney_lookup(search_params, start, length)
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

  def loan_pending_approval_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loan_pending_approval_lookup(search_params, start, length)
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

  def loan_offtaker_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loan_offtaker_lookup(search_params, start, length)
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

  def loan_client_summary_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loan_client_summary_lookup(search_params, start, length)
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

  def loan_waiting_disbursement_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loan_waiting_disbursement_lookup(search_params, start, length)
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

  def loan_sol_brunch_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loan_sol_brunch_lookup(search_params, start, length)
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

  def loan_balance_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loan_balance_lookup(search_params, start, length)
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

  def loan_classification_product_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loan_classification_product_lookup(search_params, start, length)
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

  def active_loans_dvc_employer_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.active_loans_dvc_employer_lookup(search_params, start, length)
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

  def active_loans_dvc_emoney_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.active_loans_dvc_emoney_lookup(search_params, start, length)
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

  def active_loans_dvc_corporate_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.active_loans_dvc_corporate_lookup(search_params, start, length)
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

  def active_loans_corporate_buyer_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.active_loans_corporate_buyer_lookup(search_params, start, length)
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

  def loans_employer_collection_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loans_employer_collection_lookup(search_params, start, length)
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


  def loans_corporate_buyer_collection_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loans_corporate_buyer_collection_lookup(search_params, start, length)
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

  def loan_book_analysis_report_lookup(conn, params) do
    this_year = Timex.today.year
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.loan_book_analysis_report(search_params, start, length, this_year)
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


  def debtors_analysis_report_lookup(conn, params) do
    this_year = Timex.today.year
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.debtors_analysis_report(search_params, start, length, this_year)
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



  def corperate_customer_report_lookup(conn, params) do
    # this_year = Timex.today.year
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.corperate_customer_report_miz(search_params, start, length)
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

  def individual_customer_report_lookup(conn, params) do
    # this_year = Timex.today.year
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.individual_customer_report_miz(search_params, start, length)
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

  def entries_debtors_analysis(%{entries: entries}) do
    # entries = [entries|>List.flatten|> Enum.into(%{})]
    entries
  end
  def entries_debtors_analysis(_), do: []

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


  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:reports, :create}
      act when act in ~w(index view)a -> {:reports, :view}
      act when act in ~w(update edit)a -> {:reports, :edit}
      act when act in ~w(change_status)a -> {:reports, :change_status}
      _ -> {:reports, :unknown}
    end
  end



  def all_corparate_disbursed_loans(conn, _params) do
    get_loan_funder = Loanmanagementsystem.Loan.get_loan_funder_details()
    products = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "all_disbursed_corporate_loans.html", products: products, get_loan_funder: get_loan_funder, loans: Loanmanagementsystem.Services.Services.admin_get_disbursed_loans() )
  end




  def corparate_disbursed_loans_look_up(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.corparate_disbursed_loans_listing(search_params, start, length)
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


  def loan_aging_report_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.loan_aging_report_miz(search_params, start, length)
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

  def loan_application_report_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.loan_application_report_miz(search_params, start, length)
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

  def transaction_report_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.transaction_report_miz(search_params, start, length)
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


  def loan_credit_assessment_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.loan_credit_assessment_report_miz(search_params, start, length)
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

  def approve_loan_awaiting_disbursement_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.approve_loan_awaiting_disbursement_miz(search_params, start, length)
    results
    |>IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    total_entries = total_entries(results)
    entries = entries(results)

    entries |> IO.inspect(label: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzz")

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }

    json(conn, results)
  end


  def all_due_repayment_loans(conn, _params) do
    get_loan_funder = Loanmanagementsystem.Loan.get_loan_funder_details()
    products = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "all_due_repayment_loans.html", products: products, get_loan_funder: get_loan_funder, loans: Loanmanagementsystem.Services.Services.admin_get_disbursed_loans() )
  end

  def all_overdue_repayment_loans(conn, _params) do
    get_loan_funder = Loanmanagementsystem.Loan.get_loan_funder_details()
    products = Loanmanagementsystem.Products.list_tbl_products()
    render(conn, "all_overdue_repayment_loans.html", products: products, get_loan_funder: get_loan_funder, loans: Loanmanagementsystem.Services.Services.admin_get_disbursed_loans() )
  end


  def corparate_over_due_loans_look_up(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.corparate_overdue_loans_items_listing(search_params, start, length)
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
