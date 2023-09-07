defmodule Loanmanagementsystem.Repo.Migrations.AlterTblLoanRepayment do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_repayment) do
      add :loan_product, :string
      add :repayment_type, :string
      add :repayment_method, :string
      add :bank_name, :string
      add :branch_name, :string
      add :swift_code, :string
      add :expiry_date, :string
      add :cvc, :string
      add :bank_account_no, :string
      add :account_name, :string
      add :bevura_wallet_no, :string
      add :receipient_number, :string
      add :reference_no, :string
      add :status, :string
    end
  end
end
