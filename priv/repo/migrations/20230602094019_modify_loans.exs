defmodule Loanmanagementsystem.Repo.Migrations.ModifyLoans do
  use Ecto.Migration

  def up do
    alter table(:tbl_loans) do
      add :loan_officer_id, :integer
    end
  end

  def down do
    alter table(:tbl_loans) do
      remove :loan_officer_id
    end
  end
end
