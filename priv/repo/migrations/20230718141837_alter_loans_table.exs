defmodule Loanmanagementsystem.Repo.Migrations.AlterLoansTable do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :days_under_due, :integer, default: 0
      add :days_over_due, :integer, default: 0
    end
  end
end
