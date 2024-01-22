defmodule LoanSavingsSystem.Repo.Migrations.CreateTblTransactions do
  use Ecto.Migration

  def change do
    create table(:tbl_transactions) do
      add :accountId, :integer
      add :totalAmount, :float
      add :productId, :integer
      add :productType, :string
      add :userId, :integer
      add :userRoleId, :integer
      add :referenceNo, :string
      add :orderRef, :string
      add :transactionType, :string
      add :status, :string
      add :isReversed, :boolean, default: false, null: false
      add :requestData, :string
      add :responseData, :string
      add :carriedOutByUserId, :integer
      add :carriedOutByUserRoleId, :integer
      add :transactionTypeEnum, :string
      add :transactionDetail, :string
      add :newTotalBalance, :float
      add :currencyDecimals, :integer
      add :currency, :string
      add :customerName, :string


      timestamps()
    end

  end
end
