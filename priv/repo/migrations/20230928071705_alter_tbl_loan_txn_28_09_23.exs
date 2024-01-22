defmodule Loanmanagementsystem.Repo.Migrations.AlterTblLoanTxn280923 do
  use Ecto.Migration

  def up do
    alter table(:tbl_transactions) do
      add :days_accrued, :integer
    end
  end

  def down do
    alter table(:tbl_transactions) do
      remove_if_exists(:days_accrued, :integer)
    end
  end
end
