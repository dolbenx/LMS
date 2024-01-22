defmodule Loanmanagementsystem.Repo.Migrations.CreateTblTransactions do
  use Ecto.Migration

  def change do
    create table(:tbl_transactions) do
      add :loan_id, :integer
      add :txn_amount, :float, default: 0.0
      add :total_interest_accrued, :float, default: 0.0
      add :total_finance_cost_accrued, :float, default: 0.0
      add :principal_amount, :float, default: 0.0
      add :repaid_amount, :float, default: 0.0
      add :status, :string
      add :repayment_type, :string
      add :product_type, :string
      add :accrued_no_days, :string, default: "0"
      add :transaction_date, :date
      add :customer_id, :integer
      add :txn_ref_no, :string
      add :settlement_status, :string
      add :bank_name, :string
      add :bank_branch, :string
      add :bank_account, :string
      add :bank_swift_code, :string
      add :momo_type, :string
      add :momo_provider, :string
      add :momo_mobile_no, :string
      add :narration, :string
      add :automated, :string
      add :created_by_id, :integer
      add :txn_status, :string
      add :is_repayment, :boolean, default: false, null: false
      add :is_disbursement, :boolean, default: false, null: false

      timestamps()
    end

  end
end
