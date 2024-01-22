defmodule Loanmanagementsystem.FinancialReports do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Chart_of_accounts.Chart_of_account
  alias Loanmanagementsystem.Core_transaction.Journal_entries

  def cashflow_details_report(start_dt, end_dt) do
    start_date = if start_dt == nil do ~D[2021-04-20] else Date.from_iso8601!(start_dt) end
    end_date =  if end_dt == nil do Timex.today else Date.from_iso8601!(end_dt) end
    opening_balance = from u in Journal_entries,
    where: u.account_category == "Income" and u.drcr_ind == "D" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    opening_balance_item =   Repo.all(opening_balance)|> hd
    opening_balance_amt = if opening_balance_item == nil do 0.00 else Float.round(opening_balance_item, 2) end
    receipts_from_clients = from u in Journal_entries,
    where: u.account_category == "Assets" and u.drcr_ind == "C" and u.process_status == "APPROVED"
    and u.module == "INSTALLMENT DUE" and not is_nil(u.loan_id),
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    receipts_from_clients_item = Repo.all(receipts_from_clients)|> hd
    receipts_from_clients_amt = if receipts_from_clients_item == nil do 0.00 else Float.round(receipts_from_clients_item, 2) end

    other_receipts = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "3200" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    other_receipts_item = Repo.all(other_receipts)|> hd
    other_receipts_item_amt = if other_receipts_item == nil do 0.00 else Float.round(other_receipts_item, 2) end

    other_receipts_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "3200" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    other_receipts_item_dr = Repo.all(other_receipts_dr)|> hd
    other_receipts_item_dr_amt = if other_receipts_item_dr == nil do 0.00 else Float.round(other_receipts_item_dr, 2) end
    other_receipts_item_result = other_receipts_item_dr_amt - other_receipts_item_amt


    cash_receipt_on_closed_customer = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "1030>50" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    cash_receipt_on_closed_customer_item = Repo.all(cash_receipt_on_closed_customer)|> hd
    cash_receipt_on_closed_customer_item_amt = if cash_receipt_on_closed_customer_item == nil do 0.00 else Float.round(cash_receipt_on_closed_customer_item, 2) end

    cash_receipt_on_closed_customer_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "1030>50" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    cash_receipt_on_closed_customer_dr_item = Repo.all(cash_receipt_on_closed_customer_dr)|> hd
    cash_receipt_on_closed_customer_dr_item_amt = if cash_receipt_on_closed_customer_dr_item == nil do 0.00 else Float.round(cash_receipt_on_closed_customer_dr_item, 2) end
    cash_receipt_on_closed_customer_item_result = cash_receipt_on_closed_customer_dr_item_amt - cash_receipt_on_closed_customer_item_amt


    inter_bank_transfer = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "1040" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    inter_bank_transfer_item = Repo.all(inter_bank_transfer)|> hd
    inter_bank_transfer_item_amt = if inter_bank_transfer_item == nil do 0.00 else inter_bank_transfer_item end

    inter_bank_transfer_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "1040" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    inter_bank_transfer_item_dr = Repo.all(inter_bank_transfer_dr)|> hd
    inter_bank_transfer_item_dr_amt = if inter_bank_transfer_item_dr == nil do 0.00 else inter_bank_transfer_item_dr end
    inter_bank_transfer_item_dr_result = inter_bank_transfer_item_dr_amt - inter_bank_transfer_item_amt


    total_cash_inflow_item = receipts_from_clients_amt + other_receipts_item_result + cash_receipt_on_closed_customer_item_result + inter_bank_transfer_item_dr_result
    total_cash_inflow = Float.round(total_cash_inflow_item, 2)
    net_loan_disbursements = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "LD" and u.module == "DISBURSEMENT" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    net_loan_disbursements_item = Repo.all(net_loan_disbursements)|> hd
    net_loan_disbursements_item_amt = if net_loan_disbursements_item == nil do 0.00 else Float.round(net_loan_disbursements_item, 2) end

    other_direct_costs = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "4150" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    other_direct_costs_item = Repo.all(other_direct_costs)|> hd
    other_direct_costs_item_amt = if other_direct_costs_item == nil do 0.00 else Float.round(other_direct_costs_item, 2) end

    other_direct_costs_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "4150" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    other_direct_costs_dr_item = Repo.all(other_direct_costs_dr)|> hd
    other_direct_costs_item_amt_dr = if other_direct_costs_dr_item == nil do 0.00 else Float.round(other_direct_costs_dr_item, 2) end
    other_direct_costs_item_amt_result = other_direct_costs_item_amt_dr - other_direct_costs_item_amt



    customer_refund = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9350" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    customer_refund_item = Repo.all(customer_refund)|> hd
    customer_refund_item_amt = if customer_refund_item == nil do 0.00 else Float.round(customer_refund_item, 2) end

    customer_refund_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9350" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    customer_refund_dr_item = Repo.all(customer_refund_dr)|> hd
    customer_refund_dr_item_amt = if customer_refund_dr_item == nil do 0.00 else Float.round(customer_refund_dr_item, 2) end
    customer_refund_dr_item_amt_result = customer_refund_dr_item_amt - customer_refund_item_amt


    operating_expenses = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "4620" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    operating_expenses_item = Repo.all(operating_expenses)|> hd
    operating_expenses_item_amt = if operating_expenses_item == nil do 0.00 else Float.round(operating_expenses_item, 2) end

    operating_expenses_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "4620" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    operating_expenses_dr_item = Repo.all(operating_expenses_dr)|> hd
    operating_expenses_dr_item_amt = if operating_expenses_dr_item == nil do 0.00 else Float.round(operating_expenses_dr_item, 2) end
    operating_expenses_item_amt_result = operating_expenses_dr_item_amt - operating_expenses_item_amt



    gnp_fuel_payment_tranfers = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "3350" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    gnp_fuel_payment_tranfers_item = Repo.all(gnp_fuel_payment_tranfers)|> hd
    gnp_fuel_payment_tranfers_item_amt = if gnp_fuel_payment_tranfers_item == nil do 0.00 else Float.round(gnp_fuel_payment_tranfers_item, 2) end

    gnp_fuel_payment_tranfers_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "3350" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    gnp_fuel_payment_tranfers_dr_item = Repo.all(gnp_fuel_payment_tranfers_dr)|> hd
    gnp_fuel_payment_tranfers_dr_item_amt = if gnp_fuel_payment_tranfers_dr_item == nil do 0.00 else Float.round(gnp_fuel_payment_tranfers_dr_item, 2) end

    gnp_fuel_payment_tranfers_item_amt_result = gnp_fuel_payment_tranfers_dr_item_amt - gnp_fuel_payment_tranfers_item_amt

    total_outflows_item = net_loan_disbursements_item_amt +  other_direct_costs_item_amt_result + customer_refund_dr_item_amt_result + operating_expenses_item_amt_result + gnp_fuel_payment_tranfers_item_amt_result
    total_outflows = Float.round(total_outflows_item, 2)


    capital_expenditure = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "2500" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    capital_expenditure_item = Repo.all(capital_expenditure)|> hd
    capital_expenditure_item_amt = if capital_expenditure_item == nil do 0.00 else Float.round(capital_expenditure_item, 2) end

    capital_expenditure_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "2500" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    capital_expenditure_item_dr = Repo.all(capital_expenditure_dr)|> hd
    capital_expenditure_item_dr_amt = if capital_expenditure_item_dr == nil do 0.00 else Float.round(capital_expenditure_item_dr, 2) end
    capital_expenditure_item_amt_result = capital_expenditure_item_dr_amt - capital_expenditure_item_amt


    inter_bank_transfers = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "2500" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    inter_bank_transfers_item = Repo.all(inter_bank_transfers)|> hd
    inter_bank_transfers_item_amt = if inter_bank_transfers_item == nil do 0.00 else Float.round(inter_bank_transfers_item, 2) end

    inter_bank_transfers_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "2500" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    inter_bank_transfers_dr_item = Repo.all(inter_bank_transfers_dr)|> hd
    inter_bank_transfers_dr_item_amt = if inter_bank_transfers_dr_item == nil do 0.00 else Float.round(inter_bank_transfers_dr_item, 2) end
    inter_bank_transfers_item_amt_result = inter_bank_transfers_dr_item_amt - inter_bank_transfers_item_amt



    inter_co_loan = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9130" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    inter_co_loan_item = Repo.all(inter_co_loan)|> hd
    inter_co_loan_item_amt = if inter_co_loan_item == nil do 0.00 else Float.round(inter_co_loan_item, 2) end

    inter_co_loan_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9130" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_date, ^end_date),
    select: sum(u.lcy_amount)
    inter_co_loan_dr_item = Repo.all(inter_co_loan_dr)|> hd
    inter_co_loan_dr_item_amt = if inter_co_loan_dr_item == nil do 0.00 else Float.round(inter_co_loan_dr_item, 2) end
    inter_co_loan_item_amt_result = inter_co_loan_dr_item_amt - inter_co_loan_item_amt



    total_cash_outflow_item = capital_expenditure_item_amt_result - inter_co_loan_item_amt_result
    total_cash_outflow = Float.round(total_cash_outflow_item, 2)
    net_cash_item = opening_balance_amt + total_cash_inflow + total_cash_outflow -  total_outflows
    net_cash = Float.round(net_cash_item, 2)
  %{
    opening_balance: opening_balance_amt,
    receipts_from_clients: receipts_from_clients_amt,
    other_receipts: other_receipts_item_result,
    cash_receipt_on_closed_customer: cash_receipt_on_closed_customer_item_result,
    inter_bank_transfer: inter_bank_transfer_item_dr_result,
    total_cash_inflow: total_cash_inflow,
    net_loan_disbursements: net_loan_disbursements_item_amt,
    other_direct_costs: other_direct_costs_item_amt,
    customer_refund: customer_refund_item_amt,
    operating_expenses: operating_expenses_item_amt,
    gnp_fuel_payment_tranfers: gnp_fuel_payment_tranfers_item_amt,
    total_outflows: total_outflows,
    capital_expenditure: capital_expenditure_item_amt,
    inter_bank_transfers: inter_bank_transfers_item_amt_result,
    inter_co_loan: inter_co_loan_item_amt,
    total_cash_outflow: total_cash_outflow,
    net_cash: net_cash
   }
  end


  def financial_position_report(frequency_selected, date) do
    current_date = if date == nil do Timex.today else Date.from_iso8601!(date) end
    frequency = if frequency_selected == nil do "YEARLY" else frequency_selected end
    start_dt =
    if frequency == "MONTHLY" do
      today =  current_date
      Timex.beginning_of_month(today)

    else
      if  frequency == "QUARTERLY" do
        today = current_date
        Timex.beginning_of_quarter(today)

      else
        if  frequency == "YEARLY" do
          today =  current_date
          Timex.beginning_of_year(today)

        else
          current_date
        end
      end
    end
    end_dt =
    if frequency == "MONTHLY" do
      today =  current_date
      Timex.end_of_month(today)

    else
      if  frequency == "QUARTERLY" do
        today = current_date
        Timex.end_of_quarter(today)

      else
        if  frequency == "YEARLY" do
          today =  current_date
          Timex.end_of_year(today)

        else
          current_date
        end
      end
    end

    start_dt_prev_year =
    if frequency == "MONTHLY" do
      today =  Timex.shift(current_date, days: -30)
      Timex.beginning_of_month(today)

    else
      if  frequency == "QUARTERLY" do
        today =  Timex.shift(current_date, days: -90)
        Timex.beginning_of_quarter(today)

      else
        if  frequency == "YEARLY" do
          today =  Timex.shift(current_date, days: -365)
          Timex.beginning_of_year(today)

        else
          current_date
        end
      end
    end

    end_dt_prev_year =
    if frequency == "MONTHLY" do
      today =  Timex.shift(current_date, days: -30)
      Timex.end_of_month(today)

    else
      if  frequency == "QUARTERLY" do
        today =  Timex.shift(current_date, days: -90)
        Timex.end_of_quarter(today)

      else
        if  frequency == "YEARLY" do
          today =  Timex.shift(current_date, days: -365)
          Timex.end_of_year(today)

        else
          current_date
        end
      end
    end

    # start_date = Timex.today
    # end_date = Timex.today

    computer_equipment = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "4955" or u.account_no == "6100>020" or u.account_no == "6100>010" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    computer_equipment_item = Repo.all(computer_equipment)|> hd
    computer_equipment_item_amt = if computer_equipment_item == nil do 0.00 else Float.round(computer_equipment_item, 2) end

    IO.inspect computer_equipment_item_amt, label: "computer_equipment_item_amt ------------------------------------"

    computer_equipment_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "4955" or u.account_no == "6100>020" or u.account_no == "6100>010" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    computer_equipment_dr_item = Repo.all(computer_equipment_dr)|> hd
    computer_equipment_dr_item_amt = if computer_equipment_dr_item == nil do 0.00 else Float.round(computer_equipment_dr_item, 2) end
    computer_equipment_item_amt_result = computer_equipment_dr_item_amt - computer_equipment_item_amt

    computer_equipment_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "4955" or u.account_no == "6100>020" or u.account_no == "6100>010" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    computer_equipment_prev_item = Repo.all(computer_equipment_prev)|> hd
    computer_equipment_prev_item_amt = if computer_equipment_prev_item == nil do 0.00 else Float.round(computer_equipment_prev_item, 2) end

    IO.inspect computer_equipment_item_amt, label: "computer_equipment_item_amt ------------------------------------"

    computer_equipment_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "4955" or u.account_no == "6100>020" or u.account_no == "6100>010" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    computer_equipment_dr_prev_item = Repo.all(computer_equipment_dr_prev)|> hd
    computer_equipment_dr_prev_item_amt = if computer_equipment_dr_prev_item == nil do 0.00 else Float.round(computer_equipment_dr_prev_item, 2) end
    computer_equipment_item_amt_result_prev = computer_equipment_dr_prev_item_amt - computer_equipment_prev_item_amt





    furniture_fittings = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6200>020" or u.account_no == "6200>010" or u.account_no == "4701" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    furniture_fittings_item = Repo.all(furniture_fittings)|> hd
    furniture_fittings_item_amt = if furniture_fittings_item == nil do 0.00 else Float.round(furniture_fittings_item, 2) end

    IO.inspect furniture_fittings_item_amt, label: "furniture_fittings_item_amt ------------------------------------"

    furniture_fittings_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6200>020" or u.account_no == "6200>010" or u.account_no == "4701" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    furniture_fittings_dr_item = Repo.all(furniture_fittings_dr)|> hd
    furniture_fittings_dr_item_amt = if furniture_fittings_dr_item == nil do 0.00 else Float.round(furniture_fittings_dr_item, 2) end
    furniture_fittings_item_amt_result = furniture_fittings_dr_item_amt - furniture_fittings_item_amt

    IO.inspect furniture_fittings_item_amt, label: "furniture_fittings_item_amt ------------------------------------"

    furniture_fittings_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6200>020" or u.account_no == "6200>010" or u.account_no == "4701" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    furniture_fittings_prev_item = Repo.all(furniture_fittings_prev)|> hd
    furniture_fittings_prev_item_amt = if furniture_fittings_prev_item == nil do 0.00 else Float.round(furniture_fittings_prev_item, 2) end

    IO.inspect furniture_fittings_item_amt, label: "furniture_fittings_item_amt ------------------------------------"

    furniture_fittings_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6200>020" or u.account_no == "6200>010" or u.account_no == "4701" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    furniture_fittings_dr_prev_item = Repo.all(furniture_fittings_dr_prev)|> hd
    furniture_fittings_dr_prev_item_amt = if furniture_fittings_dr_prev_item == nil do 0.00 else Float.round(furniture_fittings_dr_prev_item, 2) end
    furniture_fittings_dr_prev_item_amt_result = furniture_fittings_dr_prev_item_amt - furniture_fittings_prev_item_amt

    IO.inspect furniture_fittings_item_amt, label: "furniture_fittings_item_amt ------------------------------------"





    land_and_building = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6000>020" or u.account_no == "6000>010" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    land_and_building_item = Repo.all(land_and_building)|> hd
    land_and_building_item_amt = if land_and_building_item == nil do 0.00 else Float.round(land_and_building_item, 2) end

    IO.inspect land_and_building_item_amt, label: "land_and_building_item_amt ------------------------------------"

    land_and_building_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6000>020" or u.account_no == "6000>010" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    land_and_building_dr_item = Repo.all(land_and_building_dr)|> hd
    land_and_building_dr_item_amt = if land_and_building_dr_item == nil do 0.00 else Float.round(land_and_building_dr_item, 2) end
    land_and_building_item_amt_result = land_and_building_dr_item_amt - land_and_building_item_amt

    land_and_building_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6000>020" or u.account_no == "6000>010" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    land_and_building_prev_item = Repo.all(land_and_building_prev)|> hd
    land_and_building_prev_item_amt = if land_and_building_prev_item == nil do 0.00 else Float.round(land_and_building_prev_item, 2) end

    IO.inspect land_and_building_item_amt, label: "land_and_building_item_amt ------------------------------------"

    land_and_building_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6000>020" or u.account_no == "6000>010" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    land_and_building_dr_prev_item = Repo.all(land_and_building_dr_prev)|> hd
    land_and_building_dr_prev_item_amt = if land_and_building_dr_prev_item == nil do 0.00 else Float.round(land_and_building_dr_prev_item, 2) end
    land_and_building_dr_prev_item_amt_result = land_and_building_dr_prev_item_amt - land_and_building_prev_item_amt

    IO.inspect land_and_building_item_amt, label: "land_and_building_item_amt ------------------------------------"


    motor_vehicle = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6300>020" or u.account_no == "6300>010" or u.account_no == "4600" or u.account_no == "4061" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    motor_vehicle_item = Repo.all(motor_vehicle)|> hd
    motor_vehicle_item_amt = if motor_vehicle_item == nil do 0.00 else Float.round(motor_vehicle_item, 2) end

    motor_vehicle_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6300>020" or u.account_no == "6300>010" or u.account_no == "4600" or u.account_no == "4061" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    motor_vehicle_dr_item = Repo.all(motor_vehicle_dr)|> hd
    motor_vehicle_dr_item_amt = if motor_vehicle_dr_item == nil do 0.00 else Float.round(motor_vehicle_dr_item, 2) end
    motor_vehicle_item_amt_result = motor_vehicle_dr_item_amt - motor_vehicle_item_amt

    motor_vehicle_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6300>020" or u.account_no == "6300>010" or u.account_no == "4600" or u.account_no == "4061" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    motor_vehicle_prev_item = Repo.all(motor_vehicle_prev)|> hd
    motor_vehicle_prev_item_amt = if motor_vehicle_prev_item == nil do 0.00 else Float.round(motor_vehicle_prev_item, 2) end

    motor_vehicle_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6300>020" or u.account_no == "6300>010" or u.account_no == "4600" or u.account_no == "4061" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    motor_vehicle_dr_prev_item = Repo.all(motor_vehicle_dr_prev)|> hd
    motor_vehicle_dr_prev_item_amt = if motor_vehicle_dr_prev_item == nil do 0.00 else Float.round(motor_vehicle_dr_prev_item, 2) end
    motor_vehicle_prev_item_amt_result = motor_vehicle_dr_prev_item_amt - motor_vehicle_prev_item_amt


    IO.inspect motor_vehicle_item_amt, label: "motor_vehicle_item_amt ------------------------------------"

    office_equipment = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6400>020" or u.account_no == "6400>010" or u.account_no == "4960" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    office_equipment_item = Repo.all(office_equipment)|> hd
    office_equipment_item_amt = if office_equipment_item == nil do 0.00 else Float.round(office_equipment_item, 2) end

    office_equipment_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6400>020" or u.account_no == "6400>010" or u.account_no == "4960" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    office_equipment_dr_item = Repo.all(office_equipment_dr)|> hd
    office_equipment_dr_item_amt = if office_equipment_dr_item == nil do 0.00 else Float.round(office_equipment_dr_item, 2) end
    office_equipment_item_amt_result = office_equipment_dr_item_amt - office_equipment_item_amt


    office_equipment_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6400>020" or u.account_no == "6400>010" or u.account_no == "4960" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    office_equipment_prev_item = Repo.all(office_equipment_prev)|> hd
    office_equipment_prev_item_amt = if office_equipment_prev_item == nil do 0.00 else Float.round(office_equipment_prev_item, 2) end

    office_equipment_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6400>020" or u.account_no == "6400>010" or u.account_no == "4960" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    office_equipment_dr_prev_item = Repo.all(office_equipment_dr_prev)|> hd
    office_equipment_dr_prev_item_amt_prev = if office_equipment_dr_prev_item == nil do 0.00 else Float.round(office_equipment_dr_prev_item, 2) end
    office_equipment_prev_item_amt_result = office_equipment_dr_prev_item_amt_prev - office_equipment_prev_item_amt

    IO.inspect office_equipment_item_amt, label: "office_equipment_item_amt ------------------------------------"

    intangible_assets = 0
    total_property_plant_equipment = 0

    gross_loans_and_advances = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6400>020" or u.account_no == "6400>010" or u.account_no == "4960" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    gross_loans_and_advances_item = Repo.all(gross_loans_and_advances)|> hd
    gross_loans_and_advances_item_amt = if gross_loans_and_advances_item == nil do 0.00 else Float.round(gross_loans_and_advances_item, 2) end

    gross_loans_and_advances_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6400>020" or u.account_no == "6400>010" or u.account_no == "4960" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    gross_loans_and_advances_dr_item = Repo.all(gross_loans_and_advances_dr)|> hd
    gross_loans_and_advances_dr_item_amt = if gross_loans_and_advances_dr_item == nil do 0.00 else Float.round(gross_loans_and_advances_dr_item, 2) end
    gross_loans_and_advances_item_amt_result = gross_loans_and_advances_dr_item_amt - gross_loans_and_advances_item_amt

    gross_loans_and_advances_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6400>020" or u.account_no == "6400>010" or u.account_no == "4960" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    gross_loans_and_advances_prev_item = Repo.all(gross_loans_and_advances_prev)|> hd
    gross_loans_and_advances_prev_item_amt = if gross_loans_and_advances_prev_item == nil do 0.00 else Float.round(gross_loans_and_advances_prev_item, 2) end

    gross_loans_and_advances_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6400>020" or u.account_no == "6400>010" or u.account_no == "4960" and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    gross_loans_and_advances_dr_prev_item = Repo.all(gross_loans_and_advances_dr_prev)|> hd
    gross_loans_and_advances_dr_prev_item_amt = if gross_loans_and_advances_dr_prev_item == nil do 0.00 else Float.round(gross_loans_and_advances_dr_prev_item, 2) end
    gross_loans_and_advances_prev_item_amt_result = gross_loans_and_advances_dr_prev_item_amt - gross_loans_and_advances_prev_item_amt



    IO.inspect gross_loans_and_advances_item_amt, label: "gross_loans_and_advances_item_amt ------------------------------------"


    provision_for_bad_debts = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9800"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    provision_for_bad_debts_item = Repo.all(provision_for_bad_debts)|> hd
    provision_for_bad_debts_item_amt = if provision_for_bad_debts_item == nil do 0.00 else Float.round(provision_for_bad_debts_item, 2) end

    provision_for_bad_debts_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9800"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    provision_for_bad_debts_dr_item = Repo.all(provision_for_bad_debts_dr)|> hd
    provision_for_bad_debts_dr_item_amt = if provision_for_bad_debts_dr_item == nil do 0.00 else Float.round(provision_for_bad_debts_dr_item, 2) end
    provision_for_bad_debts_item_amt_result = provision_for_bad_debts_dr_item_amt - provision_for_bad_debts_item_amt

    provision_for_bad_debts_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9800"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    provision_for_bad_debts_prev_item = Repo.all(provision_for_bad_debts_prev)|> hd
    provision_for_bad_debts_prev_item_amt = if provision_for_bad_debts_prev_item == nil do 0.00 else Float.round(provision_for_bad_debts_prev_item, 2) end

    provision_for_bad_debts_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9800"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    provision_for_bad_debts_dr_prev_item = Repo.all(provision_for_bad_debts_dr_prev)|> hd
    provision_for_bad_debts_dr_prev_item_amt = if provision_for_bad_debts_dr_prev_item == nil do 0.00 else Float.round(provision_for_bad_debts_dr_prev_item, 2) end
    provision_for_bad_debts_item_amt_prev_result = provision_for_bad_debts_dr_prev_item_amt - provision_for_bad_debts_prev_item_amt


    IO.inspect provision_for_bad_debts_item_amt, label: "provision_for_bad_debts_item_amt ------------------------------------"

    net_loans_and_advances = 0

    stock = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "7400"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    stock_item = Repo.all(stock)|> hd
    stock_item_amt = if stock_item == nil do 0.00 else Float.round(stock_item, 2) end


    stock_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "7400"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    stock_dr_item = Repo.all(stock_dr)|> hd
    stock_dr_item_amt = if stock_dr_item == nil do 0.00 else Float.round(stock_dr_item, 2) end
    stock_item_amt_result = stock_dr_item_amt - stock_item_amt

    stock_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "7400"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    stock_prev_item = Repo.all(stock_prev)|> hd
    stock_prev_item_amt = if stock_prev_item == nil do 0.00 else Float.round(stock_prev_item, 2) end


    stock_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "7400"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    stock_dr_prev_item = Repo.all(stock_dr_prev)|> hd
    stock_dr_prev_item_amt = if stock_dr_prev_item == nil do 0.00 else Float.round(stock_dr_prev_item, 2) end
    stock_prev_item_amt_result = stock_dr_prev_item_amt - stock_prev_item_amt




    IO.inspect stock_item_amt, label: "stock_item_amt ------------------------------------"

    #
    loans_and_advances = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == ""  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    loans_and_advances_item = Repo.all(loans_and_advances)|> hd
    loans_and_advances_item_amt = if loans_and_advances_item == nil do 0.00 else Float.round(loans_and_advances_item, 2) end

    IO.inspect loans_and_advances_item_amt, label: "loans_and_advances_item_amt ------------------------------------"



    staff_loans = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "7300"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    staff_loans_item = Repo.all(staff_loans)|> hd
    staff_loans_item_amt = if staff_loans_item == nil do 0.00 else Float.round(staff_loans_item, 2) end

    staff_loans_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "7300"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    staff_loans_dr_item = Repo.all(staff_loans_dr)|> hd
    staff_loans_dr_item_amt = if staff_loans_dr_item == nil do 0.00 else Float.round(staff_loans_dr_item, 2) end

    staff_loans_item_amt_result = staff_loans_dr_item_amt - staff_loans_item_amt


    staff_loans_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "7300"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    staff_loans_prev_item = Repo.all(staff_loans_prev)|> hd
    staff_loans_prev_item_amt = if staff_loans_prev_item == nil do 0.00 else Float.round(staff_loans_prev_item, 2) end

    staff_loans_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "7300"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    staff_loans_dr_prev_item = Repo.all(staff_loans_dr_prev)|> hd
    staff_loans_dr_prev_item_amt = if staff_loans_dr_prev_item == nil do 0.00 else Float.round(staff_loans_dr_prev_item, 2) end

    staff_loans_prev_item_amt_result = staff_loans_dr_prev_item_amt - staff_loans_prev_item_amt

    IO.inspect staff_loans_item_amt, label: "staff_loans_item_amt ------------------------------------"

    prepayments = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "7000"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    prepayments_item = Repo.all(prepayments)|> hd
    prepayments_item_amt = if prepayments_item == nil do 0.00 else Float.round(prepayments_item, 2) end

    prepayments_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "7000"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    prepayments_dr_item = Repo.all(prepayments_dr)|> hd
    prepayments_dr_item_amt = if prepayments_dr_item == nil do 0.00 else Float.round(prepayments_dr_item, 2) end

    prepayments_item_amt_result = prepayments_dr_item_amt - prepayments_item_amt



    prepayments_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "7000"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    prepayments_prev_item = Repo.all(prepayments_prev)|> hd
    prepayments_prev_item_amt = if prepayments_prev_item == nil do 0.00 else Float.round(prepayments_prev_item, 2) end

    prepayments_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "7000"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    prepayments_dr_prev_item = Repo.all(prepayments_dr_prev)|> hd
    prepayments_dr_prev_item_amt = if prepayments_dr_prev_item == nil do 0.00 else Float.round(prepayments_dr_prev_item, 2) end

    prepayments_prev_item_amt_result = prepayments_dr_prev_item_amt - prepayments_prev_item_amt

    IO.inspect prepayments_item_amt, label: "prepayments_item_amt ------------------------------------"

    gnr_intercompany = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8300"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    gnr_intercompany_item = Repo.all(gnr_intercompany)|> hd
    gnr_intercompany_item_amt = if gnr_intercompany_item == nil do 0.00 else Float.round(gnr_intercompany_item, 2) end

    gnr_intercompany_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8300"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    gnr_intercompany_dr_item = Repo.all(gnr_intercompany_dr)|> hd
    gnr_intercompany_dr_item_amt = if gnr_intercompany_dr_item == nil do 0.00 else Float.round(gnr_intercompany_dr_item, 2) end

    gnr_intercompany_item_amt_result = gnr_intercompany_dr_item_amt - gnr_intercompany_item_amt

    gnr_intercompany_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8300"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    gnr_intercompany_prev_item = Repo.all(gnr_intercompany_prev)|> hd
    gnr_intercompany_prev_item_amt = if gnr_intercompany_prev_item == nil do 0.00 else Float.round(gnr_intercompany_prev_item, 2) end

    gnr_intercompany_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8300"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    gnr_intercompany_dr_prev_item = Repo.all(gnr_intercompany_dr_prev)|> hd
    gnr_intercompany_dr_prev_item_amt = if gnr_intercompany_dr_prev_item == nil do 0.00 else Float.round(gnr_intercompany_dr_prev_item, 2) end

    gnr_intercompany_prev_item_amt_result = gnr_intercompany_dr_prev_item_amt - gnr_intercompany_prev_item_amt



    IO.inspect gnr_intercompany_item_amt, label: "gnr_intercompany_item_amt ------------------------------------"


    puma_dijifuel = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "7800>001"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    puma_dijifuel_item = Repo.all(puma_dijifuel)|> hd
    puma_dijifuel_item_amt = if puma_dijifuel_item == nil do 0.00 else Float.round(puma_dijifuel_item, 2) end

    puma_dijifuel_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "7800>001"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    puma_dijifuel_dr_item = Repo.all(puma_dijifuel_dr)|> hd
    puma_dijifuel_dr_item_amt = if puma_dijifuel_dr_item == nil do 0.00 else Float.round(puma_dijifuel_dr_item, 2) end

    puma_dijifuel_item_amt_result = puma_dijifuel_dr_item_amt - puma_dijifuel_item_amt

    puma_dijifuel_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "7800>001"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    puma_dijifuel_prev_item = Repo.all(puma_dijifuel_prev)|> hd
    puma_dijifuel_prev_item_amt = if puma_dijifuel_prev_item == nil do 0.00 else Float.round(puma_dijifuel_prev_item, 2) end

    puma_dijifuel_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "7800>001"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    puma_dijifuel_dr_prev_item = Repo.all(puma_dijifuel_dr_prev)|> hd
    puma_dijifuel_dr_prev_item_amt = if puma_dijifuel_dr_prev_item == nil do 0.00 else Float.round(puma_dijifuel_dr_prev_item, 2) end

    puma_dijifuel_prev_item_amt_result = puma_dijifuel_dr_prev_item_amt - puma_dijifuel_prev_item_amt

    IO.inspect puma_dijifuel_item_amt, label: "puma_dijifuel_item_amt ------------------------------------"

    speedpay = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9400>02"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    speedpay_item = Repo.all(speedpay)|> hd
    speedpay_item_amt = if speedpay_item == nil do 0.00 else Float.round(speedpay_item, 2) end

    speedpay_dr = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9400>02"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    speedpay_dr_item = Repo.all(speedpay_dr)|> hd
    speedpay_dr_item_amt = if speedpay_dr_item == nil do 0.00 else Float.round(speedpay_dr_item, 2) end

    speedpay_item_amt_result = speedpay_dr_item_amt - speedpay_item_amt

    speedpay_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9400>02"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    speedpay_prev_item = Repo.all(speedpay_prev)|> hd
    speedpay_prev_item_amt = if speedpay_item == nil do 0.00 else Float.round(speedpay_prev_item, 2) end

    speedpay_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9400>02"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    speedpay_dr_prev_item = Repo.all(speedpay_dr_prev)|> hd
    speedpay_dr_prev_item_amt = if speedpay_dr_prev_item == nil do 0.00 else Float.round(speedpay_dr_prev_item, 2) end

    speedpay_prev_item_amt_result =  speedpay_dr_prev_item_amt - speedpay_prev_item_amt

    IO.inspect speedpay_item_amt, label: "speedpay_item_amt ------------------------------------"

    sundry_receivables = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "7500"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    sundry_receivables_item = Repo.all(sundry_receivables)|> hd
    sundry_receivables_item_amt = if sundry_receivables_item == nil do 0.00 else Float.round(sundry_receivables_item, 2) end

    sundry_receivables_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "7500"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    sundry_receivables_dr_item = Repo.all(sundry_receivables_dr)|> hd
    sundry_receivables_dr_item_amt = if sundry_receivables_dr_item == nil do 0.00 else Float.round(sundry_receivables_dr_item, 2) end

    sundry_receivables_item_amt_result = sundry_receivables_dr_item_amt - sundry_receivables_item_amt

    sundry_receivables_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "7500"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    sundry_receivables_prev_item = Repo.all(sundry_receivables_prev)|> hd
    sundry_receivables_prev_item_amt = if sundry_receivables_prev_item == nil do 0.00 else Float.round(sundry_receivables_prev_item, 2) end

    sundry_receivables_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "7500"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    sundry_receivables_dr_prev_item = Repo.all(sundry_receivables_dr_prev)|> hd
    sundry_receivables_dr_prev_item_amt = if sundry_receivables_dr_prev_item == nil do 0.00 else Float.round(sundry_receivables_dr_prev_item, 2) end

    sundry_receivables_prev_item_amt_result = sundry_receivables_dr_prev_item_amt - sundry_receivables_prev_item_amt

    IO.inspect sundry_receivables_item_amt, label: "sundry_receivables_item_amt ------------------------------------"

    deffered_tax_asset = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8310"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    deffered_tax_asset_item = Repo.all(deffered_tax_asset)|> hd
    deffered_tax_asset_item_amt = if deffered_tax_asset_item == nil do 0.00 else Float.round(deffered_tax_asset_item, 2) end

    deffered_tax_asset_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8310"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    deffered_tax_asset_dr_item = Repo.all(deffered_tax_asset_dr)|> hd
    deffered_tax_asset_dr_item_amt = if deffered_tax_asset_dr_item == nil do 0.00 else Float.round(deffered_tax_asset_dr_item, 2) end

    deffered_tax_asset_item_amt_result = deffered_tax_asset_dr_item_amt - deffered_tax_asset_item_amt

    deffered_tax_asset_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8310"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    deffered_tax_asset_prev_item = Repo.all(deffered_tax_asset_prev)|> hd
    deffered_tax_asset_prev_item_amt = if deffered_tax_asset_prev_item == nil do 0.00 else Float.round(deffered_tax_asset_prev_item, 2) end

    deffered_tax_asset_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8310"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    deffered_tax_asset_dr_prev_item = Repo.all(deffered_tax_asset_dr_prev)|> hd
    deffered_tax_asset_dr_prev_item_amt = if deffered_tax_asset_dr_prev_item == nil do 0.00 else Float.round(deffered_tax_asset_dr_prev_item, 2) end

    deffered_tax_asset_prev_item_amt_result = deffered_tax_asset_dr_prev_item_amt - deffered_tax_asset_prev_item_amt


    IO.inspect deffered_tax_asset_item_amt, label: "deffered_tax_asset_item_amt ------------------------------------"
   #
    other_current_assets = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == ""  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    other_current_assets_item = Repo.all(other_current_assets)|> hd
    other_current_assets_item_amt = if other_current_assets_item == nil do 0.00 else Float.round(other_current_assets_item, 2) end

    other_current_assets_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == ""  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    other_current_assets_dr_item = Repo.all(other_current_assets_dr)|> hd
    other_current_assets_dr_item_amt = if other_current_assets_dr_item == nil do 0.00 else Float.round(other_current_assets_dr_item, 2) end
    other_current_assets_item_amt_result = other_current_assets_dr_item_amt - other_current_assets_item_amt

    other_current_assets_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == ""  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    other_current_assets_prev_item = Repo.all(other_current_assets_prev)|> hd
    other_current_assets_prev_item_amt = if other_current_assets_prev_item == nil do 0.00 else Float.round(other_current_assets_prev_item, 2) end

    other_current_assets_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == ""  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    other_current_assets_dr_prev_item = Repo.all(other_current_assets_dr_prev)|> hd
    other_current_assets_dr_prev_item_amt = if other_current_assets_dr_prev_item == nil do 0.00 else Float.round(other_current_assets_dr_prev_item, 2) end

    other_current_assets_prev_item_amt_result = other_current_assets_dr_prev_item_amt - other_current_assets_prev_item_amt

    IO.inspect other_current_assets_item_amt, label: "other_current_assets_item_amt ------------------------------------"

    zanaco = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8401"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    zanaco_item = Repo.all(zanaco)|> hd
    zanaco_item_amt = if zanaco_item == nil do 0.00 else Float.round(zanaco_item, 2) end

    zanaco_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8401"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    zanaco_dr_item = Repo.all(zanaco_dr)|> hd
    zanaco_dr_item_amt = if zanaco_dr_item == nil do 0.00 else Float.round(zanaco_dr_item, 2) end

    zanaco_item_amt_result = zanaco_dr_item_amt - zanaco_item_amt

    zanaco_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8401"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    zanaco_prev_item = Repo.all(zanaco_prev)|> hd
    zanaco_prev_item_amt = if zanaco_prev_item == nil do 0.00 else Float.round(zanaco_prev_item, 2) end

    zanaco_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8401"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    zanaco_dr_prev_item = Repo.all(zanaco_dr_prev)|> hd
    zanaco_dr_prev_item_amt = if zanaco_dr_prev_item == nil do 0.00 else Float.round(zanaco_dr_prev_item, 2) end

    zanaco_prev_item_amt_result = zanaco_dr_prev_item_amt - zanaco_prev_item_amt

    IO.inspect zanaco_item_amt, label: "zanaco_item_amt ------------------------------------"

    fnb = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8402"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    fnb_item = Repo.all(fnb)|> hd
    fnb_item_amt = if fnb_item == nil do 0.00 else Float.round(fnb_item, 2) end

    fnb_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8402"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    fnb_dr_item = Repo.all(fnb_dr)|> hd
    fnb_dr_item_amt = if fnb_dr_item == nil do 0.00 else Float.round(fnb_dr_item, 2) end

    fnb_item_amt_result = fnb_dr_item_amt - fnb_item_amt

    fnb_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8402"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    fnb_prev_item = Repo.all(fnb_prev)|> hd
    fnb_prev_item_amt = if fnb_prev_item == nil do 0.00 else Float.round(fnb_prev_item, 2) end

    fnb_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8402"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    fnb_dr_prev_item = Repo.all(fnb_dr_prev)|> hd
    fnb_dr_prev_item_amt = if fnb_dr_prev_item == nil do 0.00 else Float.round(fnb_dr_prev_item, 2) end

    fnb_prev_item_amt_result = fnb_dr_prev_item_amt - fnb_prev_item_amt


    IO.inspect fnb_item_amt, label: "fnb_item_amt ------------------------------------"

    airtel_money = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8404>010"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    airtel_money_item = Repo.all(airtel_money)|> hd
    airtel_money_item_amt = if airtel_money_item == nil do 0.00 else Float.round(airtel_money_item, 2) end

    airtel_money_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8404>010"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    airtel_money_dr_item = Repo.all(airtel_money_dr)|> hd
    airtel_money_dr_item_amt = if airtel_money_dr_item == nil do 0.00 else Float.round(airtel_money_dr_item, 2) end

    airtel_money_item_amt_result = airtel_money_dr_item_amt - airtel_money_item_amt


    airtel_money_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8404>010"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    airtel_money_prev_item = Repo.all(airtel_money_prev)|> hd
    airtel_money_prev_item_amt = if airtel_money_prev_item == nil do 0.00 else Float.round(airtel_money_prev_item, 2) end

    airtel_money_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8404>010"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    airtel_money_dr_prev_item = Repo.all(airtel_money_dr_prev)|> hd
    airtel_money_dr_prev_item_amt = if airtel_money_dr_prev_item == nil do 0.00 else Float.round(airtel_money_dr_prev_item, 2) end

    airtel_money_prev_item_amt_result = airtel_money_dr_prev_item_amt - airtel_money_prev_item_amt

    IO.inspect airtel_money_item_amt, label: "airtel_money_item_amt ------------------------------------"


    diji_fuel_universal = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "4053"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    diji_fuel_universal_item = Repo.all(diji_fuel_universal)|> hd
    diji_fuel_universal_item_amt = if diji_fuel_universal_item == nil do 0.00 else Float.round(diji_fuel_universal_item, 2) end

    diji_fuel_universal_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "4053"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    diji_fuel_universal_dr_item = Repo.all(diji_fuel_universal_dr)|> hd
    diji_fuel_universal_dr_item_amt = if diji_fuel_universal_dr_item == nil do 0.00 else Float.round(diji_fuel_universal_dr_item, 2) end

    diji_fuel_universal_item_amt_result = diji_fuel_universal_dr_item_amt - diji_fuel_universal_item_amt

    diji_fuel_universal_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "4053"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    diji_fuel_universal_prev_item = Repo.all(diji_fuel_universal_prev)|> hd
    diji_fuel_universal_prev_item_amt = if diji_fuel_universal_prev_item == nil do 0.00 else Float.round(diji_fuel_universal_prev_item, 2) end

    diji_fuel_universal_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "4053"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    diji_fuel_universal_dr_prev_item = Repo.all(diji_fuel_universal_dr_prev)|> hd
    diji_fuel_universal_dr_prev_item_amt = if diji_fuel_universal_dr_prev_item == nil do 0.00 else Float.round(diji_fuel_universal_dr_prev_item, 2) end

    diji_fuel_universal_prev_item_amt_result = diji_fuel_universal_dr_prev_item_amt - diji_fuel_universal_prev_item_amt




    IO.inspect diji_fuel_universal_item_amt, label: "diji_fuel_universal_item_amt ------------------------------------"

    mtn_money = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "4053"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    mtn_money_item = Repo.all(mtn_money)|> hd
    mtn_money_item_amt = if mtn_money_item == nil do 0.00 else Float.round(mtn_money_item, 2) end

    mtn_money_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "4053"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    mtn_money_dr_item = Repo.all(mtn_money_dr)|> hd
    mtn_money_dr_item_amt = if mtn_money_dr_item == nil do 0.00 else Float.round(mtn_money_dr_item, 2) end

    mtn_money_item_amt_result = mtn_money_dr_item_amt - mtn_money_item_amt

    mtn_money_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "4053"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    mtn_money_prev_item = Repo.all(mtn_money_prev)|> hd
    mtn_money_prev_item_amt = if mtn_money_prev_item == nil do 0.00 else Float.round(mtn_money_prev_item, 2) end

    mtn_money_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "4053"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    mtn_money_dr_prev_item = Repo.all(mtn_money_dr_prev)|> hd
    mtn_money_dr_prev_item_amt = if mtn_money_dr_prev_item == nil do 0.00 else Float.round(mtn_money_dr_prev_item, 2) end

    mtn_money_prev_item_amt_result =  mtn_money_dr_prev_item_amt - mtn_money_prev_item_amt



    IO.inspect mtn_money_item_amt, label: "mtn_money_item_amt ------------------------------------"

    zanaco_kabwata = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8405"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    zanaco_kabwata_item = Repo.all(zanaco_kabwata)|> hd
    zanaco_kabwata_item_amt = if zanaco_kabwata_item == nil do 0.00 else Float.round(zanaco_kabwata_item, 2) end

    zanaco_kabwata_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8405"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    zanaco_kabwata_dr_item = Repo.all(zanaco_kabwata_dr)|> hd
    zanaco_kabwata_dr_item_amt = if zanaco_kabwata_dr_item == nil do 0.00 else Float.round(zanaco_kabwata_dr_item, 2) end

    zanaco_kabwata_item_amt_result =  zanaco_kabwata_dr_item_amt - zanaco_kabwata_item_amt


    zanaco_kabwata_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8405"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    zanaco_kabwata_prev_item = Repo.all(zanaco_kabwata_prev)|> hd
    zanaco_kabwata_prev_item_amt = if zanaco_kabwata_prev_item == nil do 0.00 else Float.round(zanaco_kabwata_prev_item, 2) end

    zanaco_kabwata_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8405"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    zanaco_kabwata_dr_prev_item = Repo.all(zanaco_kabwata_dr_prev)|> hd
    zanaco_kabwata_dr_prev_amt = if zanaco_kabwata_dr_prev_item == nil do 0.00 else Float.round(zanaco_kabwata_dr_prev_item, 2) end

    zanaco_kabwata_prev_item_amt_result = zanaco_kabwata_dr_prev_amt - zanaco_kabwata_prev_item_amt



    IO.inspect zanaco_kabwata_item_amt, label: "zanaco_kabwata_item_amt ------------------------------------"

    zanaco_comesa = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8406"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    zanaco_comesa_item = Repo.all(zanaco_comesa)|> hd
    zanaco_comesa_item_amt = if zanaco_comesa_item == nil do 0.00 else Float.round(zanaco_comesa_item, 2) end


    zanaco_comesa_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8406"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    zanaco_comesa_dr_item = Repo.all(zanaco_comesa_dr)|> hd
    zanaco_comesa_dr_item_amt = if zanaco_comesa_dr_item == nil do 0.00 else Float.round(zanaco_comesa_dr_item, 2) end

    zanaco_comesa_item_amt_result = zanaco_comesa_dr_item_amt - zanaco_comesa_item_amt

    zanaco_comesa_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8406"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    zanaco_comesa_prev_item = Repo.all(zanaco_comesa_prev)|> hd
    zanaco_comesa_prev_item_amt = if zanaco_comesa_prev_item == nil do 0.00 else Float.round(zanaco_comesa_prev_item, 2) end


    zanaco_comesa_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8406"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    zanaco_comesa_dr_prev_item = Repo.all(zanaco_comesa_dr_prev)|> hd
    zanaco_comesa_dr_prev_item_amt = if zanaco_comesa_dr_prev_item == nil do 0.00 else Float.round(zanaco_comesa_dr_prev_item, 2) end

    zanaco_comesa_prev_item_amt_result = zanaco_comesa_dr_prev_item_amt - zanaco_comesa_prev_item_amt

    IO.inspect zanaco_comesa_item_amt, label: "zanaco_comesa_item_amt ------------------------------------"

    comesa_agency_fnb = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8411"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    comesa_agency_fnb_item = Repo.all(comesa_agency_fnb)|> hd
    comesa_agency_fnb_item_amt = if comesa_agency_fnb_item == nil do 0.00 else Float.round(comesa_agency_fnb_item, 2) end

    comesa_agency_fnb_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8411"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    comesa_agency_fnb_dr_item = Repo.all(comesa_agency_fnb_dr)|> hd
    comesa_agency_fnb_dr_item_amt = if comesa_agency_fnb_dr_item == nil do 0.00 else Float.round(comesa_agency_fnb_dr_item, 2) end

    comesa_agency_fnb_item_amt_result = comesa_agency_fnb_dr_item_amt - comesa_agency_fnb_item_amt

    comesa_agency_fnb_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8411"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    comesa_agency_fnb_prev_item = Repo.all(comesa_agency_fnb_prev)|> hd
    comesa_agency_fnb_prev_item_amt = if comesa_agency_fnb_prev_item == nil do 0.00 else Float.round(comesa_agency_fnb_prev_item, 2) end

    comesa_agency_fnb_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8411"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    comesa_agency_fnb_dr_prev_item = Repo.all(comesa_agency_fnb_dr_prev)|> hd
    comesa_agency_fnb_dr_prev_item_amt = if comesa_agency_fnb_dr_prev_item == nil do 0.00 else Float.round(comesa_agency_fnb_dr_prev_item, 2) end

    comesa_agency_fnb_prev_item_amt_result = comesa_agency_fnb_dr_prev_item_amt - comesa_agency_fnb_prev_item_amt

    IO.inspect comesa_agency_fnb_item_amt, label: "comesa_agency_fnb_item_amt ------------------------------------"

    kangwa_agency = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8412"   and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    kangwa_agency_item = Repo.all(kangwa_agency)|> hd
    kangwa_agency_item_amt = if kangwa_agency_item == nil do 0.00 else Float.round(kangwa_agency_item, 2) end

    kangwa_agency_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8412"   and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    kangwa_agency_dr_item = Repo.all(kangwa_agency_dr)|> hd
    kangwa_agency_dr_item_amt = if kangwa_agency_dr_item == nil do 0.00 else Float.round(kangwa_agency_dr_item, 2) end

    kangwa_agency_item_amt_result = kangwa_agency_dr_item_amt - kangwa_agency_item_amt

    kangwa_agency_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8412"   and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    kangwa_agency_prev_item = Repo.all(kangwa_agency_prev)|> hd
    kangwa_agency_prev_item_amt = if kangwa_agency_prev_item == nil do 0.00 else Float.round(kangwa_agency_prev_item, 2) end

    kangwa_agency_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8412"   and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    kangwa_agency_dr_prev_item = Repo.all(kangwa_agency_dr_prev)|> hd
    kangwa_agency_dr_prev_item_amt = if kangwa_agency_dr_prev_item == nil do 0.00 else Float.round(kangwa_agency_dr_prev_item, 2) end

    kangwa_agency_prev_item_amt_result = kangwa_agency_dr_prev_item_amt - kangwa_agency_prev_item_amt

    IO.inspect kangwa_agency_item_amt, label: "kangwa_agency_item_amt ------------------------------------"

    kabwata_agency = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8414"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    kabwata_agency_item = Repo.all(kabwata_agency)|> hd
    kabwata_agency_item_amt = if kabwata_agency_item == nil do 0.00 else Float.round(kabwata_agency_item, 2) end

    kabwata_agency_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8414"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    kabwata_agency_dr_item = Repo.all(kabwata_agency_dr)|> hd
    kabwata_agency_dr_item_amt = if kabwata_agency_dr_item == nil do 0.00 else Float.round(kabwata_agency_dr_item, 2) end

    kabwata_agency_item_amt_result = kabwata_agency_dr_item_amt - kabwata_agency_item_amt

    kabwata_agency_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8414"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    kabwata_agency_prev_item = Repo.all(kabwata_agency_prev)|> hd
    kabwata_agency_prev_item_amt = if kabwata_agency_prev_item == nil do 0.00 else Float.round(kabwata_agency_prev_item, 2) end

    kabwata_agency_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8414"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    kabwata_agency_dr_prev_item = Repo.all(kabwata_agency_dr_prev)|> hd
    kabwata_agency_dr_prev_item_amt = if kabwata_agency_dr_prev_item == nil do 0.00 else Float.round(kabwata_agency_dr_prev_item, 2) end

    kabwata_agency_prev_item_amt_result = kabwata_agency_dr_prev_item_amt - kabwata_agency_prev_item_amt

    IO.inspect kabwata_agency_item_amt, label: "kabwata_agency_item_amt ------------------------------------"

    kabwata_sda_agency = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8413"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    kabwata_sda_agency_item = Repo.all(kabwata_sda_agency)|> hd
    kabwata_sda_agency_item_amt = if kabwata_sda_agency_item == nil do 0.00 else Float.round(kabwata_sda_agency_item, 2) end

    kabwata_sda_agency_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8413"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    kabwata_sda_agency_dr_item = Repo.all(kabwata_sda_agency_dr)|> hd
    kabwata_sda_agency_dr_item_amt = if kabwata_sda_agency_dr_item == nil do 0.00 else Float.round(kabwata_sda_agency_dr_item, 2) end

    kabwata_sda_agency_item_amt_result = kabwata_sda_agency_dr_item_amt - kabwata_sda_agency_item_amt

    kabwata_sda_agency_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8413"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    kabwata_sda_agency_prev_item = Repo.all(kabwata_sda_agency_prev)|> hd
    kabwata_sda_agency_prev_item_amt = if kabwata_sda_agency_prev_item == nil do 0.00 else Float.round(kabwata_sda_agency_prev_item, 2) end

    kabwata_sda_agency_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8413"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    kabwata_sda_agency_dr_prev_item = Repo.all(kabwata_sda_agency_dr_prev)|> hd
    kabwata_sda_agency_dr_prev_item_amt = if kabwata_sda_agency_dr_prev_item == nil do 0.00 else Float.round(kabwata_sda_agency_dr_prev_item, 2) end

    kabwata_sda_agency_prev_item_amt_result = kabwata_sda_agency_dr_prev_item_amt - kabwata_sda_agency_prev_item_amt

    IO.inspect kabwata_sda_agency_item_amt, label: "kabwata_sda_agency_item_amt ------------------------------------"

    head_office_agency = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8415"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    head_office_agency_item = Repo.all(head_office_agency)|> hd
    head_office_agency_item_amt = if head_office_agency_item == nil do 0.00 else Float.round(head_office_agency_item, 2) end

    head_office_agency_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8415"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    head_office_agency_dr_item = Repo.all(head_office_agency_dr)|> hd
    head_office_agency_dr_item_amt = if head_office_agency_dr_item == nil do 0.00 else Float.round(head_office_agency_dr_item, 2) end

    head_office_agency_item_amt_result = head_office_agency_dr_item_amt - head_office_agency_item_amt

    head_office_agency_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8415"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    head_office_agency_prev_item = Repo.all(head_office_agency_prev)|> hd
    head_office_agency_prev_item_amt = if head_office_agency_prev_item == nil do 0.00 else Float.round(head_office_agency_prev_item, 2) end

    head_office_agency_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8415"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    head_office_agency_dr_prev_item = Repo.all(head_office_agency_dr_prev)|> hd
    head_office_agency_dr_prev_item_amt = if head_office_agency_dr_prev_item == nil do 0.00 else Float.round(head_office_agency_dr_prev_item, 2) end

    head_office_agency_prev_item_amt_result =  head_office_agency_dr_prev_item_amt - head_office_agency_prev_item_amt


    IO.inspect head_office_agency_item_amt, label: "head_office_agency_item_amt ------------------------------------"


    digital_app_instant_loan = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8416"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    digital_app_instant_loan_item = Repo.all(digital_app_instant_loan)|> hd
    digital_app_instant_loan_item_amt = if digital_app_instant_loan_item == nil do 0.00 else Float.round(digital_app_instant_loan_item, 2) end

    digital_app_instant_loan_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8416"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    digital_app_instant_loan_dr_item = Repo.all(digital_app_instant_loan_dr)|> hd
    digital_app_instant_loan_dr_item_amt = if digital_app_instant_loan_dr_item == nil do 0.00 else Float.round(digital_app_instant_loan_dr_item, 2) end

    digital_app_instant_loan_item_amt_result = digital_app_instant_loan_dr_item_amt - digital_app_instant_loan_item_amt

    digital_app_instant_loan_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8416"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    digital_app_instant_loan_prev_item = Repo.all(digital_app_instant_loan_prev)|> hd
    digital_app_instant_loan_prev_item_amt = if digital_app_instant_loan_prev_item == nil do 0.00 else Float.round(digital_app_instant_loan_prev_item, 2) end

    digital_app_instant_loan_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8416"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    digital_app_instant_loan_dr_prev_item = Repo.all(digital_app_instant_loan_dr_prev)|> hd
    digital_app_instant_loan_dr_prev_item_amt = if digital_app_instant_loan_dr_prev_item == nil do 0.00 else Float.round(digital_app_instant_loan_dr_prev_item, 2) end

    digital_app_instant_loan_prev_item_amt_result = digital_app_instant_loan_dr_prev_item_amt - digital_app_instant_loan_prev_item_amt


    IO.inspect digital_app_instant_loan_item_amt, label: "digital_app_instant_loan_item_amt ------------------------------------"

    choppies_cross_roads = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8417"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    choppies_cross_roads_item = Repo.all(choppies_cross_roads)|> hd
    choppies_cross_roads_item_amt = if choppies_cross_roads_item == nil do 0.00 else Float.round(choppies_cross_roads_item, 2) end

    choppies_cross_roads_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8417"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    choppies_cross_roads_dr_item = Repo.all(choppies_cross_roads_dr)|> hd
    choppies_cross_roads_dr_item_amt = if choppies_cross_roads_dr_item == nil do 0.00 else Float.round(choppies_cross_roads_dr_item, 2) end

    choppies_cross_roads_item_amt_result = choppies_cross_roads_dr_item_amt - choppies_cross_roads_item_amt

    choppies_cross_roads_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8417"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    choppies_cross_roads_prev_item = Repo.all(choppies_cross_roads_prev)|> hd
    choppies_cross_roads_prev_item_amt = if choppies_cross_roads_prev_item == nil do 0.00 else Float.round(choppies_cross_roads_prev_item, 2) end

    choppies_cross_roads_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8417"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    choppies_cross_roads_dr_prev_item = Repo.all(choppies_cross_roads_dr_prev)|> hd
    choppies_cross_roads_dr_prev_item_amt = if choppies_cross_roads_dr_prev_item == nil do 0.00 else Float.round(choppies_cross_roads_dr_prev_item, 2) end

    choppies_cross_roads_prev_item_amt_result = choppies_cross_roads_dr_prev_item_amt - choppies_cross_roads_prev_item_amt


    IO.inspect choppies_cross_roads_item_amt, label: "choppies_cross_roads_item_amt ------------------------------------"

    choppies_chalala = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8418"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    choppies_chalala_item = Repo.all(choppies_chalala)|> hd
    choppies_chalala_item_amt = if choppies_chalala_item == nil do 0.00 else Float.round(choppies_chalala_item, 2) end

    choppies_chalala_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8418"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    choppies_chalala_dr_item = Repo.all(choppies_chalala_dr)|> hd
    choppies_chalala_dr_item_amt = if choppies_chalala_dr_item == nil do 0.00 else Float.round(choppies_chalala_dr_item, 2) end

    choppies_chalala_item_amt_result = choppies_chalala_dr_item_amt - choppies_chalala_item_amt

    choppies_chalala_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8418"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    choppies_chalala_prev_item = Repo.all(choppies_chalala_prev)|> hd
    choppies_chalala_prev_item_amt = if choppies_chalala_prev_item == nil do 0.00 else Float.round(choppies_chalala_prev_item, 2) end

    choppies_chalala_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8418"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    choppies_chalala_dr_prev_item = Repo.all(choppies_chalala_dr_prev)|> hd
    choppies_chalala_dr_prev_item_amt = if choppies_chalala_dr_prev_item == nil do 0.00 else Float.round(choppies_chalala_dr_prev_item, 2) end

    choppies_chalala_prev_item_amt_result = choppies_chalala_dr_prev_item_amt - choppies_chalala_prev_item_amt

    IO.inspect choppies_chalala_item_amt, label: "choppies_chalala_item_amt ------------------------------------"

    choppies_ibex = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8419"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    choppies_ibex_item = Repo.all(choppies_ibex)|> hd
    choppies_ibex_item_amt = if choppies_ibex_item == nil do 0.00 else Float.round(choppies_ibex_item, 2) end

    choppies_ibex_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8419"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    choppies_ibex_dr_item = Repo.all(choppies_ibex_dr)|> hd
    choppies_ibex_dr_item_amt = if choppies_ibex_dr_item == nil do 0.00 else Float.round(choppies_ibex_dr_item, 2) end

    choppies_ibex_item_amt_result = choppies_ibex_dr_item_amt - choppies_ibex_item_amt

    choppies_ibex_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8419"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    choppies_ibex_prev_item = Repo.all(choppies_ibex_prev)|> hd
    choppies_ibex_prev_item_amt = if choppies_ibex_prev_item == nil do 0.00 else Float.round(choppies_ibex_prev_item, 2) end

    choppies_ibex_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8419"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    choppies_ibex_dr_prev_item = Repo.all(choppies_ibex_dr_prev)|> hd
    choppies_ibex_dr_prev_item_amt = if choppies_ibex_dr_prev_item == nil do 0.00 else Float.round(choppies_ibex_dr_prev_item, 2) end

    choppies_ibex_prev_item_amt_result = choppies_ibex_dr_prev_item_amt - choppies_ibex_prev_item_amt


    IO.inspect choppies_ibex_item_amt, label: "choppies_ibex_item_amt ------------------------------------"

    instant_loans = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8470"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    instant_loans_item = Repo.all(instant_loans)|> hd
    instant_loans_item_amt = if instant_loans_item == nil do 0.00 else Float.round(instant_loans_item, 2) end

    instant_loans_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8470"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    instant_loans_dr_item = Repo.all(instant_loans_dr)|> hd
    instant_loans_dr_item_amt = if instant_loans_dr_item == nil do 0.00 else Float.round(instant_loans_dr_item, 2) end

    instant_loans_item_amt_result = instant_loans_dr_item_amt - instant_loans_item_amt

    instant_loans_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8470"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    instant_loans_prev_item = Repo.all(instant_loans_prev)|> hd
    instant_loans_prev_item_amt = if instant_loans_prev_item == nil do 0.00 else Float.round(instant_loans_prev_item, 2) end

    instant_loans_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8470"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    instant_loans_dr_prev_item = Repo.all(instant_loans_dr_prev)|> hd
    instant_loans_dr_prev_item_amt = if instant_loans_dr_prev_item == nil do 0.00 else Float.round(instant_loans_dr_prev_item, 2) end

    instant_loans_prev_item_amt_result = instant_loans_dr_prev_item_amt - instant_loans_prev_item_amt

    IO.inspect instant_loans_item_amt, label: "instant_loans_item_amt ------------------------------------"

    choppies_chamba_valley = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8421"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    choppies_chamba_valley_item = Repo.all(choppies_chamba_valley)|> hd
    choppies_chamba_valley_item_amt = if choppies_chamba_valley_item == nil do 0.00 else Float.round(choppies_chamba_valley_item, 2) end


    choppies_chamba_valley_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8421"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    choppies_chamba_valley_dr_item = Repo.all(choppies_chamba_valley_dr)|> hd
    choppies_chamba_valley_dr_item_amt = if choppies_chamba_valley_dr_item == nil do 0.00 else Float.round(choppies_chamba_valley_dr_item, 2) end

    choppies_chamba_valley_item_amt_result = choppies_chamba_valley_dr_item_amt - choppies_chamba_valley_item_amt

    choppies_chamba_valley_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8421"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    choppies_chamba_valley_prev_item = Repo.all(choppies_chamba_valley_prev)|> hd
    choppies_chamba_valley_prev_item_amt = if choppies_chamba_valley_prev_item == nil do 0.00 else Float.round(choppies_chamba_valley_prev_item, 2) end


    choppies_chamba_valley_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8421"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    choppies_chamba_valley_dr_prev_item = Repo.all(choppies_chamba_valley_dr_prev)|> hd
    choppies_chamba_valley_dr_prev_item_amt = if choppies_chamba_valley_dr_prev_item == nil do 0.00 else Float.round(choppies_chamba_valley_dr_prev_item, 2) end

    choppies_chamba_valley_prev_item_amt_result = choppies_chamba_valley_dr_prev_item_amt - choppies_chamba_valley_prev_item_amt


    IO.inspect choppies_chamba_valley_item_amt, label: "choppies_chamba_valley_item_amt ------------------------------------"

    instant_loans_kuku = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8426"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    instant_loans_kuku_item = Repo.all(instant_loans_kuku)|> hd
    instant_loans_kuku_item_amt = if instant_loans_kuku_item == nil do 0.00 else Float.round(instant_loans_kuku_item, 2) end

    instant_loans_kuku_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8426"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    instant_loans_kuku_dr_item = Repo.all(instant_loans_kuku_dr)|> hd
    instant_loans_kuku_dr_item_amt = if instant_loans_kuku_dr_item == nil do 0.00 else Float.round(instant_loans_kuku_dr_item, 2) end

    instant_loans_kuku_item_amt_result = instant_loans_kuku_dr_item_amt - instant_loans_kuku_item_amt

    instant_loans_kuku_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8426"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    instant_loans_kuku_prev_item = Repo.all(instant_loans_kuku_prev)|> hd
    instant_loans_kuku_prev_item_amt = if instant_loans_kuku_prev_item == nil do 0.00 else Float.round(instant_loans_kuku_prev_item, 2) end

    instant_loans_kuku_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8426"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    instant_loans_kuku_dr_prev_item = Repo.all(instant_loans_kuku_dr_prev)|> hd
    instant_loans_kuku_dr_prev_item_amt = if instant_loans_kuku_dr_prev_item == nil do 0.00 else Float.round(instant_loans_kuku_dr_prev_item, 2) end

    instant_loans_kuku_prev_item_amt_result = instant_loans_kuku_dr_prev_item_amt - instant_loans_kuku_prev_item_amt


    IO.inspect instant_loans_kuku_item_amt, label: "instant_loans_kuku_item_amt ------------------------------------"


    eco_bank_float_account = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9801"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    eco_bank_float_account_item = Repo.all(eco_bank_float_account)|> hd
    eco_bank_float_account_item_amt = if eco_bank_float_account_item == nil do 0.00 else Float.round(eco_bank_float_account_item, 2) end

    eco_bank_float_account_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9801"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    eco_bank_float_account_dr_item = Repo.all(eco_bank_float_account_dr)|> hd
    eco_bank_float_account_dr_item_amt = if eco_bank_float_account_dr_item == nil do 0.00 else Float.round(eco_bank_float_account_dr_item, 2) end

    eco_bank_float_account_item_amt_result = eco_bank_float_account_dr_item_amt - eco_bank_float_account_item_amt

    eco_bank_float_account_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9801"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    eco_bank_float_account_prev_item = Repo.all(eco_bank_float_account_prev)|> hd
    eco_bank_float_account_prev_item_amt = if eco_bank_float_account_prev_item == nil do 0.00 else Float.round(eco_bank_float_account_prev_item, 2) end

    eco_bank_float_account_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9801"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    eco_bank_float_account_dr_prev_item = Repo.all(eco_bank_float_account_dr_prev)|> hd
    eco_bank_float_account_dr_prev_item_amt = if eco_bank_float_account_dr_prev_item == nil do 0.00 else Float.round(eco_bank_float_account_dr_prev_item, 2) end

    eco_bank_float_account_prev_item_amt_result = eco_bank_float_account_dr_prev_item_amt - eco_bank_float_account_prev_item_amt


    IO.inspect eco_bank_float_account_item_amt, label: "eco_bank_float_account_item_amt ------------------------------------"
   #
    petty_cash = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9801"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    petty_cash_item = Repo.all(petty_cash)|> hd
    petty_cash_item_amt = if petty_cash_item == nil do 0.00 else Float.round(petty_cash_item, 2) end

    petty_cash_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9801"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    petty_cash_dr_item = Repo.all(petty_cash_dr)|> hd
    petty_cash_dr_item_amt = if petty_cash_dr_item == nil do 0.00 else Float.round(petty_cash_dr_item, 2) end

    petty_cash_item_amt_result = petty_cash_dr_item_amt - petty_cash_item_amt

    petty_cash_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9801"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    petty_cash_prev_item = Repo.all(petty_cash_prev)|> hd
    petty_cash_prev_item_amt = if petty_cash_prev_item == nil do 0.00 else Float.round(petty_cash_prev_item, 2) end

    petty_cash_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9801"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    petty_cash_dr_prev_item = Repo.all(petty_cash_dr_prev)|> hd
    petty_cash_dr_prev_item_amt = if petty_cash_dr_prev_item == nil do 0.00 else Float.round(petty_cash_dr_prev_item, 2) end

    petty_cash_prev_item_amt_result = petty_cash_dr_prev_item_amt - petty_cash_prev_item_amt


    IO.inspect petty_cash_item_amt, label: "petty_cash_item_amt ------------------------------------"

    petty_cash = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8409"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    petty_cash_item = Repo.all(petty_cash)|> hd
    petty_cash_item_amt = if petty_cash_item == nil do 0.00 else Float.round(petty_cash_item, 2) end

    petty_cash_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8409"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    petty_cash_dr_item = Repo.all(petty_cash_dr)|> hd
    petty_cash_dr_item_amt = if petty_cash_dr_item == nil do 0.00 else Float.round(petty_cash_dr_item, 2) end

    petty_cash_item_amt_result = petty_cash_dr_item_amt - petty_cash_item_amt

    petty_cash_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "8409"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    petty_cash_prev_item = Repo.all(petty_cash_prev)|> hd
    petty_cash_prev_item_amt = if petty_cash_prev_item == nil do 0.00 else Float.round(petty_cash_prev_item, 2) end

    petty_cash_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "8409"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    petty_cash_dr_prev_item = Repo.all(petty_cash_dr_prev)|> hd
    petty_cash_dr_prev_item_amt = if petty_cash_dr_prev_item == nil do 0.00 else Float.round(petty_cash_dr_prev_item, 2) end

    petty_cash_prev_item_amt_result = petty_cash_dr_prev_item_amt - petty_cash_prev_item_amt


    IO.inspect petty_cash_item_amt, label: "petty_cash_item_amt ------------------------------------"

    total_cash_and_cash_equivalents = 0
    total_current_assets = 0
    total_assets = 0

    ordinary_capital = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    ordinary_capital_item = Repo.all(ordinary_capital)|> hd
    ordinary_capital_item_amt = if ordinary_capital_item == nil do 0.00 else Float.round(ordinary_capital_item, 2) end

    ordinary_capital_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    ordinary_capital_dr_item = Repo.all(ordinary_capital_dr)|> hd
    ordinary_capital_dr_item_amt = if ordinary_capital_dr_item == nil do 0.00 else Float.round(ordinary_capital_dr_item, 2) end

    ordinary_capital_item_amt_result = ordinary_capital_dr_item_amt - ordinary_capital_item_amt


    ordinary_capital_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    ordinary_capital_prev_item = Repo.all(ordinary_capital_prev)|> hd
    ordinary_capital_prev_item_amt = if ordinary_capital_prev_item == nil do 0.00 else Float.round(ordinary_capital_prev_item, 2) end

    ordinary_capital_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    ordinary_capital_dr_prev_item = Repo.all(ordinary_capital_dr_prev)|> hd
    ordinary_capital_dr_prev_item_amt = if ordinary_capital_dr_prev_item == nil do 0.00 else Float.round(ordinary_capital_dr_prev_item, 2) end

    ordinary_capital_prev_item_amt_result = ordinary_capital_dr_prev_item_amt - ordinary_capital_prev_item_amt


    IO.inspect ordinary_capital_item_amt, label: "ordinary_capital_item_amt ------------------------------------"

    share_premium = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5110"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    share_premium_item = Repo.all(share_premium)|> hd
    share_premium_item_amt = if share_premium_item == nil do 0.00 else Float.round(share_premium_item, 2) end

    share_premium_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5110"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    share_premium_dr_item = Repo.all(share_premium_dr)|> hd
    share_premium_dr_item_amt = if share_premium_dr_item == nil do 0.00 else Float.round(share_premium_dr_item, 2) end

    share_premium_item_amt_result = share_premium_dr_item_amt - share_premium_item_amt

    share_premium_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5110"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    share_premium_prev_item = Repo.all(share_premium_prev)|> hd
    share_premium_prev_item_amt = if share_premium_prev_item == nil do 0.00 else Float.round(share_premium_prev_item, 2) end

    share_premium_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5110"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    share_premium_dr_prev_item = Repo.all(share_premium_dr_prev)|> hd
    share_premium_dr_prev_item_amt = if share_premium_dr_prev_item == nil do 0.00 else Float.round(share_premium_dr_prev_item, 2) end

    share_premium_prev_item_amt_result = share_premium_dr_prev_item_amt - share_premium_prev_item_amt


    IO.inspect share_premium_item_amt, label: "share_premium_item_amt ------------------------------------"


    reserves_prior_year_adjustments = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5120"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    reserves_prior_year_adjustments_item = Repo.all(reserves_prior_year_adjustments)|> hd
    reserves_prior_year_adjustments_item_amt = if reserves_prior_year_adjustments_item == nil do 0.00 else Float.round(reserves_prior_year_adjustments_item, 2) end

    reserves_prior_year_adjustments_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5120"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    reserves_prior_year_adjustments_dr_item = Repo.all(reserves_prior_year_adjustments_dr)|> hd
    reserves_prior_year_adjustments_dr_item_amt = if reserves_prior_year_adjustments_dr_item == nil do 0.00 else Float.round(reserves_prior_year_adjustments_dr_item, 2) end

    reserves_prior_year_adjustments_item_amt_result = reserves_prior_year_adjustments_dr_item_amt - reserves_prior_year_adjustments_item_amt

    reserves_prior_year_adjustments_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5120"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    reserves_prior_year_adjustments_prev_item = Repo.all(reserves_prior_year_adjustments_prev)|> hd
    reserves_prior_year_adjustments_prev_item_amt = if reserves_prior_year_adjustments_prev_item == nil do 0.00 else Float.round(reserves_prior_year_adjustments_prev_item, 2) end

    reserves_prior_year_adjustments_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5120"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    reserves_prior_year_adjustments_dr_prev_item = Repo.all(reserves_prior_year_adjustments_dr_prev)|> hd
    reserves_prior_year_adjustments_dr_prev_item_amt = if reserves_prior_year_adjustments_dr_prev_item == nil do 0.00 else Float.round(reserves_prior_year_adjustments_dr_prev_item, 2) end

    reserves_prior_year_adjustments_prev_item_amt_result = reserves_prior_year_adjustments_dr_prev_item_amt - reserves_prior_year_adjustments_prev_item_amt


    IO.inspect reserves_prior_year_adjustments_item_amt, label: "reserves_prior_year_adjustments_item_amt ------------------------------------"

    share_capital_issue = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    share_capital_issue_item = Repo.all(share_capital_issue)|> hd
    share_capital_issue_item_amt = if share_capital_issue_item == nil do 0.00 else Float.round(share_capital_issue_item, 2) end

    share_capital_issue_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    share_capital_issue_dr_item = Repo.all(share_capital_issue_dr)|> hd
    share_capital_issue_dr_item_amt = if share_capital_issue_dr_item == nil do 0.00 else Float.round(share_capital_issue_dr_item, 2) end

    share_capital_issue_item_amt_result = share_capital_issue_dr_item_amt - share_capital_issue_item_amt

    share_capital_issue_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    share_capital_issue_prev_item = Repo.all(share_capital_issue_prev)|> hd
    share_capital_issue_prev_item_amt = if share_capital_issue_prev_item == nil do 0.00 else Float.round(share_capital_issue_prev_item, 2) end

    share_capital_issue_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    share_capital_issue_dr_prev_item = Repo.all(share_capital_issue_dr_prev)|> hd
    share_capital_issue_dr_prev_item_amt = if share_capital_issue_dr_prev_item == nil do 0.00 else Float.round(share_capital_issue_dr_prev_item, 2) end

    share_capital_issue_prev_item_amt_result = share_capital_issue_dr_prev_item_amt - share_capital_issue_prev_item_amt


    IO.inspect share_capital_issue_item_amt, label: "share_capital_issue_item_amt ------------------------------------"

    retained_earnings_accumulated = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5200"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    retained_earnings_accumulated_item = Repo.all(retained_earnings_accumulated)|> hd
    retained_earnings_accumulated_item_amt = if retained_earnings_accumulated_item == nil do 0.00 else Float.round(retained_earnings_accumulated_item, 2) end

    retained_earnings_accumulated_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5200"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    retained_earnings_accumulated_dr_item = Repo.all(retained_earnings_accumulated_dr)|> hd
    retained_earnings_accumulated_dr_item_amt = if retained_earnings_accumulated_dr_item == nil do 0.00 else Float.round(retained_earnings_accumulated_dr_item, 2) end

    retained_earnings_accumulated_item_amt_result = retained_earnings_accumulated_dr_item_amt - retained_earnings_accumulated_item_amt

    retained_earnings_accumulated_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5200"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    retained_earnings_accumulated_prev_item = Repo.all(retained_earnings_accumulated_prev)|> hd
    retained_earnings_accumulated_prev_item_amt = if retained_earnings_accumulated_prev_item == nil do 0.00 else Float.round(retained_earnings_accumulated_prev_item, 2) end

    retained_earnings_accumulated_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5200"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    retained_earnings_accumulated_dr_prev_item = Repo.all(retained_earnings_accumulated_dr_prev)|> hd
    retained_earnings_accumulated_dr_prev_item_amt = if retained_earnings_accumulated_dr_prev_item == nil do 0.00 else Float.round(retained_earnings_accumulated_dr_prev_item, 2) end

    retained_earnings_accumulated_prev_item_amt_result = retained_earnings_accumulated_dr_prev_item_amt - retained_earnings_accumulated_prev_item_amt



    IO.inspect retained_earnings_accumulated_item_amt, label: "retained_earnings_accumulated_item_amt ------------------------------------"


    retained_earnings_Current_year = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5200"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    retained_earnings_Current_year_item = Repo.all(retained_earnings_Current_year)|> hd
    retained_earnings_Current_year_item_amt = if retained_earnings_Current_year_item == nil do 0.00 else Float.round(retained_earnings_Current_year_item, 2) end


    retained_earnings_Current_year_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5200"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    retained_earnings_Current_year_dr_item = Repo.all(retained_earnings_Current_year_dr)|> hd
    retained_earnings_Current_year_dr_item_amt = if retained_earnings_Current_year_dr_item == nil do 0.00 else Float.round(retained_earnings_Current_year_dr_item, 2) end

    retained_earnings_Current_year_item_amt_result = retained_earnings_Current_year_dr_item_amt - retained_earnings_Current_year_item_amt

    retained_earnings_Current_year_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "5200"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    retained_earnings_Current_year_prev_item = Repo.all(retained_earnings_Current_year_prev)|> hd
    retained_earnings_Current_year_prev_item_amt = if retained_earnings_Current_year_prev_item == nil do 0.00 else Float.round(retained_earnings_Current_year_prev_item, 2) end


    retained_earnings_Current_year_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "5200"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    retained_earnings_Current_year_dr_prev_item = Repo.all(retained_earnings_Current_year_dr_prev)|> hd
    retained_earnings_Current_year_dr_prev_item_amt = if retained_earnings_Current_year_dr_prev_item == nil do 0.00 else Float.round(retained_earnings_Current_year_dr_prev_item, 2) end

    retained_earnings_Current_year_prev_item_amt_result = retained_earnings_Current_year_dr_prev_item_amt - retained_earnings_Current_year_prev_item_amt






    IO.inspect retained_earnings_Current_year_item_amt, label: "retained_earnings_Current_year_item_amt ------------------------------------"

    total_equity = 0

    gnr_inter_company_loans = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == ""  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    gnr_inter_company_loans_item = Repo.all(gnr_inter_company_loans)|> hd
    gnr_inter_company_loans_item_amt = if gnr_inter_company_loans_item == nil do 0.00 else Float.round(gnr_inter_company_loans_item, 2) end

    IO.inspect gnr_inter_company_loans_item_amt, label: "gnr_inter_company_loans_item_amt ------------------------------------"


    gnp_intercompany_liabilities = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == ""  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    gnp_intercompany_liabilities_item = Repo.all(gnp_intercompany_liabilities)|> hd
    gnp_intercompany_liabilities_item_amt = if gnp_intercompany_liabilities_item == nil do 0.00 else Float.round(gnp_intercompany_liabilities_item, 2) end


    IO.inspect gnp_intercompany_liabilities_item_amt, label: "gnp_intercompany_liabilities_item_amt ------------------------------------"

    other_non_current_liabilities = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == ""  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    other_non_current_liabilities_item = Repo.all(other_non_current_liabilities)|> hd
    other_non_current_liabilities_item_amt = if other_non_current_liabilities_item == nil do 0.00 else Float.round(other_non_current_liabilities_item, 2) end


    IO.inspect other_non_current_liabilities_item_amt, label: "other_non_current_liabilities_item_amt ------------------------------------"

    total_non_current_liabilities = 0


    bridging_finance = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6910"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    bridging_finance_item = Repo.all(bridging_finance)|> hd
    bridging_finance_item_amt = if bridging_finance_item == nil do 0.00 else Float.round(bridging_finance_item, 2) end

    bridging_finance_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6910"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    bridging_finance_dr_item = Repo.all(bridging_finance_dr)|> hd
    bridging_finance_dr_item_amt = if bridging_finance_dr_item == nil do 0.00 else Float.round(bridging_finance_dr_item, 2) end

    bridging_finance_item_amt_result = bridging_finance_dr_item_amt - bridging_finance_item_amt

    bridging_finance_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "6910"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    bridging_finance_prev_item = Repo.all(bridging_finance_prev)|> hd
    bridging_finance_prev_item_amt = if bridging_finance_prev_item == nil do 0.00 else Float.round(bridging_finance_prev_item, 2) end

    bridging_finance_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "6910"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    bridging_finance_dr_prev_item = Repo.all(bridging_finance_dr_prev)|> hd
    bridging_finance_dr_prev_item_amt = if bridging_finance_dr_prev_item == nil do 0.00 else Float.round(bridging_finance_dr_prev_item, 2) end

    bridging_finance_prev_item_amt_result = bridging_finance_dr_prev_item_amt - bridging_finance_prev_item_amt



    IO.inspect bridging_finance_item_amt, label: "bridging_finance_item_amt ------------------------------------"


    undeposited_funds = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == ""  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    undeposited_funds_item = Repo.all(undeposited_funds)|> hd
    undeposited_funds_item_amt = if undeposited_funds_item == nil do 0.00 else Float.round(undeposited_funds_item, 2) end

    IO.inspect undeposited_funds_item_amt, label: "undeposited_funds_item_amt ------------------------------------"


    accruals = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9000"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    accruals_item = Repo.all(accruals)|> hd
    accruals_item_amt = if accruals_item == nil do 0.00 else Float.round(accruals_item, 2) end

    accruals_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9000"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    accruals_dr_item = Repo.all(accruals_dr)|> hd
    accruals_dr_item_amt = if accruals_dr_item == nil do 0.00 else Float.round(accruals_dr_item, 2) end

    accruals_item_amt_result = accruals_dr_item_amt - accruals_item_amt

    accruals_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9000"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    accruals_prev_item = Repo.all(accruals_prev)|> hd
    accruals_prev_item_amt = if accruals_prev_item == nil do 0.00 else Float.round(accruals_prev_item, 2) end

    accruals_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9000"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    accruals_dr_prev_item = Repo.all(accruals_dr_prev)|> hd
    accruals_dr_prev_item_amt = if accruals_dr_prev_item == nil do 0.00 else Float.round(accruals_dr_prev_item, 2) end

    accruals_prev_item_amt_result = accruals_dr_prev_item_amt - accruals_prev_item_amt


    IO.inspect accruals_item_amt, label: "accruals_item_amt ------------------------------------"

    provision_for_interest = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9050"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    provision_for_interest_item = Repo.all(provision_for_interest)|> hd
    provision_for_interest_item_amt = if provision_for_interest_item == nil do 0.00 else Float.round(provision_for_interest_item, 2) end

    provision_for_interest_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9050"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    provision_for_interest_dr_item = Repo.all(provision_for_interest_dr)|> hd
    provision_for_interest_dr_item_amt = if provision_for_interest_dr_item == nil do 0.00 else Float.round(provision_for_interest_dr_item, 2) end

    provision_for_interest_item_amt_result = provision_for_interest_dr_item_amt - provision_for_interest_item_amt

    provision_for_interest_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9050"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    provision_for_interest_prev_item = Repo.all(provision_for_interest_prev)|> hd
    provision_for_interest_prev_item_amt = if provision_for_interest_prev_item == nil do 0.00 else Float.round(provision_for_interest_prev_item, 2) end

    provision_for_interest_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9050"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    provision_for_interest_dr_prev_item = Repo.all(provision_for_interest_dr_prev)|> hd
    provision_for_interest_dr_prev_item_amt = if provision_for_interest_dr_prev_item == nil do 0.00 else Float.round(provision_for_interest_dr_prev_item, 2) end

    provision_for_interest_prev_item_amt_result = provision_for_interest_dr_prev_item_amt - provision_for_interest_prev_item_amt





    IO.inspect provision_for_interest_item_amt, label: "provision_for_interest_item_amt ------------------------------------"

    sundry_payables = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9400>01"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    sundry_payables_item = Repo.all(sundry_payables)|> hd
    sundry_payables_item_amt = if sundry_payables_item == nil do 0.00 else Float.round(sundry_payables_item, 2) end

    sundry_payables_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9400>01"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    sundry_payables_dr_item = Repo.all(sundry_payables_dr)|> hd
    sundry_payables_dr_item_amt = if sundry_payables_dr_item == nil do 0.00 else Float.round(sundry_payables_dr_item, 2) end

    sundry_payables_item_amt_result = sundry_payables_dr_item_amt - sundry_payables_item_amt

    sundry_payables_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9400>01"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    sundry_payables_prev_item = Repo.all(sundry_payables_prev)|> hd
    sundry_payables_prev_item_amt = if sundry_payables_prev_item == nil do 0.00 else Float.round(sundry_payables_prev_item, 2) end

    sundry_payables_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9400>01"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    sundry_payables_dr_prev_item = Repo.all(sundry_payables_dr_prev)|> hd
    sundry_payables_dr_prev_item_amt = if sundry_payables_dr_prev_item == nil do 0.00 else Float.round(sundry_payables_dr_prev_item, 2) end

    sundry_payables_prev_item_amt_result = sundry_payables_dr_prev_item_amt - sundry_payables_prev_item_amt



    IO.inspect sundry_payables_item_amt, label: "sundry_payables_item_amt ------------------------------------"

    trade_payables = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == ""  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    trade_payables_item = Repo.all(trade_payables)|> hd
    trade_payables_item_amt = if trade_payables_item == nil do 0.00 else Float.round(trade_payables_item, 2) end

    IO.inspect trade_payables_item_amt, label: "trade_payables_item_amt ------------------------------------"

    related_party_borrowings = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    related_party_borrowings_item = Repo.all(related_party_borrowings)|> hd
    related_party_borrowings_item_amt = if related_party_borrowings_item == nil do 0.00 else Float.round(related_party_borrowings_item, 2) end

    related_party_borrowings_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    related_party_borrowings_dr_item = Repo.all(related_party_borrowings_dr)|> hd
    related_party_borrowings_dr_item_amt = if related_party_borrowings_dr_item == nil do 0.00 else Float.round(related_party_borrowings_dr_item, 2) end

    related_party_borrowings_item_amt_result = related_party_borrowings_dr_item_amt - related_party_borrowings_item_amt


    related_party_borrowings_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    related_party_borrowings_prev_item = Repo.all(related_party_borrowings_prev)|> hd
    related_party_borrowings_prev_item_amt = if related_party_borrowings_prev_item == nil do 0.00 else Float.round(related_party_borrowings_prev_item, 2) end

    related_party_borrowings_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9130"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    related_party_borrowings_dr_prev_item = Repo.all(related_party_borrowings_dr_prev)|> hd
    related_party_borrowings_dr_prev_item_amt = if related_party_borrowings_dr_prev_item == nil do 0.00 else Float.round(related_party_borrowings_dr_prev_item, 2) end

    related_party_borrowings_prev_item_amt_result = related_party_borrowings_dr_prev_item_amt - related_party_borrowings_prev_item_amt



    IO.inspect related_party_borrowings_item_amt, label: "trade_payables_item_amt ------------------------------------"


    payroll_paye = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>010"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    payroll_paye_item = Repo.all(payroll_paye)|> hd
    payroll_paye_item_amt = if payroll_paye_item == nil do 0.00 else Float.round(payroll_paye_item, 2) end


    payroll_paye_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>010"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    payroll_paye_dr_item = Repo.all(payroll_paye_dr)|> hd
    payroll_paye_dr_item_amt = if payroll_paye_dr_item == nil do 0.00 else Float.round(payroll_paye_dr_item, 2) end

    payroll_paye_item_amt_result = payroll_paye_dr_item_amt - payroll_paye_item_amt

    payroll_paye_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>010"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    payroll_paye_prev_item = Repo.all(payroll_paye_prev)|> hd
    payroll_paye_prev_item_amt = if payroll_paye_prev_item == nil do 0.00 else Float.round(payroll_paye_prev_item, 2) end


    payroll_paye_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>010"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    payroll_paye_dr_prev_item = Repo.all(payroll_paye_dr_prev)|> hd
    payroll_paye_dr_prev_item_amt = if payroll_paye_dr_prev_item == nil do 0.00 else Float.round(payroll_paye_dr_prev_item, 2) end

    payroll_paye_prev_item_amt_result = payroll_paye_dr_prev_item_amt - payroll_paye_prev_item_amt


    IO.inspect payroll_paye_item_amt, label: "payroll_paye_item_amt ------------------------------------"

    payroll_napsa = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>020"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    payroll_napsa_item = Repo.all(payroll_napsa)|> hd
    payroll_napsa_item_amt = if payroll_napsa_item == nil do 0.00 else Float.round(payroll_napsa_item, 2) end

    payroll_napsa_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>020"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    payroll_napsa_dr_item = Repo.all(payroll_napsa_dr)|> hd
    payroll_napsa_dr_item_amt = if payroll_napsa_dr_item == nil do 0.00 else Float.round(payroll_napsa_dr_item, 2) end

    payroll_napsa_item_amt_result = payroll_napsa_dr_item_amt - payroll_napsa_item_amt

    payroll_napsa_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>020"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    payroll_napsa_prev_item = Repo.all(payroll_napsa_prev)|> hd
    payroll_napsa_prev_item_amt = if payroll_napsa_prev_item == nil do 0.00 else Float.round(payroll_napsa_prev_item, 2) end

    payroll_napsa_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>020"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    payroll_napsa_dr_prev_item = Repo.all(payroll_napsa_dr_prev)|> hd
    payroll_napsa_dr_prev_item_amt = if payroll_napsa_dr_prev_item == nil do 0.00 else Float.round(payroll_napsa_dr_prev_item, 2) end

    payroll_napsa_prev_item_amt_result = payroll_napsa_dr_prev_item_amt - payroll_napsa_prev_item_amt



    IO.inspect payroll_napsa_item_amt, label: "payroll_napsa_item_amt ------------------------------------"

    nhis_payable = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>040"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    nhis_payable_item = Repo.all(nhis_payable)|> hd
    nhis_payable_item_amt = if nhis_payable_item == nil do 0.00 else Float.round(nhis_payable_item, 2) end

    nhis_payable_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>040"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    nhis_payable_dr_item = Repo.all(nhis_payable_dr)|> hd
    nhis_payable_dr_item_amt = if nhis_payable_dr_item == nil do 0.00 else Float.round(nhis_payable_dr_item, 2) end

    nhis_payable_item_amt_result = nhis_payable_dr_item_amt - nhis_payable_item_amt

    nhis_payable_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>040"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    nhis_payable_prev_item = Repo.all(nhis_payable_prev)|> hd
    nhis_payable_prev_item_amt = if nhis_payable_prev_item == nil do 0.00 else Float.round(nhis_payable_prev_item, 2) end

    nhis_payable_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>040"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    nhis_payable_dr_prev_item = Repo.all(nhis_payable_dr_prev)|> hd
    nhis_payable_dr_prev_item_amt = if nhis_payable_dr_prev_item == nil do 0.00 else Float.round(nhis_payable_dr_prev_item, 2) end

    nhis_payable_prev_item_amt_result = nhis_payable_dr_prev_item_amt - nhis_payable_prev_item_amt



    IO.inspect nhis_payable_item_amt, label: "nhis_payable_item_amt ------------------------------------"

    prov_for_leave_pay = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>050"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    prov_for_leave_pay_item = Repo.all(prov_for_leave_pay)|> hd
    prov_for_leave_pay_item_amt = if prov_for_leave_pay_item == nil do 0.00 else Float.round(prov_for_leave_pay_item, 2) end

    prov_for_leave_pay_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>050"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    prov_for_leave_pay_dr_item = Repo.all(prov_for_leave_pay_dr)|> hd
    prov_for_leave_pay_dr_item_amt = if prov_for_leave_pay_dr_item == nil do 0.00 else Float.round(prov_for_leave_pay_dr_item, 2) end

    prov_for_leave_pay_item_amt_result = prov_for_leave_pay_dr_item_amt - prov_for_leave_pay_item_amt


    prov_for_leave_pay_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>050"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    prov_for_leave_pay_prev_item = Repo.all(prov_for_leave_pay_prev)|> hd
    prov_for_leave_pay_prev_item_amt = if prov_for_leave_pay_prev_item == nil do 0.00 else Float.round(prov_for_leave_pay_prev_item, 2) end

    prov_for_leave_pay_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>050"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    prov_for_leave_pay_dr_prev_item = Repo.all(prov_for_leave_pay_dr_prev)|> hd
    prov_for_leave_pay_dr_prev_item_amt = if prov_for_leave_pay_dr_prev_item == nil do 0.00 else Float.round(prov_for_leave_pay_dr_prev_item, 2) end

    prov_for_leave_pay_prev_item_amt_result = prov_for_leave_pay_dr_prev_item_amt - prov_for_leave_pay_prev_item_amt



    IO.inspect prov_for_leave_pay_item_amt, label: "prov_for_leave_pay_item_amt ------------------------------------"


    net_pay = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>030"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    net_pay_item = Repo.all(net_pay)|> hd
    net_pay_item_amt = if net_pay_item == nil do 0.00 else Float.round(net_pay_item, 2) end

    net_pay_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>030"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    net_pay_dr_item = Repo.all(net_pay_dr)|> hd
    net_pay_dr_item_amt = if net_pay_dr_item == nil do 0.00 else Float.round(net_pay_dr_item, 2) end

    net_pay_item_amt_result = net_pay_dr_item_amt - net_pay_item_amt


    net_pay_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>030"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    net_pay_prev_item = Repo.all(net_pay_prev)|> hd
    net_pay_prev_item_amt = if net_pay_prev_item == nil do 0.00 else Float.round(net_pay_prev_item, 2) end

    net_pay_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>030"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    net_pay_dr_prev_item = Repo.all(net_pay_dr_prev)|> hd
    net_pay_dr_prev_item_amt = if net_pay_dr_prev_item == nil do 0.00 else Float.round(net_pay_dr_prev_item, 2) end

    net_pay_prev_item_amt_result = net_pay_dr_prev_item_amt - net_pay_prev_item_amt



    IO.inspect net_pay_item_amt, label: "net_pay_item_amt ------------------------------------"

    income_tax_payable = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9600"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    income_tax_payable_item = Repo.all(income_tax_payable)|> hd
    income_tax_payable_item_amt = if income_tax_payable_item == nil do 0.00 else Float.round(income_tax_payable_item, 2) end

    income_tax_payable_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9600"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    income_tax_payable_dr_item = Repo.all(income_tax_payable_dr)|> hd
    income_tax_payable_dr_item_amt = if income_tax_payable_dr_item == nil do 0.00 else Float.round(income_tax_payable_dr_item, 2) end

    income_tax_payable_item_amt_result = income_tax_payable_dr_item_amt - income_tax_payable_item_amt

    income_tax_payable_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9600"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    income_tax_payable_prev_item = Repo.all(income_tax_payable_prev)|> hd
    income_tax_payable_prev_item_amt = if income_tax_payable_prev_item == nil do 0.00 else Float.round(income_tax_payable_prev_item, 2) end

    income_tax_payable_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9600"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    income_tax_payable_dr_prev_item = Repo.all(income_tax_payable_dr_prev)|> hd
    income_tax_payable_dr_prev_item_amt = if income_tax_payable_dr_prev_item == nil do 0.00 else Float.round(income_tax_payable_dr_prev_item, 2) end

    income_tax_payable_prev_item_amt_result = income_tax_payable_dr_prev_item_amt - income_tax_payable_prev_item_amt


    IO.inspect income_tax_payable_item_amt, label: "income_tax_payable_item_amt ------------------------------------"

    prov_for_wht = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>070"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    prov_for_wht_item = Repo.all(prov_for_wht)|> hd
    prov_for_wht_item_amt = if prov_for_wht_item == nil do 0.00 else Float.round(prov_for_wht_item, 2) end


    prov_for_wht_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>070"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    prov_for_wht_dr_item = Repo.all(prov_for_wht_dr)|> hd
    prov_for_wht_dr_item_amt = if prov_for_wht_dr_item == nil do 0.00 else Float.round(prov_for_wht_dr_item, 2) end

    prov_for_wht_item_amt_result = prov_for_wht_dr_item_amt - prov_for_wht_item_amt


   prov_for_wht_prev = from u in Journal_entries,
   where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9200>070"  and u.process_status == "APPROVED",
   where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
   select: sum(u.lcy_amount)
   prov_for_wht_prev_item = Repo.all(prov_for_wht_prev)|> hd
   prov_for_wht_prev_item_amt = if prov_for_wht_prev_item == nil do 0.00 else Float.round(prov_for_wht_prev_item, 2) end


   prov_for_wht_dr_prev = from u in Journal_entries,
   where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9200>070"  and u.process_status == "APPROVED",
   where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
   select: sum(u.lcy_amount)
   prov_for_wht_dr_prev_item = Repo.all(prov_for_wht_dr_prev)|> hd
   prov_for_wht_dr_prev_item_amt = if prov_for_wht_dr_prev_item == nil do 0.00 else Float.round(prov_for_wht_dr_prev_item, 2) end

   prov_for_wht_prev_item_amt_result = prov_for_wht_dr_prev_item_amt - prov_for_wht_prev_item_amt



    IO.inspect prov_for_wht_item_amt, label: "prov_for_wht_item_amt ------------------------------------"


    gnc_fuel_drawings = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9310"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    gnc_fuel_drawings_item = Repo.all(gnc_fuel_drawings)|> hd
    gnc_fuel_drawings_item_amt = if gnc_fuel_drawings_item == nil do 0.00 else Float.round(gnc_fuel_drawings_item, 2) end

    gnc_fuel_drawings_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9310"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    gnc_fuel_drawings_dr_item = Repo.all(gnc_fuel_drawings_dr)|> hd
    gnc_fuel_drawings_dr_item_amt = if gnc_fuel_drawings_dr_item == nil do 0.00 else Float.round(gnc_fuel_drawings_dr_item, 2) end

    gnc_fuel_drawings_item_amt_result = gnc_fuel_drawings_dr_item_amt - gnc_fuel_drawings_item_amt

    gnc_fuel_drawings_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9310"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    gnc_fuel_drawings_prev_item = Repo.all(gnc_fuel_drawings_prev)|> hd
    gnc_fuel_drawings_prev_item_amt = if gnc_fuel_drawings_prev_item == nil do 0.00 else Float.round(gnc_fuel_drawings_prev_item, 2) end

    gnc_fuel_drawings_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9310"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    gnc_fuel_drawings_dr_prev_item = Repo.all(gnc_fuel_drawings_dr_prev)|> hd
    gnc_fuel_drawings_dr_prev_item_amt = if gnc_fuel_drawings_dr_prev_item == nil do 0.00 else Float.round(gnc_fuel_drawings_dr_prev_item, 2) end

    gnc_fuel_drawings_prev_item_amt_result = gnc_fuel_drawings_dr_prev_item_amt - gnc_fuel_drawings_prev_item_amt



    IO.inspect gnc_fuel_drawings_item_amt, label: "gnc_fuel_drawings_item_amt ------------------------------------"


    provision_cash = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9450"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    provision_cash_item = Repo.all(provision_cash)|> hd
    provision_cash_item_amt = if provision_cash_item == nil do 0.00 else Float.round(provision_cash_item, 2) end

    provision_cash_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9450"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    provision_cash_dr_item = Repo.all(provision_cash_dr)|> hd
    provision_cash_dr_item_amt = if provision_cash_dr_item == nil do 0.00 else Float.round(provision_cash_dr_item, 2) end

    provision_cash_item_amt_result = provision_cash_dr_item_amt - provision_cash_item_amt

    provision_cash_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9450"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    provision_cash_prev_item = Repo.all(provision_cash_prev)|> hd
    provision_cash_prev_item_amt = if provision_cash_prev_item == nil do 0.00 else Float.round(provision_cash_prev_item, 2) end

    provision_cash_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9450"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    provision_cash_dr_prev_item = Repo.all(provision_cash_dr_prev)|> hd
    provision_cash_dr_prev_item_amt = if provision_cash_dr_prev_item == nil do 0.00 else Float.round(provision_cash_dr_prev_item, 2) end

    provision_cash_prev_item_amt_result = provision_cash_dr_prev_item_amt - provision_cash_prev_item_amt


    IO.inspect provision_cash_item_amt, label: "provision_cash_item_amt ------------------------------------"


    other_current_liabilities = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9700"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    other_current_liabilities_item = Repo.all(other_current_liabilities)|> hd
    other_current_liabilities_item_amt = if other_current_liabilities_item == nil do 0.00 else Float.round(other_current_liabilities_item, 2) end

    other_current_liabilities_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9700"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    other_current_liabilities_dr_item = Repo.all(other_current_liabilities_dr)|> hd
    other_current_liabilities_dr_item_amt = if other_current_liabilities_dr_item == nil do 0.00 else Float.round(other_current_liabilities_dr_item, 2) end

    other_current_liabilities_item_amt_result = other_current_liabilities_dr_item_amt - other_current_liabilities_item_amt

    other_current_liabilities_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9700"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    other_current_liabilities_prev_item = Repo.all(other_current_liabilities_prev)|> hd
    other_current_liabilities_prev_item_amt = if other_current_liabilities_prev_item == nil do 0.00 else Float.round(other_current_liabilities_prev_item, 2) end

    other_current_liabilities_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9700"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    other_current_liabilities_dr_prev_item = Repo.all(other_current_liabilities_dr_prev)|> hd
    other_current_liabilities_dr_prev_item_amt = if other_current_liabilities_dr_prev_item == nil do 0.00 else Float.round(other_current_liabilities_dr_prev_item, 2) end

    other_current_liabilities_prev_item_amt_result = other_current_liabilities_dr_prev_item_amt - other_current_liabilities_prev_item_amt



    IO.inspect other_current_liabilities_item_amt, label: "other_current_liabilities_item_amt ------------------------------------"


    provision_for_interest_suspended = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9760"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    provision_for_interest_suspended_item = Repo.all(provision_for_interest_suspended)|> hd
    provision_for_interest_suspended_item_amt = if provision_for_interest_suspended_item == nil do 0.00 else Float.round(provision_for_interest_suspended_item, 2) end



    provision_for_interest_suspended_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9760"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    provision_for_interest_suspended_dr_item = Repo.all(provision_for_interest_suspended_dr)|> hd
    provision_for_interest_suspended_dr_item_amt = if provision_for_interest_suspended_dr_item == nil do 0.00 else Float.round(provision_for_interest_suspended_dr_item, 2) end

    provision_for_interest_suspended_item_amt_result = provision_for_interest_suspended_dr_item_amt - provision_for_interest_suspended_item_amt


    provision_for_interest_suspended_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9760"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    provision_for_interest_suspended_prev_item = Repo.all(provision_for_interest_suspended_prev)|> hd
    provision_for_interest_suspended_prev_item_amt = if provision_for_interest_suspended_prev_item == nil do 0.00 else Float.round(provision_for_interest_suspended_prev_item, 2) end



    provision_for_interest_suspended_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9760"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    provision_for_interest_suspended_dr_prev_item = Repo.all(provision_for_interest_suspended_dr_prev)|> hd
    provision_for_interest_suspended_dr_prev_item_amt = if provision_for_interest_suspended_dr_prev_item == nil do 0.00 else Float.round(provision_for_interest_suspended_dr_prev_item, 2) end

    provision_for_interest_suspended_prev_item_amt_result = provision_for_interest_suspended_dr_prev_item_amt - provision_for_interest_suspended_prev_item_amt



    IO.inspect provision_for_interest_suspended_item_amt, label: "provision_for_interest_suspended_item_amt ------------------------------------"


    unrecognised_customer = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9350"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    unrecognised_customer_item = Repo.all(unrecognised_customer)|> hd
    unrecognised_customer_item_amt = if unrecognised_customer_item == nil do 0.00 else Float.round(unrecognised_customer_item, 2) end

    unrecognised_customer_dr = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9350"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt, ^end_dt),
    select: sum(u.lcy_amount)
    unrecognised_customer_dr_item = Repo.all(unrecognised_customer_dr)|> hd
    unrecognised_customer_dr_item_amt = if unrecognised_customer_dr_item == nil do 0.00 else Float.round(unrecognised_customer_dr_item, 2) end

    unrecognised_customer_item_amt_result = unrecognised_customer_dr_item_amt - unrecognised_customer_item_amt

    unrecognised_customer_prev = from u in Journal_entries,
    where: u.drcr_ind == "C" and u.event == "JE" and u.account_no == "9350"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    unrecognised_customer_prev_item = Repo.all(unrecognised_customer_prev)|> hd
    unrecognised_customer_prev_item_amt = if unrecognised_customer_prev_item == nil do 0.00 else Float.round(unrecognised_customer_prev_item, 2) end

    unrecognised_customer_dr_prev = from u in Journal_entries,
    where: u.drcr_ind == "D" and u.event == "JE" and u.account_no == "9350"  and u.process_status == "APPROVED",
    where: fragment("CAST(? AS date) BETWEEN ? AND ?", u.inserted_at, ^start_dt_prev_year, ^end_dt_prev_year),
    select: sum(u.lcy_amount)
    unrecognised_customer_dr_prev_item = Repo.all(unrecognised_customer_dr_prev)|> hd
    unrecognised_customer_dr_prev_item_amt = if unrecognised_customer_dr_prev_item == nil do 0.00 else Float.round(unrecognised_customer_dr_prev_item, 2) end

    unrecognised_customer_prev_item_amt_result = unrecognised_customer_dr_prev_item_amt - unrecognised_customer_prev_item_amt



    IO.inspect unrecognised_customer_item_amt, label: "unrecognised_customer_item_amt ------------------------------------"

    total_current_liabilities = 0
    total_liabilities = 0
    total_equity_and_liabilities = 0



   %{
    computer_equipment: computer_equipment_item_amt_result,
    furniture_fittings: furniture_fittings_item_amt_result,
    land_building: land_and_building_item_amt_result,
    motor_vehicles: motor_vehicle_item_amt_result,
    office_equipment: office_equipment_item_amt_result,
    intangible_assets: intangible_assets,
    total_property_plant_equipment: total_property_plant_equipment,
    gross_loans_and_advances: gross_loans_and_advances_item_amt_result,
    provision_for_bad_debts: provision_for_bad_debts_item_amt_result,
    net_loans_and_advances: net_loans_and_advances,
    stock: stock_item_amt_result,
    loans_and_advances: loans_and_advances_item_amt,
    staff_loans: staff_loans_item_amt_result,
    prepayments: prepayments_item_amt_result,
    gnr_intercompany: gnr_intercompany_item_amt_result,
    puma_dijifuel: puma_dijifuel_item_amt_result,
    speedpay: speedpay_item_amt_result,
    sundry_receivables: sundry_receivables_item_amt_result,
    deffered_tax_asset: deffered_tax_asset_item_amt_result,
    other_current_assets: other_current_assets_item_amt_result,
    zanaco: zanaco_item_amt_result,
    fnb: fnb_item_amt_result,
    airtel_money: airtel_money_item_amt_result,
    diji_fuel_universal: diji_fuel_universal_item_amt_result,
    mtn_money: mtn_money_item_amt_result,
    zanaco_kabwata: zanaco_kabwata_item_amt_result,
    zanaco_comesa: zanaco_comesa_item_amt_result,
    comesa_agency_fnb: comesa_agency_fnb_item_amt_result,
    kangwa_agency: kangwa_agency_item_amt_result,
    kabwata_agency: kabwata_agency_item_amt_result,
    kabwata_sda_agency: kabwata_sda_agency_item_amt_result,
    head_office_agency: head_office_agency_item_amt_result,
    digital_app_instant_loan: digital_app_instant_loan_item_amt_result,
    choppies_cross_roads: choppies_cross_roads_item_amt_result,
    choppies_chalala: choppies_chalala_item_amt_result,
    choppies_ibex: choppies_ibex_item_amt_result,
    instant_loans: instant_loans_item_amt_result,
    choppies_chamba_valley: choppies_chamba_valley_item_amt_result,
    instant_loans_kuku: instant_loans_kuku_item_amt_result,
    eco_bank_float_account: eco_bank_float_account_item_amt_result,
    petty_cash: petty_cash_item_amt_result,
    total_cash_and_cash_equivalents: total_cash_and_cash_equivalents,
    total_current_assets: total_current_assets,
    total_assets: total_assets,
    ordinary_capital: ordinary_capital_item_amt_result,
    share_premium: share_premium_item_amt_result,
    reserves_prior_year_adjustments: reserves_prior_year_adjustments_item_amt_result,
    share_capital_issue: share_capital_issue_item_amt_result,
    retained_earnings_accumulated: retained_earnings_accumulated_item_amt_result,
    retained_earnings_Current_year: retained_earnings_Current_year_item_amt_result,
    total_equity: total_equity,
    gnr_inter_company_loans: gnr_inter_company_loans_item_amt,
    gnp_intercompany_liabilities: gnp_intercompany_liabilities_item_amt,
    other_non_current_liabilities: other_non_current_liabilities_item_amt,
    total_non_current_liabilities: total_non_current_liabilities,
    bridging_finance: bridging_finance_item_amt_result,
    undeposited_funds: undeposited_funds_item_amt,
    accruals: accruals_item_amt_result,
    provision_for_interest: provision_for_interest_item_amt_result,
    sundry_payables: sundry_payables_item_amt_result,
    trade_payables: trade_payables_item_amt,
    related_party_borrowings: related_party_borrowings_item_amt_result,
    payroll_paye: payroll_paye_item_amt_result,
    payroll_napsa: payroll_napsa_item_amt_result,
    nhis_payable: nhis_payable_item_amt_result,
    prov_for_leave_pay: prov_for_leave_pay_item_amt_result,
    net_pay: net_pay_item_amt_result,
    income_tax_payable: income_tax_payable_item_amt_result,
    prov_for_wht: prov_for_wht_item_amt_result,
    gnc_fuel_drawings: gnc_fuel_drawings_item_amt_result,
    provision_cash: provision_cash_item_amt_result,
    other_current_liabilities: other_current_liabilities_item_amt_result,
    provision_for_interest_suspended: provision_for_interest_suspended_item_amt_result,
    unrecognised_customer: unrecognised_customer_item_amt_result,
    total_current_liabilities: total_current_liabilities,
    total_liabilities: total_liabilities,
    total_equity_and_liabilities: total_equity_and_liabilities,
    total_cash_and_cash_equivalents: total_cash_and_cash_equivalents,
    total_current_assets: total_current_assets,

    prev_computer_equipment: computer_equipment_item_amt_result_prev,
    prev_furniture_fittings: furniture_fittings_dr_prev_item_amt_result,
    prev_land_building: land_and_building_dr_prev_item_amt_result,
    prev_motor_vehicles: motor_vehicle_prev_item_amt_result,
    prev_office_equipment: office_equipment_prev_item_amt_result,
    prev_intangible_assets: intangible_assets,
    prev_total_property_plant_equipment: total_property_plant_equipment,
    prev_gross_loans_and_advances: gross_loans_and_advances_prev_item_amt_result,
    prev_provision_for_bad_debts: provision_for_bad_debts_item_amt_prev_result,
    prev_net_loans_and_advances: net_loans_and_advances,
    prev_stock: stock_prev_item_amt_result,
    prev_loans_and_advances: loans_and_advances_item_amt,
    prev_staff_loans: staff_loans_prev_item_amt_result,
    prev_prepayments: prepayments_prev_item_amt_result,
    prev_gnr_intercompany: gnr_intercompany_prev_item_amt_result,
    prev_puma_dijifuel: puma_dijifuel_prev_item_amt_result,
    prev_speedpay: speedpay_prev_item_amt_result,
    prev_sundry_receivables: sundry_receivables_prev_item_amt_result,
    prev_deffered_tax_asset: deffered_tax_asset_prev_item_amt_result,
    prev_other_current_assets: other_current_assets_prev_item_amt_result,
    prev_zanaco: zanaco_prev_item_amt_result,
    prev_fnb: fnb_prev_item_amt_result,
    prev_airtel_money: airtel_money_prev_item_amt_result,
    prev_diji_fuel_universal: diji_fuel_universal_prev_item_amt_result,
    prev_mtn_money: mtn_money_prev_item_amt_result,
    prev_zanaco_kabwata: zanaco_kabwata_prev_item_amt_result,
    prev_zanaco_comesa: zanaco_comesa_prev_item_amt_result,
    prev_comesa_agency_fnb: comesa_agency_fnb_prev_item_amt_result,
    prev_kangwa_agency: kangwa_agency_prev_item_amt_result,
    prev_kabwata_agency: kabwata_agency_prev_item_amt_result,
    prev_kabwata_sda_agency: kabwata_sda_agency_prev_item_amt_result,
    prev_head_office_agency: head_office_agency_prev_item_amt_result,
    prev_digital_app_instant_loan: digital_app_instant_loan_prev_item_amt_result,
    prev_choppies_cross_roads: choppies_cross_roads_prev_item_amt_result,
    prev_choppies_chalala: choppies_chalala_prev_item_amt_result,
    prev_choppies_ibex: choppies_ibex_prev_item_amt_result,
    prev_instant_loans: instant_loans_prev_item_amt_result,
    prev_choppies_chamba_valley: choppies_chamba_valley_prev_item_amt_result,
    prev_instant_loans_kuku: instant_loans_kuku_prev_item_amt_result,
    prev_eco_bank_float_account: eco_bank_float_account_prev_item_amt_result,
    prev_petty_cash: petty_cash_prev_item_amt_result,
    prev_total_cash_and_cash_equivalents: total_cash_and_cash_equivalents,
    prev_total_current_assets: total_current_assets,
    prev_total_assets: total_assets,
    prev_ordinary_capital: ordinary_capital_prev_item_amt_result,
    prev_share_premium: share_premium_prev_item_amt_result,
    prev_reserves_prior_year_adjustments: reserves_prior_year_adjustments_prev_item_amt_result,
    prev_share_capital_issue: share_capital_issue_prev_item_amt_result,
    prev_retained_earnings_accumulated: retained_earnings_accumulated_prev_item_amt_result,
    prev_retained_earnings_Current_year: retained_earnings_Current_year_prev_item_amt_result,
    prev_total_equity: total_equity,
    prev_gnr_inter_company_loans: gnr_inter_company_loans_item_amt,
    prev_gnp_intercompany_liabilities: gnp_intercompany_liabilities_item_amt,
    prev_other_non_current_liabilities: other_non_current_liabilities_item_amt,
    prev_total_non_current_liabilities: total_non_current_liabilities,
    prev_bridging_finance: bridging_finance_prev_item_amt_result,
    prev_undeposited_funds: undeposited_funds_item_amt,
    prev_accruals: accruals_prev_item_amt_result,
    prev_provision_for_interest: provision_for_interest_prev_item_amt_result,
    prev_sundry_payables: sundry_payables_prev_item_amt_result,
    prev_trade_payables: trade_payables_item_amt,
    prev_related_party_borrowings: related_party_borrowings_prev_item_amt_result,
    prev_payroll_paye: payroll_paye_prev_item_amt_result,
    prev_payroll_napsa: payroll_napsa_prev_item_amt_result,
    prev_nhis_payable: nhis_payable_prev_item_amt_result,
    prev_prov_for_leave_pay: prov_for_leave_pay_prev_item_amt_result,
    prev_net_pay: net_pay_item_amt_result,
    prev_income_tax_payable: income_tax_payable_prev_item_amt_result,
    prev_prov_for_wht: prov_for_wht_prev_item_amt_result,
    prev_gnc_fuel_drawings: gnc_fuel_drawings_prev_item_amt_result,
    prev_provision_cash: provision_cash_prev_item_amt_result,
    prev_other_current_liabilities: other_current_liabilities_item_amt_result,
    prev_provision_for_interest_suspended: provision_for_interest_suspended_prev_item_amt_result,
    prev_unrecognised_customer: unrecognised_customer_prev_item_amt_result,
    prev_total_current_liabilities: total_current_liabilities,
    prev_total_liabilities: total_liabilities,
    prev_total_equity_and_liabilities: total_equity_and_liabilities,
    prev_total_cash_and_cash_equivalents: total_cash_and_cash_equivalents,
    prev_total_current_assets: total_current_assets,

   }





  end







end
