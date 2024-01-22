defmodule Loanmanagementsystem.Repo.Migrations.AlterLoansTable280923 do
  use Ecto.Migration

  def up do
    alter table(:tbl_loans) do
      add :init_interest_per, :float, default: 0.0
      add :init_arrangement_fee_per, :float, default: 0.0
      add :init_finance_cost_per, :float, default: 0.0

    end
  end

  def down do
    alter table(:tbl_loans) do
      remove_if_exists(:init_interest_per, :float)
      remove_if_exists(:init_arrangement_fee_per, :float)
      remove_if_exists(:init_finance_cost_per, :float)

    end
  end
end
