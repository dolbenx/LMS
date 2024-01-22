defmodule Loanmanagementsystem.Repo.Migrations.ModifyLoansTable140823 do
  use Ecto.Migration

  def up do
    alter table(:tbl_loans) do
      add :calculated_balance, :float, default: 0.0
    end
  end

  def down do
    alter table(:tbl_loans) do
      remove_if_exists(:calculated_balance, :float)
    end
  end
end
