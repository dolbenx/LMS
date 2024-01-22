defmodule LoanSystem.Repo.Migrations.CreateTblLoanCharge do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_charge) do
      add :loan_id, :integer
      add :charge_id, :integer
      add :is_penalty, :boolean, default: false, null: false
      add :charge_time_enum, :string
      add :due_for_collection_as_of_date, :date
      add :charge_calculation_enum, :string
      add :charge_payment_mode_enum, :string
      add :calculation_percentage, :float
      add :calculation_on_amount, :float
      add :charge_amount_or_percentage, :float
      add :amount, :float
      add :amount_paid_derived, :float
      add :amount_waived_derived, :float
      add :amount_writtenoff_derived, :float
      add :amount_outstanding_derived, :float
      add :is_paid_derived, :boolean, default: false, null: false
      add :is_waived, :boolean, default: false, null: false
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
