defmodule Loanmanagementsystem.Repo.Migrations.AlterLoansTableAddAccruedInterest do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :daily_accrued_interest, :float, default: 0.0
    end
  end
end
