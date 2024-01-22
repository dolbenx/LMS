defmodule LoanSavingsSystem.Jobs.InitiateDisbursement do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Loan.Loan_disbursement
  alias Loanmanagementsystem.{Repo, Logs.UserLogs}

  def post_approved_loans_for_disbursement do
    with(
      loan_details when loan_details != [] <-
        Loanmanagementsystem.Loan.Loans.where(loan_status: "APPROVED")
    ) do
      loan_details
      |> Enum.map(fn approved_loans ->
        loan_disbursement_log = handle_loan_disbursement_params(approved_loans)

        cond do
          loan_disbursement_log == nil ->
            Ecto.Multi.new()

          true ->
            Ecto.Multi.new()
            |> Ecto.Multi.update(
              {:approved_loans, approved_loans.id, "#{Ecto.UUID.generate()}"},
              Loans.changeset(approved_loans, %{
                status: "PENDING_DISBURSEMENT",
                loan_status: "PENDING_DISBURSEMENT"
              })
            )
            |> Ecto.Multi.insert(
              {:loan_disbursement_log, approved_loans.id, "#{Ecto.UUID.generate()}"},
              Loan_disbursement.changeset(%Loan_disbursement{}, loan_disbursement_log)
            )
        end
      end)
      |> List.flatten()
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
    else
      _ ->
        "There are no loan approved to disburse."
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

  defp handle_loan_disbursement_params(approved_loans) do
    currency_acroynm =
      Loanmanagementsystem.Products.Product.find_by(id: approved_loans.product_id).currencyName

    %{
      loan_product: approved_loans.loan_type,
      currency: currency_acroynm,
      amount: approved_loans.principal_amount,
      disbursement_dt: to_string(approved_loans.disbursedon_date),
      mode_of_disbursement: approved_loans.disbursement_method,
      customer_mno_type: approved_loans.disbursement_method,
      customer_mno_mobile_no: approved_loans.receipient_number,
      customer_bank_name: approved_loans.bank_name,
      customer_bank_account_no: approved_loans.bank_account_no,
      customer_account_name: approved_loans.account_name,
      customer_expiry_month: approved_loans.expiry_month,
      customer_expiry_year: approved_loans.expiry_year,
      customer_cvv: approved_loans.cvv,
      maker_id: approved_loans.loan_userroleid,
      customer_id: approved_loans.customer_id,
      loan_id: approved_loans.id,
      product_id: approved_loans.product_id,
      status: approved_loans.loan_status,
      narration: " Disbursement "
    }
  end
end
