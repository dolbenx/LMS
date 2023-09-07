defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanTransaction do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_transaction) do
      add :bank_name, :string
      add :bank_branch, :string
      add :bank_account_no, :string
      add :bank_account_name, :string
      add :bank_swift_code, :string
      add :mno_type, :string
      add :mno_mobile_no, :string
      add :customer_id, :integer
      add :narration, :string
    end
  end
end
