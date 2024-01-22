defmodule LoanSavingsSystem.Jobs.EndOfDay do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Loan.Loan_disbursement
  alias Loanmanagementsystem.{Repo, Logs.UserLogs}
  alias Loanmanagementsystem.Maintenance.Company_maintenance

  def init_end_of_day do
   Task.start(fn ->
    case Company_maintenance.first(1) do
      nil ->
        {:error, "No Records Found in Company Parameter"}
      company ->
      Ecto.Multi.new()
      |> Ecto.Multi.update(:update_company, Company_maintenance.changeset(company, %{eod_status: "Executed", eod_date: Timex.today}))
      |> Ecto.Multi.run(:update_eod_entries, fn _repo, _changes_so_far ->
          handle_loan_overwrite()
          |> case do
            nil ->
              {:ok, "EOD COMPLETE"}
            error ->
              error
          end
        end)
        |> Repo.transaction(timeout: :infinity)
        |> case do
        {:ok, _} ->
          nil
          |> case do
            nil -> %{status: 0, message: "Executed End of Day Successfully"}
            {:error, data} -> %{status: 1, message: data}
          end
        {:error, _, error, _} ->
          %{status: 1, message: error}
      end
    end
    end)
    %{status: 0, message: "End of Day Executing in Progress", reload: 1}
  end

  def handle_loan_overwrite do
    with(
      loan_details  when loan_details  != [] <- Loanmanagementsystem.Loan.Loans.where(closedon_date: Timex.today)
    ) do
      loan_details
      |> Enum.map(fn loan ->
        Ecto.Multi.new()
        |> Ecto.Multi.update({:loan, loan.id, "#{Ecto.UUID.generate()}"},Loans.changeset(loan, %{ status: "WRITTEN_OFF", loan_status: "WRITTEN_OFF", writtenoffon_date: Timex.today }))
      end)
      |> List.flatten()
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
    else
      _ ->
      nil
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
