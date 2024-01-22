defmodule LoanSavingsSystem.Jobs.UpdateSuccessfulRepaymentLoanBal do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Loan.LoanRepayment
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.{Repo, Logs.UserLogs}
  alias Loanmanagementsystem.Core_transaction.Journal_entries
  alias Loanmanagementsystem.Loan.LoanTransaction

  def update_all_successful_loan_repayment_bal do
    with(
      loan_repayment_details when loan_repayment_details != [] <-
        Loanmanagementsystem.Loan.Loans.where(loan_status: "DISBURSED")
    ) do
      loan_repayment_details
      |> Enum.map(fn success_repayment_details ->
        with(
          repayment_details when repayment_details != [] <-
            Loanmanagementsystem.Loan.LoanRepayment.where(
              loan_id: success_repayment_details.id,
              status: "SUCCESS"
            )
        ) do
          repayment_details
          |> Enum.map(fn successful_repaid ->
            repayment_params =
              handle_repayment_bal_update(success_repayment_details, successful_repaid)

            activity_log_params = handle_activity_logs_params(successful_repaid)
            dr_params = handle_dr_trans_log_journal_entry_posting(successful_repaid)
            cr_params = handle_cr_trans_log_journal_entry_posting(successful_repaid)
            loan_transaction_log = handle_loan_transaction_posting(successful_repaid)

            cond do
              repayment_params == nil ->
                Ecto.Multi.new()

              true ->
                Ecto.Multi.new()
                |> Ecto.Multi.update(
                  {:success_repayment_details, success_repayment_details.id,
                   "#{Ecto.UUID.generate()}"},
                  Loans.changeset(success_repayment_details, repayment_params)
                )
                |> Ecto.Multi.update(
                  {:successful_repaid, successful_repaid.id, "#{Ecto.UUID.generate()}"},
                  LoanRepayment.changeset(successful_repaid, %{status: "PAYMENT_COLLECTED"})
                )
                |> Ecto.Multi.insert(
                  {:userlogs, successful_repaid.id, "#{Ecto.UUID.generate()}"},
                  UserLogs.changeset(%UserLogs{}, activity_log_params)
                )
                |> Ecto.Multi.insert(
                  {:userlogs, successful_repaid.id, "#{Ecto.UUID.generate()}"},
                  Journal_entries.changeset(%Journal_entries{}, dr_params)
                )
                |> Ecto.Multi.insert(
                  {:userlogs, successful_repaid.id, "#{Ecto.UUID.generate()}"},
                  Journal_entries.changeset(%Journal_entries{}, cr_params)
                )
                |> Ecto.Multi.insert(
                  {:loan_transaction_log, successful_repaid.id, "#{Ecto.UUID.generate()}"},
                  LoanTransaction.changeset(%LoanTransaction{}, loan_transaction_log)
                )
            end
          end)
        else
          _ ->
            Ecto.Multi.new()
        end
      end)
      |> List.flatten()
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
    else
      _ ->
        "There are no repayments transactions found."
    end
  end

  defp handle_repayment_bal_update(success_repayment_details, successful_repaid) do
    balance = success_repayment_details.balance
    amount_repaid = successful_repaid.amountRepaid
    bal = balance - amount_repaid

    %{
      balance: bal
    }
  end

  defp handle_activity_logs_params(successful_repaid) do
    %{
      activity:
        "Loan Repayment was successful worth #{successful_repaid.amountRepaid |> Number.Delimit.number_to_delimited()} ",
      user_id: successful_repaid.registeredByUserId
    }
  end

  defp handle_dr_trans_log_journal_entry_posting(successful_repaid) do
    loan_details = Loanmanagementsystem.Loan.Loans.find_by(id: successful_repaid.loan_id)

    currencyname =
      Loanmanagementsystem.Products.Product.find_by(id: loan_details.product_id).currencyName

    currency_code =
      if currencyname == nil || currencyname == "" do
        ""
      else
        currencyname
      end

    firstName =
      Loanmanagementsystem.Accounts.UserBioData.find_by(
        userId: successful_repaid.registeredByUserId
      ).firstName

    %{
      module: "Loan Repayment",
      event: "LRP",
      account_no: "11111",
      account_name: firstName,
      currency: currency_code,
      drcr_ind: "D",
      fcy_amount:
        if String.upcase(currency_code) == "ZMW" do
          0
        else
          successful_repaid.amountRepaid
        end,
      lcy_amount:
        if String.upcase(currency_code) == "ZMW" do
          successful_repaid.amountRepaid
        else
          0
        end,
      financial_cycle: "FY#{Timex.today().year}",
      period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
      product: successful_repaid.loan_product,
      trn_dt: to_string(Timex.today()),
      value_dt: to_string(Timex.today()),
      user_id: to_string(successful_repaid.registeredByUserId),
      auth_status: "APPROVED",
      process_status: "APPROVED",
      batch_status: "APPROVED",
      account_category: "Asset",
      narration:
        "Loan Repayment by #{firstName} worth: #{successful_repaid.amountRepaid |> Number.Delimit.number_to_delimited()}"
    }
  end

  defp handle_cr_trans_log_journal_entry_posting(successful_repaid) do
    loan_details = Loanmanagementsystem.Loan.Loans.find_by(id: successful_repaid.loan_id)

    currencyname =
      Loanmanagementsystem.Products.Product.find_by(id: loan_details.product_id).currencyName

    currency_code =
      if currencyname == nil || currencyname == "" do
        ""
      else
        currencyname
      end

    firstName =
      Loanmanagementsystem.Accounts.UserBioData.find_by(
        userId: successful_repaid.registeredByUserId
      ).firstName

    %{
      module: "Loan Repayment",
      event: "LRP",
      account_no: "11111",
      account_name: firstName,
      currency: currency_code,
      drcr_ind: "C",
      fcy_amount:
        if String.upcase(currency_code) == "ZMW" do
          0
        else
          successful_repaid.amountRepaid
        end,
      lcy_amount:
        if String.upcase(currency_code) == "ZMW" do
          successful_repaid.amountRepaid
        else
          0
        end,
      financial_cycle: "FY#{Timex.today().year}",
      period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
      product: successful_repaid.loan_product,
      trn_dt: to_string(Timex.today()),
      value_dt: to_string(Timex.today()),
      user_id: to_string(successful_repaid.registeredByUserId),
      auth_status: "APPROVED",
      process_status: "APPROVED",
      batch_status: "APPROVED",
      account_category: "Asset",
      narration:
        "Loan Repayment by #{firstName} worth: #{successful_repaid.amountRepaid |> Number.Delimit.number_to_delimited()}"
    }
  end

  defp handle_loan_transaction_posting(successful_repaid) do
    case successful_repaid.bank_account_no == nil || successful_repaid.bank_account_no == "" do
      true ->
        %{
          transaction_ref: successful_repaid.reference_no,
          mno_type: successful_repaid.modeOfRepayment,
          mno_mobile_no: successful_repaid.mno_mobile_no,
          customer_id: successful_repaid.registeredByUserId,
          amount: successful_repaid.amountRepaid,
          loan_id: successful_repaid.loan_id,
          transaction_date: successful_repaid.dateOfRepayment,
          narration: "Receipt Mobile Money Repayment #{successful_repaid.mno_mobile_no}",
          drcr_ind: "C"
        }

      false ->
        %{
          transaction_ref: successful_repaid.reference_no,
          bank_name: successful_repaid.bank_name,
          bank_branch: successful_repaid.branch_name,
          bank_account_no: successful_repaid.bank_account_no,
          bank_account_name: successful_repaid.account_name,
          bank_swift_code: successful_repaid.swift_code,
          customer_id: successful_repaid.registeredByUserId,
          amount: successful_repaid.amountRepaid,
          loan_id: successful_repaid.loan_id,
          transaction_date: successful_repaid.dateOfRepayment,
          narration: "Repayment from Bank Account no: #{successful_repaid.bank_account_no}",
          drcr_ind: "C"
        }
    end
  end

  defp execute_multi(multi) do
    multi
    |> Repo.transaction()
    |> case do
      {:ok, _result} ->
        nil

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        IO.inspect(failed_value)
        {:error, failed_value}
    end
  end
end
