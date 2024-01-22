defmodule LoanmanagementsystemWeb.CoreTransactionController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Core_transaction
  alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Core_transaction.Batch_Processing
  alias Loanmanagementsystem.Core_transaction.Journal_entries
  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.{Repo, Logs.UserLogs}
  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Chart_of_accounts
  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.Chart_of_accounts.Chart_of_account
  alias Loanmanagementsystem.Chart_of_accounts.Accounts_mgt
  alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Loan.Loan_disbursement_schedule
  alias Loanmanagementsystem.Accounts.UserBioData
  import Ecto.Query, warn: false

  plug LoanmanagementsystemWeb.Plugs.Authenticate,
        [module_callback: &LoanmanagementsystemWeb.CoreTransactionController.authorize_role/1]
        when action not in [
            :create_journal_entries_batch_no_screen,
            :journal_entries_assign_batch,
            :create_batch,
            :prepare_batch_params,
            :generate_batch_no,
            :transaction_ref,
            :journal_entries_datatable,
            :total_dr,
            :total_cr,
            :journal_entry_product_code_check,
            :journal_entry_data_capture,
            :post_double_entries_in_trans_log,
            :prepare_dr_account_params,
            :prepare_cr_account_params,
            :close_batch,
            :prepare_batch_changes,
            :cancle_batch,
            :prepare_batch_changes_at_cancle,
            :recall_batch_entries,
            :recall_batch,
            :reassign_batch,
            :change_last_btch_usr,
            :create_user_log,
            :last_batch_usr,
            :select_journal_entry_batch_to_authorise,
            :journal_entries_authorise_datatable,
            :auth_total_dr,
            :auth_total_cr,
            :authorize_batch,
            :prepare_batch_changes_for_auth,
            :discard_batch,
            :prepare_batch_changes_at_discard,
            :journal_entry_single_data_entry,
            :post_single_entry_in_trans_log,
            :journal_entry_bulkupload,
            :bulk_journalentry_upload,
            :account_number_lookup,


       ]

use PipeTo.Override

  def create_journal_entries_batch_no_screen(conn, _params) do
    user = conn.assigns.user
    data_entry_batches = Core_transaction.data_entry_batch(user.id)
    render(conn, "create_journal_entries_batch_no.html", data_entry_batches: data_entry_batches)
  end

  def create_batch(conn, params) do
    user = conn.assigns.user

    with false <- params["batch"] == "NEW_BATCH" do
      redirect(conn,
        to:
          Routes.core_transaction_path(conn, :journal_entries_datatable,
            batch: params["batch"],
            batch_id:
              try do
                Batch_Processing.find_by(
                  batch_no: params["batch"],
                  trans_date: params["trans_date"]
                ).id
              rescue
                _ -> "1"
              end,
            tid: params["tid"]
          )
      )
    else
      true ->
        params = prepare_batch_params(user, params)

        case Core_transaction.create_batch__processing(params) do
          {:ok, _batch} ->
            last_batch = Core_transaction.select_last_batch(user.id)

            conn
            |> redirect(
              to:
                Routes.core_transaction_path(conn, :journal_entries_datatable,
                  batch: last_batch.batch_no,
                  batch_id: last_batch.id,
                  tid: params["tid"]
                )
            )

          {:error, changeset} ->
            reason = UserController.traverse_errors(changeset.errors)

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.core_transaction_path(conn, :journal_entries_datatable))
        end
    end
  end

  def prepare_batch_params(user, params) do
    Map.merge(params, %{
      "trans_date" => to_string(Timex.today()),
      "value_date" => Timex.format!(Timex.today(), "%Y%m%d", :strftime),
      "current_user_id" => user.id,
      "last_user_id" => user.id,
      "uuid" => Ecto.UUID.generate(),
      "batch_no" => generate_batch_no()
    })
  end

  def generate_batch_no do
    Batch_Processing.last(1)
    |> case do
      nil ->
        "0001"

      batch_entries ->
        case Batch_Processing.find_by(trans_date: to_string(Timex.today())) == nil do
          true ->
            "0001"

          false ->
            batch_no_to_post = String.to_integer(batch_entries.batch_no)

            Enum.sum([batch_no_to_post, 1])
            |> to_string
            |> String.pad_leading(4, "0")
        end
    end
  end

  def transaction_ref() do
    day_year = Date.day_of_year(Date.utc_today()) |> to_string
    date = to_string(Timex.format!(Timex.today(), "%Y", :strftime))
    random_int = to_string(Enum.random(1111..9999))
    randoms = to_string(Enum.random(11..99))
    date <> day_year <> random_int <> randoms
  end

  def journal_entries_datatable(conn, params) do
    batch_items = Core_transaction.list_batch_items(params["batch_id"])
    batch_items_count = Core_transaction.list_batch_items_count(params["batch_id"])
    general_ledger_accounts = Chart_of_accounts.list_tbl_chart_of_accounts_leaf()
    list_currencies = Maintenance.list_tbl_currency()
    transref = transaction_ref()
    batch_no = params["batch"]
    batch = params["batch"]

    render(conn, "Journal_entries_datatable.html",
      batch_no: params["batch"],
      batch_id: params["batch_id"],
      batch_items: batch_items,
      batch_items_count: batch_items_count,
      transref: transref,
      batch: batch,
      total_debits: total_dr(batch_no, params["batch_id"]),
      total_credit: total_cr(batch_no, params["batch_id"]),
      difference: Decimal.round(Decimal.sub(Decimal.new(total_dr(batch_no, params["batch_id"])), Decimal.new(total_cr(batch_no, params["batch_id"]))), 2),
      product_code_check: journal_entry_product_code_check(params["batch_id"]),
      general_ledger_accounts: general_ledger_accounts,
      list_currencies: list_currencies
    )
  end


  def total_dr(batch_no, batch_id) do
    name =
      Journal_entries.where(
        drcr_ind: "D",
        batch_no: batch_no,
        batch_id: batch_id,
        batch_status: "ACTIVE"
      )

    %{total: sum} =
      Enum.reduce(name, %{total: 0}, fn x, t -> Map.merge(t, %{total: t.total + x.lcy_amount + x.fcy_amount}) end)

    sum
  end

  def total_cr(batch_no, batch_id) do
    name =
      Journal_entries.where(
        drcr_ind: "C",
        batch_no: batch_no,
        batch_id: batch_id,
        batch_status: "ACTIVE"
      )

    %{total: sum} =
      Enum.reduce(name, %{total: 0}, fn x, t -> Map.merge(t, %{total: t.total + x.lcy_amount + x.fcy_amount}) end)

    sum
  end

  def journal_entry_product_code_check(batch_id) do
    with(
      transactions when transactions != [] <-
        Journal_entries.where(batch_id: batch_id, batch_status: "ACTIVE")
    ) do
      %{product: product_code} =
        Enum.reduce(transactions, %{product: ""}, fn x, t ->
          Map.merge(t, %{product: x.product})
        end)

      product_code
    else
      _ ->
        []
    end
  end

  def journal_entry_data_capture(conn, params) do
    # currencies = Maintenance.list_tbl_currency()
    general_ledger_accounts = Chart_of_accounts.list_tbl_chart_of_accounts_leaf()
    loan_details = Chart_of_accounts.list_loan_details()
    customer_accounts = Chart_of_accounts.list_loan_details_customer_accounts()
    list_currencies = Maintenance.list_tbl_currency()
    today = Timex.today()
    batch_id = params["batch_id"]
    batch = params["batch"]
    transref = transaction_ref()
    user = conn.assigns.user
    data_entry_batches = Core_transaction.data_entry_batch(user.id)
    render(conn, "journal_entry_data_capture.html",
      list_currencies: list_currencies,
      today: today,
      transref: transref,
      batch_id: batch_id,
      batch: batch,
      data_entry_batches: data_entry_batches,
      general_ledger_accounts: general_ledger_accounts,
      loan_details: loan_details,
      customer_accounts: customer_accounts
    )
  end

  def post_double_entries_in_trans_log(conn, params) do
    account_type_dr = Accounts_mgt.exists?(account_no: params["dr_account"])
    account_type_cr = Accounts_mgt.exists?(account_no: params["cr_account"])
    customer_loan_id = if account_type_dr == false || account_type_cr == false do
    dr_ac = try do  Loans.find_by(customer_id: params["dr_account"], loan_status: "DISBURSED").id  rescue _-> 0 end
    cr_ac = try do  Loans.find_by(customer_id: params["cr_account"], loan_status: "DISBURSED").id  rescue _-> 0 end
    if dr_ac != 0 do dr_ac else if cr_ac != 0 do cr_ac else 0 end end else 0 end
    user = to_string(conn.assigns.user.id)
    dr_account_params = prepare_dr_account_params(params, user, customer_loan_id)
    cr_account_params = prepare_cr_account_params(params, user, customer_loan_id)
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :journal_entry_sour,
      Journal_entries.changeset(%Journal_entries{}, dr_account_params)
    )
    |> Ecto.Multi.insert(
      :journal_entry_des,
      Journal_entries.changeset(%Journal_entries{}, cr_account_params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{journal_entry_des: _journal_entry_des} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Created Journal Entries Successfully .",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{journal_entry_des: _journal_entry_des, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Transactions Created Successfully.")
        |> redirect(
          to:
            Routes.core_transaction_path(conn, :journal_entries_datatable,
              batch: params["batch_no"],
              batch_id: params["batch_id"]
            )
        )

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(
          to:
            Routes.core_transaction_path(conn, :journal_entries_datatable,
              batch: params["batch_no"],
              batch_id: params["batch_id"]
            )
        )
    end
  end

  def prepare_dr_account_params(params, user, customer_loan_id) do
    disbursement_loan_id = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).loan_id rescue _-> 0 end
    # disbursement_loan = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id) rescue _-> "" end
    disbursement_interet_per_month = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).interet_per_month rescue _-> 0 end
    running_bal = try do Loan.last_transaction_entry(disbursement_loan_id) |> hd  rescue _-> 0 end
    running_balance = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.running_balance  end
    closing_bal = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.closing_balance || running_bal.requested_amount  end
    interest_per_month = disbursement_interet_per_month / 100.0
    loan_amt = Decimal.new(String.replace(String.trim(params["amount"]), ",", ""))
    loan_amount = Decimal.to_float(loan_amt)
    # oustanding_balance = if running_bal == [] || running_bal == 0 do disbursement_loan.approved_amount else running_bal.closing_balance || running_bal.requested_amount end
    interest = Float.round(loan_amount * interest_per_month, 2)
    interest_paid = if interest <= 0 do 0 else interest end
    principal_paid = Float.round(loan_amount - interest_paid, 2)
    balance = running_balance + loan_amount
    closing_balance = Float.round(closing_bal - principal_paid, 2)
    gl_description =
      try do
        case Chart_of_account.exists?(ac_gl_no: String.trim(params["dr_account"])) do
          true ->
        Chart_of_account.find_by(
          ac_gl_no: String.trim(params["dr_account"])
        ).ac_gl_descption
        false ->
         company_details = Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id: params["dr_account"])
         user =   UserBioData.find_by(userId: params["dr_account"])
         if  company_details == nil do
           "#{user.firstName}"<>" "<> "#{user.lastName}"<>" "<>"#{user.otherName}"
         else
          company_details.company_name || "#{user.firstName}"<>" "<> "#{user.lastName}"<>" "<>"#{user.otherName}"
         end
        end
      rescue
        _ -> "No Account Name"
      end

    gl_category =
      try do
        Chart_of_account.find_by(
          ac_gl_no: String.trim(params["dr_account"])
        ).gl_category
      rescue
        _ -> "No GL Category"
      end

    %{
      module: "INSTALLMENT DUE",
      batch_no: params["batch_no"],
      batch_id: String.to_integer(params["batch_id"]),
      event: "JE",
      trn_ref_no: params["trn_ref_no"],
      account_no: params["dr_account"],
      account_name: gl_description,
      currency: params["currency"],
      drcr_ind: "D",
      fcy_amount:
        if String.upcase(params["currency"]) == "ZMW" do
          0
        else
          String.trim(params["amount"])
        end,
      lcy_amount:
        if String.upcase(params["currency"]) == "ZMW" do
          String.trim(params["amount"])
        else
          0
        end,
      financial_cycle: "FY#{Timex.today().year}",
      period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
      product: "Personal Loan",
      trn_dt: params["trn_dt"],
      value_dt: to_string(Timex.today()),
      user_id: user,
      auth_status: "UNAUTHORISED",
      batch_status: "ACTIVE",
      process_status: "PENDING_APPROVAL",
      account_category: to_string(gl_category),
      narration: params["narration"],
      interest: interest_paid,
      principle: principal_paid,
      running_balance: balance,
      closing_balance: closing_balance
    }
  end

  def prepare_cr_account_params(params, user, customer_loan_id) do
    if customer_loan_id == 0 do
    disbursement_loan_id = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).loan_id rescue _-> 0 end
    disbursement_loan = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id) rescue _-> "" end
    disbursement_interet_per_month = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).interet_per_month rescue _-> 0 end
    running_bal = try do Loan.last_transaction_entry(disbursement_loan_id) |> hd  rescue _-> 0 end
    running_balance = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.running_balance  end
    closing_bal = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.closing_balance || running_bal.requested_amount  end
    interest_per_month = disbursement_interet_per_month / 100.0
    loan_amt = Decimal.new(String.replace(String.trim(params["amount"]), ",", ""))
    loan_amount = Decimal.to_float(loan_amt)
    oustanding_balance = if running_bal == [] || running_bal == 0 do disbursement_loan.approved_amount else running_bal.closing_balance || running_bal.requested_amount end
    interest = Float.round(oustanding_balance * interest_per_month, 2)
    interest_paid = if interest <= 0 do 0 else interest end
    principal_paid = Float.round(loan_amount - interest_paid, 2)
    balance = running_balance + loan_amount
    closing_balance = Float.round(closing_bal - principal_paid, 2)
    client_id = try do Loans.find_by(id: String.trim(params["loan_id"])).customer_id rescue _ -> "" end
    gl_description =
      try do
        case Chart_of_account.exists?(ac_gl_no: String.trim(params["cr_account"])) do
          true ->
        Chart_of_account.find_by(
          ac_gl_no: String.trim(params["cr_account"])
        ).ac_gl_descption
        false ->
          company_details = Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id: params["cr_account"])
          user =   UserBioData.find_by(userId: params["cr_account"])
          if  company_details == nil do
            "#{user.firstName}"<>" "<> "#{user.lastName}"<>" "<>"#{user.otherName}"
          else
           company_details.company_name || "#{user.firstName}"<>" "<> "#{user.lastName}"<>" "<>"#{user.otherName}"
          end
        end
      rescue
        _ -> "No Account Name"
      end
    gl_category =
      try do
        Chart_of_account.find_by(
          ac_gl_no: String.trim(params["cr_account"])
        ).gl_category
      rescue
        _ -> "Assets"
      end
    %{
      module: "INSTALLMENT DUE",
      batch_no: params["batch_no"],
      batch_id: String.to_integer(params["batch_id"]),
      event: "JE",
      trn_ref_no: params["trn_ref_no"],
      account_no: params["cr_account"],
      account_name: gl_description,
      currency: params["currency"],
      drcr_ind: "C",
      fcy_amount:
        if String.upcase(params["currency"]) == "ZMW" do
          0
        else
          String.trim(params["amount"])
        end,
      lcy_amount:
        if String.upcase(params["currency"]) == "ZMW" do
          String.trim(params["amount"])
        else
          0
        end,
      financial_cycle: "FY#{Timex.today().year}",
      period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
      product: "Personal Loan",
      trn_dt: params["trn_dt"],
      value_dt: to_string(Timex.today()),
      user_id: user,
      auth_status: "UNAUTHORISED",
      batch_status: "ACTIVE",
      process_status: "PENDING_APPROVAL",
      account_category: to_string(gl_category),
      narration: params["narration"],
      customer_id: client_id,
      loan_id: params["loan_id"],
      interest: interest_paid,
      principle: principal_paid,
      running_balance: balance,
      closing_balance: closing_balance
    }
  else
    disbursement_loan_id = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).loan_id rescue _-> 0 end
    disbursement_loan = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id) rescue _-> "" end
    disbursement_interet_per_month = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).interet_per_month rescue _-> 0 end
    running_bal = try do Loan.last_transaction_entry(disbursement_loan_id) |> hd  rescue _-> 0 end
    running_balance = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.running_balance  end
    closing_bal = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.closing_balance || running_bal.requested_amount  end
    interest_per_month = disbursement_interet_per_month / 100.0
    loan_amt = Decimal.new(String.replace(String.trim(params["amount"]), ",", ""))
    loan_amount = Decimal.to_float(loan_amt)
    oustanding_balance = if running_bal == [] || running_bal == 0 do disbursement_loan.approved_amount else running_bal.closing_balance || running_bal.requested_amount end
    interest = Float.round(oustanding_balance * interest_per_month, 2)
    interest_paid = if interest <= 0 do 0 else interest end
    principal_paid = Float.round(loan_amount - interest_paid, 2)
    balance = running_balance + loan_amount
    closing_balance = Float.round(closing_bal - principal_paid, 2)
    client_id = try do Loans.find_by(id: disbursement_loan_id).customer_id rescue _ -> "" end
    gl_description =
      try do
        case Chart_of_account.exists?(ac_gl_no: String.trim(params["cr_account"])) do
          true ->
        Chart_of_account.find_by(
          ac_gl_no: String.trim(params["cr_account"])
        ).ac_gl_descption
        false ->
          company_details = Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id: params["cr_account"])
          user =   UserBioData.find_by(userId: params["cr_account"])
          if  company_details == nil do
            "#{user.firstName}"<>" "<> "#{user.lastName}"<>" "<>"#{user.otherName}"
          else
           company_details.company_name || "#{user.firstName}"<>" "<> "#{user.lastName}"<>" "<>"#{user.otherName}"
          end
        end
      rescue
        _ -> "No Account Name"
      end
    gl_category =
      try do
        Loanmanagementsystem.Chart_of_accounts.Chart_of_account.find_by(
          ac_gl_no: String.trim(params["cr_account"])
        ).gl_category
      rescue
        _ -> "Assets"
      end
    %{
      module: "INSTALLMENT DUE",
      batch_no: params["batch_no"],
      batch_id: String.to_integer(params["batch_id"]),
      event: "JE",
      trn_ref_no: params["trn_ref_no"],
      account_no: params["cr_account"],
      account_name: gl_description,
      currency: params["currency"],
      drcr_ind: "C",
      fcy_amount:
        if String.upcase(params["currency"]) == "ZMW" do
          0
        else
          String.trim(params["amount"])
        end,
      lcy_amount:
        if String.upcase(params["currency"]) == "ZMW" do
          String.trim(params["amount"])
        else
          0
        end,
      financial_cycle: "FY#{Timex.today().year}",
      period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
      product: "Personal Loan",
      trn_dt: params["trn_dt"],
      value_dt: to_string(Timex.today()),
      user_id: user,
      auth_status: "UNAUTHORISED",
      batch_status: "ACTIVE",
      process_status: "PENDING_APPROVAL",
      account_category: to_string(gl_category),
      narration: params["narration"],
      customer_id: client_id,
      loan_id: customer_loan_id,
      interest: interest_paid,
      principle: principal_paid,
      running_balance: balance,
      closing_balance: closing_balance
    }
  end
  end

  def close_batch(conn, %{"batch_no" => batch_no, "batch_id" => batch_id}) do
    with(true <- Journal_entries.exists?(batch_no: batch_no, batch_id: batch_id)) do
      items = Core_transaction.close_batch_items(batch_no, batch_id)
      batch = Core_transaction.get_related_batch(batch_no, batch_id)

      conn.assigns.user
      |> prepare_batch_changes(batch, items, "1", "PENDING_APPROVAL", "PENDING_POSTING")
      |> Repo.transaction()
      |> case do
        {:ok, _multi_insert} ->
          json(conn, %{data: "Batch closed successful!"})

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = UserController.traverse_errors(failed_value.errors) |> List.first()
          json(conn, %{error: reason})
      end
    else
      _ ->
        json(conn, %{error: "No Transactions Found!"})
    end
  end

  defp prepare_batch_changes(user, batch, items, stat, batch_stat, auth_stat) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_batch, Batch_Processing.changeset(batch, %{status: stat}))
    |> Ecto.Multi.merge(fn _multi ->
      Enum.map(items, fn item ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(
          "update_batch_item_#{item.id}",
          Journal_entries.changeset(item, %{batch_status: batch_stat, auth_status: auth_stat})
        )
        |> Ecto.Multi.insert(
          "user_log_#{item.id}",
          UserLogs.changeset(%UserLogs{}, %{
            user_id: user.id,
            activity: "Closed batch: #{item.batch_no} and transaction with A/C Name "
          })
        )
      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    end)
  end

  def cancle_batch(conn, %{"batch_no" => batch_no, "batch_id" => batch_id}) do
    items = Core_transaction.close_batch_items(batch_no, batch_id)
    batch = Core_transaction.get_related_batch(batch_no, batch_id)

    conn.assigns.user
    |> prepare_batch_changes_at_cancle(batch, items, "2", "DISCARDED", "DISCARDED")
    |> Repo.transaction()
    |> case do
      {:ok, _multi_insert} ->
        json(conn, %{data: "Batch Discarded successful!"})

      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        json(conn, %{error: "Couldn't discard batch. try again!"})
    end
  end

  defp prepare_batch_changes_at_cancle(user, batch, items, stat, batch_stat, auth_stat) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_batch, Batch_Processing.changeset(batch, %{status: stat}))
    |> Ecto.Multi.merge(fn _multi ->
      Enum.map(items, fn item ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(
          "update_batch_item_#{item.id}",
          Journal_entries.changeset(item, %{batch_status: batch_stat, auth_status: auth_stat})
        )
        |> Ecto.Multi.insert(
          "user_log_#{item.id}",
          UserLogs.changeset(%UserLogs{}, %{
            user_id: user.id,
            activity: "Discard batch: #{item.batch_no} and transaction with General Ledger NO:  "
          })
        )
      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    end)
  end

  def recall_batch_entries(conn, _params) do
    user = conn.assigns.user
    batches = Core_transaction.recall_batch(user.id)
    render(conn, "Journal_entries_recall_batch.html", batches: batches)
  end

  def recall_batch(conn, %{"batch_id" => batch_id}) do
    batch = Repo.get_by(Batch_Processing, id: batch_id)
    batch_id = batch.id
    batch_no = batch.batch_no

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_batch, Batch_Processing.changeset(batch, %{status: "0"}))
    |> Ecto.Multi.update_all(
      :update_all,
      from(p in Journal_entries, where: [batch_id: ^batch_id, batch_no: ^batch_no]),
      set: [
        process_status: "PENDING_APPROVAL",
        batch_status: "ACTIVE",
        auth_status: "UNAUTHORISED"
      ]
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{update_batch: _update_batch, update_all: _update_all}} ->
        conn
        |> put_flash(:info, " Batch successfully recalled.")
        |> redirect(to: Routes.core_transaction_path(conn, :recall_batch_entries))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.core_transaction_path(conn, :recall_batch_entries))
    end
  end

  def reassign_batch(conn, _params) do
    batches = Core_transaction.active_batch_params()
    users = Accounts.batch_users()
    render(conn, "journal_entries_reassign_batch.html", batches: batches, users: users)
  end

  def change_last_btch_usr(conn, params) do
    batch = Core_transaction.get_batch__processing!(params["batch_id"])
    change_last_user = params["current_user_id"]

    param =
      Map.merge(params, %{
        "last_user_id" => change_last_user
      })

    id = conn.assigns.user.id
    activity = "Changed last user for batch: #{batch.batch_no}"

    Ecto.Multi.new()
    |> Ecto.Multi.update(:batch, Batch_Processing.changeset(batch, param))
    |> create_user_log(id, activity)
    |> Repo.transaction()
    |> case do
      {:ok, %{batch: _updated_batch, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Last user changed successful!")
        |> redirect(to: Routes.core_transaction_path(conn, :reassign_batch))

      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "Failed to change Last user!")
        |> redirect(to: Routes.core_transaction_path(conn, :reassign_batch))
    end
  end

  defp create_user_log(multi, id, activity) do
    multi
    |> Ecto.Multi.merge(fn _ ->
      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :user_log,
        UserLogs.changeset(%UserLogs{}, %{
          user_id: id,
          activity: activity
        })
      )
    end)
  end

  def last_batch_usr(conn, %{"batch_id" => batch_id}) do
    json(conn, %{
      data: Core_transaction.last_batch_usr(batch_id)
    })
  end

  def select_journal_entry_batch_to_authorise(conn, _params) do
    approve_batches = Core_transaction.select_batch()

    render(conn, "journal_entries_authorise_select_batch_no.html",
      approve_batches: approve_batches
    )
  end

  def journal_entries_authorise_datatable(conn, params) do
    batch_no = params["batch"]
    batch_id = params["batch_id"]
    batch_items_approval = Core_transaction.list_batch_items_to_approve(params["batch_id"])

    render(conn, "journal_entries_authorise_datatable.html",
      batch_no: batch_no,
      batch_id: batch_id,
      batch_items_approval: batch_items_approval,
      total_debits: auth_total_dr(params["batch_id"]),
      total_credit: auth_total_cr(params["batch_id"]),
      difference: auth_total_dr(params["batch_id"]) - auth_total_cr(params["batch_id"])
    )
  end

  def auth_total_dr(batch_id) do
    name =
      Journal_entries.where(drcr_ind: "D", batch_id: batch_id, batch_status: "PENDING_APPROVAL")

    %{total: sum} =
      Enum.reduce(name, %{total: 0}, fn x, t -> Map.merge(t, %{total: t.total + x.lcy_amount}) end)

    sum
  end

  def auth_total_cr(batch_id) do
    name =
      Journal_entries.where(drcr_ind: "C", batch_id: batch_id, batch_status: "PENDING_APPROVAL")

    %{total: sum} =
      Enum.reduce(name, %{total: 0}, fn x, t -> Map.merge(t, %{total: t.total + x.lcy_amount}) end)

    sum
  end

  def authorize_batch(conn, %{"batch_id" => batch_id}) do
    items = Core_transaction.close_batch_items_auth(batch_id)
    batch = Core_transaction.get_related_batch_auth(batch_id)

    conn.assigns.user
    |> prepare_batch_changes_for_auth(batch, items, "3", "APPROVED", "APPROVED")
    |> Repo.transaction()
    |> case do
      {:ok, _multi_insert} ->
        # update_accounts
        json(conn, %{data: "Batch Authorised Successful!"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  defp prepare_batch_changes_for_auth(user, batch, items, stat, batch_stat, auth_stat) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_batch, Batch_Processing.changeset(batch, %{status: stat}))
    |> Ecto.Multi.merge(fn _multi ->
      Enum.map(items, fn item ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(
          "update_batch_item_#{item.id}",
          Journal_entries.changeset(item, %{
            batch_status: batch_stat,
            auth_status: "AUTHORISED",
            process_status: auth_stat
          })
        )
        |> Ecto.Multi.insert(
          "user_log_#{item.id}",
          UserLogs.changeset(%UserLogs{}, %{
            user_id: user.id,
            activity: "Authorised batch: #{item.batch_no} and transaction with A/C Name: "
          })
        )
      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    end)
  end

  def discard_batch(conn, %{"batch_id" => batch_id}) do
    items = Core_transaction.close_batch_items_discard(batch_id)
    batch = Core_transaction.get_related_batch_discard(batch_id)

    conn.assigns.user
    |> prepare_batch_changes_at_discard(batch, items, "2", "DISCARDED", "DISCARDED")
    |> Repo.transaction()
    |> case do
      {:ok, _multi_insert} ->
        json(conn, %{data: "Batch Discarded successful!"})

      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        json(conn, %{error: "Couldn't discard batch. try again!"})
    end
  end

  defp prepare_batch_changes_at_discard(user, batch, items, stat, batch_stat, auth_stat) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_batch, Batch_Processing.changeset(batch, %{status: stat}))
    |> Ecto.Multi.merge(fn _multi ->
      Enum.map(items, fn item ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(
          "update_batch_item_#{item.id}",
          Journal_entries.changeset(item, %{
            batch_status: batch_stat,
            batch_auth_status: auth_stat
          })
        )
        |> Ecto.Multi.insert(
          "user_log_#{item.id}",
          UserLogs.changeset(%UserLogs{}, %{
            user_id: user.id,
            activity: "Discarded batch: #{item.batch_no} and transaction with A/C Name"
          })
        )
      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    end)
  end

  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:core_txn_mgt, :create}
      act when act in ~w(index view)a -> {:core_txn_mgt, :view}
      act when act in ~w(update edit)a -> {:core_txn_mgt, :edit}
      act when act in ~w(change_status)a -> {:core_txn_mgt, :change_status}
      _ -> {:core_txn_mgt, :unknown}
    end
  end

  # def account_number_lookup(conn, %{"account_numbers" => account_number}) do
  #   get_account_number!(account_number)
  #    |> case do
  #     nil -> json(conn, %{error: "Account not found"})
  #     params -> json(conn, Map.take(params, [:account_name, :account_no, :type]))
  #    end
  # end

  def account_number_lookup(conn, %{"account_numbers" => account_number}) do
    get_account_number!(account_number)
     |> case do
      nil ->
        Loanmanagementsystem.Core_transaction.list_loan_accounts_details(String.to_integer(account_number))
        |> case do
          nil -> json(conn, %{error: "Account not found"})
          params ->
            json(conn, Map.take(params, [:account_name, :account_no, :type]))
        end
      params -> json(conn, Map.take(params, [:account_name, :account_no, :type]))
     end
  end

  def get_account_number!(ac_no) do
    Repo.get_by(Loanmanagementsystem.Chart_of_accounts.Accounts_mgt, account_no: ac_no)
  end

  def journal_entry_single_data_entry(conn, params) do
    general_ledger_accounts = Chart_of_accounts.list_tbl_chart_of_accounts_leaf()
    loan_details = Chart_of_accounts.list_loan_details()
    customer_accounts = Chart_of_accounts.list_loan_details_customer_accounts()
    render(conn, "journal_entry_single_data_capture.html",
    batch: params["batch"],
    batch_id: params["batch_id"],
    transref: transaction_ref(),
    general_ledger_accounts: general_ledger_accounts,
    loan_details: loan_details,
    customer_accounts: customer_accounts
    )
  end

  def post_single_entry_in_trans_log(conn, params) do
    account_type = Accounts_mgt.exists?(account_no: params["account_no"])
    customer_loan_id = if account_type == false do
    ac_no = try do  Loans.find_by(customer_id: params["account_no"]).id  rescue _-> 0 end
    if ac_no != 0 do ac_no  else 0 end else 0 end
    user = to_string(conn.assigns.user.id)
    journal_entry_params = prepare_journal_entry_account_params(params, user, customer_loan_id)
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :journal_entry_params,
      Journal_entries.changeset(%Journal_entries{}, journal_entry_params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{journal_entry_params: _journal_entry_params} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Created Journal Entries Successfully .",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{journal_entry_params: _journal_entry_params, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Transactions Created Successfully.")
        |> redirect(
          to:
            Routes.core_transaction_path(conn, :journal_entries_datatable,
              batch: params["batch_no"],
              batch_id: params["batch_id"]
            )
        )
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> List.first()
        conn
        |> put_flash(:error, reason)
        |> redirect(
          to:
            Routes.core_transaction_path(conn, :journal_entries_datatable,
              batch: params["batch_no"],
              batch_id: params["batch_id"]
            )
        )
    end
  end

  def prepare_journal_entry_account_params(params, user, customer_loan_id) do
    if customer_loan_id == 0 do
    if params["drcr_ind"] == "C" do
      disbursement_loan_id = try do Loan_disbursement_schedule.find_by(loan_id: params["loan_id"]).loan_id rescue _-> 0 end
      disbursement_loan = try do Loan_disbursement_schedule.find_by(loan_id: params["loan_id"]) rescue _-> "" end
      disbursement_interet_per_month = try do Loan_disbursement_schedule.find_by(loan_id: params["loan_id"]).interet_per_month rescue _-> 0 end
      running_bal = try do Loan.last_transaction_entry(disbursement_loan_id) |> hd  rescue _-> 0 end
      running_balance = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.running_balance  end
      closing_bal = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.closing_balance || running_bal.requested_amount  end
      interest_per_month = disbursement_interet_per_month / 100.0
      loan_amt = Decimal.new(String.replace(String.trim(params["amount"]), ",", ""))
      loan_amount = Decimal.to_float(loan_amt)
      oustanding_balance = if running_bal == [] || running_bal == 0 do disbursement_loan.approved_amount else running_bal.closing_balance || running_bal.requested_amount end
      interest = Float.round(oustanding_balance * interest_per_month, 2)
      interest_paid = if interest <= 0 do 0 else interest end
      principal_paid = Float.round(loan_amount - interest_paid, 2)
      balance = running_balance + loan_amount
      closing_balance = Float.round(closing_bal - principal_paid, 2)
      client_id = try do Loans.find_by(id: String.trim(params["loan_id"])).customer_id rescue _ -> "" end
      ac_category =  try do Chart_of_account.find_by(ac_gl_no: params["account_no"]).gl_category rescue _-> "Assets" end
      module = if params["loan_id"] == "" do "Journal Entry" else "INSTALLMENT DUE" end
     %{
      module: module,
      batch_no: params["batch_no"],
      batch_id: String.to_integer(params["batch_id"]),
      event: "JE",
      trn_ref_no: params["trn_ref_no"],
      account_no: params["account_no"],
      account_name: params["account_name"],
      currency: params["currency"],
      drcr_ind: params["drcr_ind"],
      fcy_amount:
        if String.upcase(params["currency"]) == "ZMW" do
          0
        else
          String.replace(String.trim(params["amount"]), ",", "")
        end,
      lcy_amount:
        if String.upcase(params["currency"]) == "ZMW" do
          String.replace(String.trim(params["amount"]), ",", "")
        else
          0
        end,
      financial_cycle: "FY#{Timex.today().year}",
      period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
      product: "",
      trn_dt: params["transaction_date"],
      value_dt: to_string(Timex.today()),
      user_id: user,
      auth_status: "UNAUTHORISED",
      batch_status: "ACTIVE",
      process_status: "PENDING_APPROVAL",
      account_category: ac_category,
      narration: params["narration"],
      interest: interest_paid,
      principle: principal_paid,
      running_balance: balance,
      customer_id: client_id,
      loan_id: params["loan_id"],
      closing_balance: closing_balance
    }
    else
      disbursement_loan_id = try do Loan_disbursement_schedule.find_by(loan_id: params["loan_id"]).loan_id rescue _-> 0 end
      disbursement_loan = try do Loan_disbursement_schedule.find_by(loan_id: params["loan_id"]) rescue _-> "" end
      disbursement_interet_per_month = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).interet_per_month rescue _-> 0 end
      running_bal = try do Loan.last_transaction_entry(disbursement_loan_id) |> hd  rescue _-> 0 end
      running_balance = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.running_balance  end
      closing_bal = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.closing_balance || running_bal.requested_amount  end
      interest_per_month = disbursement_interet_per_month / 100.0
      loan_amt = Decimal.new(String.replace(String.trim(params["amount"]), ",", ""))
      loan_amount = Decimal.to_float(loan_amt)
      oustanding_balance = if running_bal == [] || running_bal == 0 do disbursement_loan.approved_amount else running_bal.closing_balance || running_bal.requested_amount end
      interest = Float.round(oustanding_balance * interest_per_month, 2)
      interest_paid = if interest <= 0 do 0 else interest end
      principal_paid = Float.round(loan_amount - interest_paid, 2)
      balance = running_balance + loan_amount
      closing_balance = Float.round(closing_bal - principal_paid, 2)
      ac_category =  try do Chart_of_account.find_by(ac_gl_no: params["account_no"]).gl_category rescue _-> "" end
    %{
      module: "Journal Entry",
      batch_no: params["batch_no"],
      batch_id: String.to_integer(params["batch_id"]),
      event: "JE",
      trn_ref_no: params["trn_ref_no"],
      account_no: params["account_no"],
      account_name: params["account_name"],
      currency: params["currency"],
      drcr_ind: params["drcr_ind"],
      fcy_amount:
        if String.upcase(params["currency"]) == "ZMW" do
          0
        else
          String.replace(String.trim(params["amount"]), ",", "")
        end,
      lcy_amount:
        if String.upcase(params["currency"]) == "ZMW" do
          String.replace(String.trim(params["amount"]), ",", "")
        else
          0
        end,
      financial_cycle: "FY#{Timex.today().year}",
      period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
      product: "",
      trn_dt: params["transaction_date"],
      value_dt: to_string(Timex.today()),
      user_id: user,
      auth_status: "UNAUTHORISED",
      batch_status: "ACTIVE",
      process_status: "PENDING_APPROVAL",
      account_category: ac_category,
      narration: params["narration"],
      interest: interest_paid,
      principle: principal_paid,
      running_balance: balance,
      closing_balance: closing_balance

    }
    end
  else
    if params["drcr_ind"] == "C" do
      disbursement_loan_id = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).loan_id rescue _-> 0 end
      disbursement_loan = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id) rescue _-> "" end
      disbursement_interet_per_month = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).interet_per_month rescue _-> 0 end
      running_bal = try do Loan.last_transaction_entry(disbursement_loan_id) |> hd  rescue _-> 0 end
      running_balance = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.running_balance  end
      closing_bal = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.closing_balance || running_bal.requested_amount  end
      interest_per_month = disbursement_interet_per_month / 100.0
      loan_amt = Decimal.new(String.replace(String.trim(params["amount"]), ",", ""))
      loan_amount = Decimal.to_float(loan_amt)
      oustanding_balance = if running_bal == [] || running_bal == 0 do disbursement_loan.approved_amount else running_bal.closing_balance || running_bal.requested_amount end
      interest = Float.round(oustanding_balance * interest_per_month, 2)
      interest_paid = if interest <= 0 do 0 else interest end
      principal_paid = Float.round(loan_amount - interest_paid, 2)
      balance = running_balance + loan_amount
      closing_balance = Float.round(closing_bal - principal_paid, 2)
      client_id = try do Loans.find_by(id: disbursement_loan_id).customer_id rescue _ -> "" end
      ac_category =  try do Chart_of_account.find_by(ac_gl_no: params["account_no"]).gl_category rescue _-> "Assets" end
      module = if params["loan_id"] == "" do "Journal Entry" else "INSTALLMENT DUE" end
      %{
        module: module,
        batch_no: params["batch_no"],
        batch_id: String.to_integer(params["batch_id"]),
        event: "JE",
        trn_ref_no: params["trn_ref_no"],
        account_no: params["account_no"],
        account_name: params["account_name"],
        currency: params["currency"],
        drcr_ind: params["drcr_ind"],
        fcy_amount:
          if String.upcase(params["currency"]) == "ZMW" do
            0
          else
            String.replace(String.trim(params["amount"]), ",", "")
          end,
        lcy_amount:
          if String.upcase(params["currency"]) == "ZMW" do
            String.replace(String.trim(params["amount"]), ",", "")
          else
            0
          end,
        financial_cycle: "FY#{Timex.today().year}",
        period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
        product: "",
        trn_dt: params["transaction_date"],
        value_dt: to_string(Timex.today()),
        user_id: user,
        auth_status: "UNAUTHORISED",
        batch_status: "ACTIVE",
        process_status: "PENDING_APPROVAL",
        account_category: ac_category,
        narration: params["narration"],
        interest: interest_paid,
        principle: principal_paid,
        running_balance: balance,
        customer_id: client_id,
        loan_id: disbursement_loan_id,
        closing_balance: closing_balance
      }
      else
        disbursement_loan_id = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).loan_id rescue _-> 0 end
        disbursement_loan = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id) rescue _-> "" end
        disbursement_interet_per_month = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).interet_per_month rescue _-> 0 end
        running_bal = try do Loan.last_transaction_entry(disbursement_loan_id) |> hd  rescue _-> 0 end
        running_balance = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.running_balance  end
        closing_bal = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.closing_balance || running_bal.requested_amount  end
        interest_per_month = disbursement_interet_per_month / 100.0
        loan_amt = Decimal.new(String.replace(String.trim(params["amount"]), ",", ""))
        loan_amount = Decimal.to_float(loan_amt)
        oustanding_balance = if running_bal == [] || running_bal == 0 do disbursement_loan.approved_amount else running_bal.closing_balance || running_bal.requested_amount end
        interest = Float.round(oustanding_balance * interest_per_month, 2)
        interest_paid = if interest <= 0 do 0 else interest end
        principal_paid = Float.round(loan_amount - interest_paid, 2)
        balance = running_balance + loan_amount
        closing_balance = Float.round(closing_bal - principal_paid, 2)
        ac_category =  try do Chart_of_account.find_by(ac_gl_no: params["account_no"]).gl_category rescue _-> "" end
       %{
        module: "Journal Entry",
        batch_no: params["batch_no"],
        batch_id: String.to_integer(params["batch_id"]),
        event: "JE",
        trn_ref_no: params["trn_ref_no"],
        account_no: params["account_no"],
        account_name: params["account_name"],
        currency: params["currency"],
        drcr_ind: params["drcr_ind"],
        fcy_amount:
          if String.upcase(params["currency"]) == "ZMW" do
            0
          else
            String.replace(String.trim(params["amount"]), ",", "")
          end,
        lcy_amount:
          if String.upcase(params["currency"]) == "ZMW" do
            String.replace(String.trim(params["amount"]), ",", "")
          else
            0
          end,
        financial_cycle: "FY#{Timex.today().year}",
        period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
        product: "",
        trn_dt: params["transaction_date"],
        value_dt: to_string(Timex.today()),
        user_id: user,
        auth_status: "UNAUTHORISED",
        batch_status: "ACTIVE",
        process_status: "PENDING_APPROVAL",
        account_category: ac_category,
        narration: params["narration"],
        interest: interest_paid,
        principle: principal_paid,
        running_balance: balance,
        closing_balance: closing_balance

      }
      end

  end
  end

  def journal_entry_bulkupload(conn, params) do
    render(conn, "journal_entry_bulkupload.html",
    batch: params["batch"],
    batch_id: params["batch_id"]
    )
  end

  #----------------------------------------------------------Journal Entry Bulk Upload
@headers ~w/ first_name	last_name	mobile_number	account_number	amount	transaction_type narration /a

def bulk_journalentry_upload(conn, params) do
  user = conn.assigns.user
  {key, msg, _invalid} = handle_journalentry_file_upload(user, params)

  if key == :info do
    conn
    |> put_flash(key, msg)
    |> redirect(to: Routes.core_transaction_path(conn, :journal_entries_datatable, batch: params["batch_no"], batch_id: params["batch_id"] ))

  else
    conn
    |> put_flash(key, msg)
    |> redirect(to: Routes.core_transaction_path(conn, :journal_entries_datatable, batch: params["batch_no"], batch_id: params["batch_id"]  ))
  end
end

defp handle_journalentry_file_upload(user, params) do
    case is_journlentryvalide_file(params) do
    {:ok, filename, destin_path, _row} ->
    user
    |> process_journalentry_bulk_upload(filename, destin_path, params)
    |> case do
      {:ok, {invalid, _valid}} ->
        {:info, "Successful Uploaded Journal Entries ", invalid}

      {:error, reason} ->
        {:error, reason, 0}
    end
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

def process_journalentry_bulk_upload(user, filename, path, params) do
    {:ok, items} = extract_xlsx(path)
    prepare_journalentry_bulkparams(user, filename, items, params)
    |> case do
      {:ok, multi_records} ->
        {invalid, valid} =
          multi_records
          |> Map.values()
          |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->
            case item do
              %{journalentry_filename: _src} -> {invalid, valid + 1}
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

defp prepare_journalentry_bulkparams(user, filename, items, params)  do
    items
    |> Enum.map(fn item ->
      customer_id = try do  UserBioData.find_by(mobileNumber: String.trim(item.mobile_number)).userId  rescue _-> nil end
      account_type = try do  UserBioData.exists?(mobileNumber: String.trim(item.mobile_number))  rescue _-> nil end
       if account_type == true do
        error_logs = prepare_user_params(user, item, "A/C")
        journal_entry_error_logs = UserLogs.changeset(%UserLogs{}, error_logs)
        Ecto.Multi.insert(Ecto.Multi.new(), Ecto.UUID.generate(), journal_entry_error_logs)
         |> Repo.transaction(timeout: :infinity)
       else
        error_logs = prepare_user_params(user, item, "GL")
        journal_entry_error_logs = UserLogs.changeset(%UserLogs{}, error_logs)
        Ecto.Multi.insert(Ecto.Multi.new(), Ecto.UUID.generate(), journal_entry_error_logs)
         |> Repo.transaction(timeout: :infinity)
       end
        customer_loan_id =  try do Loans.find_by(customer_id: customer_id).id rescue _-> "Loan_not_found" end
        case customer_loan_id do
          "Loan_not_found" ->
            error_logs = prepare_user_error_params(user, item, "A/C", filename)
            journal_entry_error_logs = UserLogs.changeset(%UserLogs{}, error_logs)
            Ecto.Multi.insert(Ecto.Multi.new(), Ecto.UUID.generate(), journal_entry_error_logs)
             |> Repo.transaction(timeout: :infinity)
          loan_id  ->
            journal_entries = prepare_journal_entry_bulkupload_params(params, item, filename, loan_id, customer_id)
            journal_entry = Journal_entries.changeset(%Journal_entries{}, journal_entries)
            Ecto.Multi.insert(Ecto.Multi.new(), Ecto.UUID.generate(), journal_entry)
            |> Repo.transaction(timeout: :infinity)
        end

    end)
    |> List.flatten()
    |> Enum.reject(& !&1)
    |> Enum.uniq
    |> hd
end

def prepare_user_params(user, item, bolean) do
  %{
    activity: "Transaction was successful for #{item.first_name} #{item.last_name} with mobile number #{item.mobile_number} -#{bolean} worth #{item.amount}",
    user_id: user.id
  }
end

def prepare_user_error_params(user, item, bolean, filename) do
  %{
    activity: "#{item.first_name} #{item.last_name} has no active loan with mobile number #{item.mobile_number} -#{bolean} worth #{item.amount}, Can not proceed with repayments with filaname #{filename}",
    user_id: user.id
  }
end

def prepare_journal_entry_bulkupload_params(params, item, filename, customer_loan_id, customer_id) do
  case item.transaction_type do
   "C" ->
    disbursement_loan_id = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).loan_id rescue _-> 0 end
    disbursement_loan = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id) rescue _-> nil end
    disbursement_interet_per_month = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).interet_per_month rescue _-> 0 end
    running_bal = try do Loan.last_transaction_entry(disbursement_loan_id) |> hd  rescue _-> 0 end
    running_balance = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.running_balance  end
    closing_bal = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.closing_balance || running_bal.requested_amount  end
    interest_per_month = disbursement_interet_per_month / 100.0
    loan_amt = Decimal.new(String.replace(String.trim(item.amount), ",", ""))
    loan_amount = Decimal.to_float(loan_amt)
    oustanding_balance = if running_bal == [] || running_bal == 0 do if disbursement_loan == nil do 0 else disbursement_loan.approved_amount end else running_bal.closing_balance || running_bal.requested_amount end
    interest = Float.round(oustanding_balance * interest_per_month, 2)
    interest_paid = if interest <= 0 do 0 else interest end
    principal_paid = Float.round(loan_amount - interest_paid, 2)
    balance = running_balance + loan_amount
    closing_balance = Float.round(closing_bal - principal_paid, 2)
    module = if disbursement_loan_id == 0 do "Journal Entry" else "INSTALLMENT DUE" end
    ac_category =  try do Chart_of_account.find_by(ac_gl_no: item.account_number).gl_category rescue _-> "Assets" end
    user_details =  try do UserBioData.find_by(userId: customer_id) rescue _-> nil end
    gl_name = try do Accounts_mgt.find_by(account_no: item.account_number).account_name rescue _-> "" end
    account_name = if user_details == nil do gl_name else "#{user_details.firstName}" <>" "<>"#{user_details.lastName}"<>" "<>"#{user_details.otherName}" end
    %{
      module: module,
      batch_no: params["batch_no"],
      batch_id: String.to_integer(params["batch_id"]),
      event: "JE",
      account_no: if item.account_number == "" do to_string(customer_id) else item.account_number end,
      account_name: account_name,
      currency: "ZMW",
      drcr_ind: item.transaction_type,
      fcy_amount: 0,
      lcy_amount: String.replace(String.trim(item.amount), ",", ""),
      financial_cycle: "FY#{Timex.today().year}",
      period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
      product: "",
      trn_dt: to_string(Timex.today()),
      value_dt: to_string(Timex.today()),
      auth_status: "UNAUTHORISED",
      batch_status: "ACTIVE",
      process_status: "PENDING_APPROVAL",
      account_category: ac_category,
      narration: item.narration,
      journalentry_filename: filename,
      interest: interest_paid,
      principle: principal_paid,
      running_balance: balance,
      customer_id: customer_id,
      loan_id: disbursement_loan_id,
      closing_balance: closing_balance
    }
    "D" ->
      disbursement_loan_id = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).loan_id rescue _-> 0 end
      disbursement_loan = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id) rescue _-> "" end
      disbursement_interet_per_month = try do Loan_disbursement_schedule.find_by(loan_id: customer_loan_id).interet_per_month rescue _-> 0 end
      running_bal = try do Loan.last_transaction_entry(disbursement_loan_id) |> hd  rescue _-> 0 end
      running_balance = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.running_balance  end
      closing_bal = if running_bal == [] ||  running_bal == 0 do 0 else running_bal.closing_balance || running_bal.requested_amount  end
      interest_per_month = disbursement_interet_per_month / 100.0
      loan_amt = Decimal.new(String.replace(String.trim(item.amount), ",", ""))
      loan_amount = Decimal.to_float(loan_amt)
      oustanding_balance = if running_bal == [] || running_bal == 0 do if disbursement_loan == nil do 0 else disbursement_loan.approved_amount end else running_bal.closing_balance || running_bal.requested_amount end
      interest = Float.round(oustanding_balance * interest_per_month, 2)
      interest_paid = if interest <= 0 do 0 else interest end
      principal_paid = Float.round(loan_amount - interest_paid, 2)
      balance = running_balance + loan_amount
      closing_balance = Float.round(closing_bal - principal_paid, 2)
      ac_category =  try do Chart_of_account.find_by(ac_gl_no: item.account_number).gl_category rescue _-> "Assets" end
      user_details =  try do UserBioData.find_by(userId: customer_id) rescue _-> nil end
      gl_name = try do Accounts_mgt.find_by(account_no: item.account_number).account_name rescue _-> "" end
      account_name = if user_details == nil do gl_name else "#{user_details.firstName}" <>" "<>"#{user_details.lastName}"<>" "<>"#{user_details.otherName}" end
    %{
      module: "Journal Entry",
      batch_no: params["batch_no"],
      batch_id: String.to_integer(params["batch_id"]),
      event: "JE",
      account_no: if item.account_number == "" do to_string(customer_id) else item.account_number end,
      account_name: account_name,
      currency: "ZMW",
      drcr_ind: item.transaction_type,
      fcy_amount: 0,
      lcy_amount: String.replace(String.trim(item.amount), ",", ""),
      financial_cycle: "FY#{Timex.today().year}",
      period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
      product: "",
      trn_dt: to_string(Timex.today()),
      value_dt: to_string(Timex.today()),
      auth_status: "UNAUTHORISED",
      batch_status: "ACTIVE",
      process_status: "PENDING_APPROVAL",
      account_category: ac_category,
      narration: item.narration,
      journalentry_filename: filename,
      interest: interest_paid,
      principle: principal_paid,
      running_balance: balance,
      closing_balance: closing_balance
    }
    end
end

# ---------------------- file persistence --------------------------------------
def is_journlentryvalide_file(%{"journalentry_filename" => params}) do
    if upload = params do
      case Path.extname(upload.filename) do
        ext when ext in ~w(.xlsx .XLSX .xls .XLS .csv .CSV) ->
          with {:ok, destin_path} <- persist_journalentry(upload) do
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

def persist_journalentry(%Plug.Upload{filename: filename, path: path}) do
  destin_path =  "C:/GreatNorthCredit/Bulkfiles" |> default_dir()
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
        |> Enum.reject(&Enum.all?(&1, fn item -> is_nil(item)
      end))
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
defp traverse_errors(errors), do: (for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}")



end
