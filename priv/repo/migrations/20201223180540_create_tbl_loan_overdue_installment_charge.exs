defmodule LoanSystem.Repo.Migrations.CreateTblLoanOverdueInstallmentCharge do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_overdue_installment_charge) do
      add :loan_charge_id, :integer
      add :loan_schedule_id, :integer
      add :overdue_amount, :float

      timestamps()
    end

  end
end
