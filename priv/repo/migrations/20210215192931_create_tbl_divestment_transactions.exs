defmodule LoanSavingsSystem.Repo.Migrations.CreateTblDivestmentTransactions do
  use Ecto.Migration

  def change do
    create table(:tbl_divestment_transactions) do
      add :divestmentId, :integer
      add :transactionId, :integer
      add :amountDivested, :float
      add :interestAccrued, :float
      add :userId, :integer
      add :userRoleId, :integer
      add :clientId, :integer

      timestamps()
    end

  end
end
