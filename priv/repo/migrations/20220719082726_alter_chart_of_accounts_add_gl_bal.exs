defmodule Loanmanagementsystem.Repo.Migrations.AlterChartOfAccountsAddGlBal do
  use Ecto.Migration

  def change do
    alter table(:tbl_chart_of_accounts) do
      add :fcy_bal, :float
      add :lcy_bal, :float
    end
  end
end
