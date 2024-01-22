defmodule Loanmanagementsystem.Repo.Migrations.AlterLoansDayAddAccruedNumberOfDays do
  use Ecto.Migration

  def up do
    alter table(:tbl_loans) do
      add :accrued_no_days, :integer, default: 0

    end
  end

  def down do
    alter table(:tbl_loans) do
      remove_if_exists(:accrued_no_days, :integer)
    end
  end
end
