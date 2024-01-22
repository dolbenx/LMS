defmodule LoanSavingsSystem.Repo.Migrations.CreateTblAccountCharge do
  use Ecto.Migration

  def change do
    create table(:tbl_account_charge) do
      add :accountId, :integer
      add :chargeId, :integer
      add :amountCharged, :float
      add :isPaid, :boolean, default: false, null: false
      add :dateCharged, :date
      add :datePaid, :date
      add :balance, :float
      add :userId, :integer
      add :fixedDepositId, :integer

      timestamps()
    end

  end
end
