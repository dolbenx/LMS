defmodule Loanmanagementsystem.Repo.Migrations.AlterTblLoanTxn do
  use Ecto.Migration

  def up do
    alter table(:tbl_transactions) do
      add :interest_rate, :float, default: 0.0
      add :finance_cost_rate, :float, default: 0.0
      add :transaction_type, :string
      add :outstanding_balance, :float, default: 0.0
    end
  end

  def down do
    alter table(:tbl_transactions) do
      remove_if_exists(:interest_rate, :float)
      remove_if_exists(:finance_cost_rate, :float)
      remove_if_exists(:transaction_type, :string)
      remove_if_exists(:outstanding_balance, :float)
    end
  end
end
