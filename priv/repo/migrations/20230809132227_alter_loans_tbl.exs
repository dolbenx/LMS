defmodule Loanmanagementsystem.Repo.Migrations.AlterLoansTbl do
  use Ecto.Migration

  def up do
    alter table(:tbl_loans) do
      add :daily_accrued_finance_cost, :float, default: 0.0
    end
  end

  def down do
    alter table(:tbl_loans) do
      remove_if_exists(:daily_accrued_finance_cost, :float)
    end
  end
end
