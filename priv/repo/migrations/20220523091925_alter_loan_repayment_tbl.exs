defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanRepaymentTbl do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_repayment) do
      add :mno_mobile_no, :string
    end
  end
end
