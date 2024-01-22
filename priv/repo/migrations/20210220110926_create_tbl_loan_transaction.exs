defmodule LoanSavingsSystem.Repo.Migrations.CreateTblLoanTransaction do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_transaction) do
      add :loan_id, :integer
      add :branch_id, :integer
      add :payment_detail_id, :integer
      add :is_reversed, :boolean, default: false, null: false
      add :external_id, :string
      add :transaction_type_enum, :string
      add :transaction_date, :date
      add :amount, :float
      add :principal_portion_derived, :float
      add :interest_portion_derived, :float
      add :fee_charges_portion_derived, :float
      add :penalty_charges_portion_derived, :float
      add :overpayment_portion_derived, :float
      add :unrecognized_income_portion, :float
      add :outstanding_loan_balance_derived, :float
      add :submitted_on_date, :date
      add :manually_adjusted_or_reversed, :boolean, default: false, null: false
      add :manually_created_by_userid, :integer

      timestamps()
    end

  end
end
