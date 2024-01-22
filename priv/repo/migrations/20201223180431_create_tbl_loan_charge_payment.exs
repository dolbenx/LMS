defmodule LoanSystem.Repo.Migrations.CreateTblLoanChargePayment do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_charge_payment) do
      add :loan_transaction_id, :integer
      add :loan_id, :integer
      add :loan_charge_id, :integer
      add :amount, :float
      add :installment_number, :integer

      timestamps()
    end

  end
end
