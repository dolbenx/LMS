defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanRepayment do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_repayment) do
      add :loan_id, :bigint
    end
  end
end
