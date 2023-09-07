defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanTblRepaymentType do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :repayment_type, :string
    end
  end
end
