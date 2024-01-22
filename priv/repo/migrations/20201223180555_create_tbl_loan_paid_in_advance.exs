defmodule LoanSystem.Repo.Migrations.CreateTblLoanPaidInAdvance do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_paid_in_advance) do
      add :loan_id, :integer
      add :principal_in_advance_derived, :float
      add :interest_in_advance_derived, :float
      add :fee_charges_in_advance_derived, :float
      add :penalty_charges_in_advance_derived, :float
      add :total_in_advance_derived, :float

      timestamps()
    end

  end
end
