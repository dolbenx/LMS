defmodule LoanSavingsSystem.Repo.Migrations.CreateTblLoanRepaymentSchedule do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_repayment_schedule) do
      add :loan_id, :integer
      add :fromdate, :date
      add :duedate, :date
      add :installment, :float
      add :principal_amount, :float
      add :principal_completed_derived, :float
      add :principal_writtenoff_derived, :float
      add :interest_amount, :float
      add :interest_completed_derived, :float
      add :interest_writtenoff_derived, :float
      add :interest_waived_derived, :float
      add :accrual_interest_derived, :float
      add :fee_charges_amount, :float
      add :fee_charges_completed_derived, :float
      add :fee_charges_writtenoff_derived, :float
      add :fee_charges_waived_derived, :float
      add :accrual_fee_charges_derived, :float
      add :penalty_charges_amount, :float
      add :penalty_charges_completed_derived, :float
      add :penalty_charges_writtenoff_derived, :float
      add :penalty_charges_waived_derived, :float
      add :accrual_penalty_charges_derived, :float
      add :total_paid_in_advance_derived, :float
      add :total_paid_late_derived, :float
      add :completed_derived, :float
      add :createdby_id, :integer
      add :lastmodifiedby_id, :integer
      add :obligations_met_on_date, :date
      add :status, :string

      timestamps()
    end

  end
end
