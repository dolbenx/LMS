defmodule LoanSavingsSystem.Jobs.AccountBalanceUpdate do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Core_transaction.Journal_entries
  alias Loanmanagementsystem.Chart_of_accounts.Gl_balance
  alias Loanmanagementsystem.Repo

  def general_ledger_account_update do
    with(
      trans_details when trans_details != [] <- Journal_entries.where(process_status: "APPROVED"),
      gl_accounts when gl_accounts != [] <- Gl_balance.all()
    ) do
      trans_details
      |> Enum.map(fn trans ->
        gl_details = Enum.find(gl_accounts, fn gl -> gl.account_gl_number == trans.account_no  end)
        case trans.drcr_ind do
          "D" ->
          dr_params =  handle_general_ledger_update_dr_params(gl_details, trans)
          cond do
            dr_params == nil ->
              Ecto.Multi.new()
            true ->
            Ecto.Multi.new()
            |> Ecto.Multi.update({gl_details, gl_details.id, Ecto.UUID.generate()}, Gl_balance.changeset(gl_details, dr_params))
            |> Ecto.Multi.update({trans, trans.id, Ecto.UUID.generate()}, Journal_entries.changeset(trans, %{process_status: "SUCCESS"}))
            end
          "C" ->
          cr_params =  handle_general_ledger_update_cr_params(gl_details, trans)
          cond do
            cr_params == nil ->
              Ecto.Multi.new()
            true ->
            Ecto.Multi.new()
            |> Ecto.Multi.update({gl_details, gl_details.id, Ecto.UUID.generate()}, Gl_balance.changeset(gl_details, cr_params))
            |> Ecto.Multi.update({trans, trans.id, Ecto.UUID.generate()}, Journal_entries.changeset(trans, %{process_status: "SUCCESS"}))
            end
        end
      end)
      |> List.flatten
      |> Enum.reject(& !&1)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
    else
      _ ->
        {:error, "No transactions found."}
    end
  end

  def handle_general_ledger_update_dr_params(gl_details, trans) do
    if gl_details == nil do
      nil
    else
    dr_balance = gl_details.dr_balance
    txn_amount = Decimal.from_float(trans.lcy_amount)
    balance = Decimal.add(dr_balance, txn_amount)
   %{
    dr_balance: balance
    }
   end
  end

  def handle_general_ledger_update_cr_params(gl_details, trans) do
    if gl_details == nil do
      nil
    else
    cr_balance = gl_details.cr_balance
    txn_amount = Decimal.from_float(trans.lcy_amount)
    balance = Decimal.add(cr_balance, txn_amount)
   %{
    cr_balance: balance
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
