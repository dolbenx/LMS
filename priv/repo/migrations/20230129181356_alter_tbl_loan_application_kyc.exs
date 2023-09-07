defmodule Loanmanagementsystem.Repo.Migrations.AlterTblLoanApplicationKyc do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do

      add :requested_amount, :float
      add :loan_duration_month, :string
      add :monthly_installment, :string
      add :proposed_repayment_date, :date
      add :loan_purpose, :string
      add :application_date, :date


    end
  end
end
