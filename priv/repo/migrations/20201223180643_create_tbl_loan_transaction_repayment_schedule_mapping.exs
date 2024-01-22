defmodule LoanSystem.Repo.Migrations.CreateTblLoanTransactionRepaymentScheduleMapping do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_transaction_repayment_schedule_mapping) do
      add :loan_transaction_id, :integer
      add :loan_repayment_schedule_id, :integer
      add :amount, :float
      add :principal_portion_derived, :float
      add :interest_portion_derived, :float
      add :fee_charges_portion_derived, :float
      add :penalty_charges_portion_derived, :float

      timestamps()
    end

  end
end
