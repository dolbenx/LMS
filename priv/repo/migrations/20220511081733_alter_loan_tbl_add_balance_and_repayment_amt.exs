defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanTblAddBalanceAndRepaymentAmt do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :interest_amount, :float
      add :repayment_amount, :float
      add :balance, :float
      add :tenor, :integer
    end
  end
end
