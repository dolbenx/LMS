defmodule Loanmanagementsystem.Repo.Migrations.AlterEodEntriesTbl do
  use Ecto.Migration

   def up do
    alter table(:tbl_end_of_day_entries) do
      add :finance_cost_accrued, :float, default: 0.0
    end
  end

  def down do
    alter table(:tbl_end_of_day_entries) do
      remove_if_exists(:finance_cost_accrued, :float)
    end
  end
end
