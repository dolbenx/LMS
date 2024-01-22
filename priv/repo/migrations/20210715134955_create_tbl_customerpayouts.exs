defmodule LoanSavingsSystem.Repo.Migrations.CreateTblCustomerpayouts do
  use Ecto.Migration

  def change do
    create table(:tbl_customerpayouts) do
      add :fixedDepositId, :integer
      add :orderRef, :string
      add :status, :string
      add :amount, :float
      add :transactionId, :integer
      add :userId, :integer
      add :payoutType, :string
      add :transactionDate, :date
      add :payoutRequest, :string
      add :payoutResponse, :string

      timestamps()
    end

  end
end
