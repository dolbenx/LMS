defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanFunderId do
  use Ecto.Migration

  def up do
    alter table(:tbl_loan_funder) do
      add :is_company, :boolean, default: false, null: false
    end
  end

  def down do
    alter table(:tbl_loan_funder) do
      remove :is_company
    end
  end
end
