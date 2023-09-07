defmodule Loanmanagementsystem.Repo.Migrations.AlteredTblLoanByAddingLoanLimitField do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :loan_limit, :float

    end
  end
end
