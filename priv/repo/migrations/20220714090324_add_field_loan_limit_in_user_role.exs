defmodule Loanmanagementsystem.Repo.Migrations.AddFieldLoanLimitInUserRole do
  use Ecto.Migration

  def up do
    alter table(:tbl_user_roles) do
      add :loan_limit, :decimal
    end
  end

  def down do
    alter table(:tbl_user_roles) do
      remove :loan_limit
    end
  end
end
