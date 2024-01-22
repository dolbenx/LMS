defmodule Savings.Repo.Migrations.CreateTblFixedDepositTransactions do
  use Ecto.Migration

  def change do
    create table(:tbl_fixed_deposit_transactions) do
      add :fixedDepositId, :integer
      add :transactionId, :integer
      add :clientId, :integer
      add :amountDeposited, :float
      add :userId, :integer
      add :userRoleId, :integer
      add :status, :string
      # add :productId, :integer

      timestamps()
    end

  end
end
