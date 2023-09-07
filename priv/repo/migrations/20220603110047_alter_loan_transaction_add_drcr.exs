defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanTransactionAddDrcr do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_transaction) do
      add :drcr_ind, :string
    end
  end
end
