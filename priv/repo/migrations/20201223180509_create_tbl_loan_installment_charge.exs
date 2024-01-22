defmodule LoanSystem.Repo.Migrations.CreateTblLoanInstallmentCharge do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_installment_charge) do
      add :loan_charge_id, :integer
      add :loan_schedule_id, :integer
      add :due_date, :date
      add :amount, :float
      add :amount_paid_derived, :float
      add :amount_waived_derived, :float
      add :amount_writtenoff_derived, :float
      add :amount_outstanding_derived, :float
      add :is_paid_derived, :boolean, default: false, null: false
      add :is_waived, :boolean, default: false, null: false

      timestamps()
    end

  end
end
