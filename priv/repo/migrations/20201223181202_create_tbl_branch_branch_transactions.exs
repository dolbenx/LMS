defmodule LoanSystem.Repo.Migrations.CreateTblBranchBranchTransactions do
  use Ecto.Migration

  def change do
    create table(:tbl_branch_branch_transactions) do
      add :source_branch_id, :string
      add :receipient_branch_id, :string
      add :currency_code, :string
      add :transaction_amount, :string
      add :transaction_date, :string
      add :details, :string

      timestamps()
    end

  end
end
