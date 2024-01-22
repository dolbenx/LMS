defmodule Loanmanagementsystem.Transactions.Loan_transactions do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tbl_transactions" do
    field :accrued_no_days, :string, default: "0"
    field :automated, :string
    field :bank_account, :string
    field :bank_branch, :string
    field :bank_name, :string
    field :bank_swift_code, :string
    field :created_by_id, :integer
    field :customer_id, :integer
    field :is_disbursement, :boolean, default: false
    field :is_repayment, :boolean, default: false
    field :loan_id, :integer
    field :momo_mobile_no, :string
    field :momo_provider, :string
    field :momo_type, :string
    field :narration, :string
    field :principal_amount, :float, default: 0.0
    field :product_type, :string
    field :repaid_amount, :float, default: 0.0
    field :repayment_type, :string
    field :settlement_status, :string
    field :status, :string
    field :total_finance_cost_accrued, :float, default: 0.0
    field :total_interest_accrued, :float, default: 0.0
    field :transaction_date, :date
    field :txn_amount, :float, default: 0.0
    field :txn_ref_no, :string
    field :txn_status, :string
    field :product_id, :integer
    field :outstanding_balance, :float, default: 0.0
    field :days_accrued, :integer
    field :is_bulk_upload, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(loan_transactions, attrs) do
    loan_transactions
    |> cast(attrs, [:is_bulk_upload, :days_accrued, :outstanding_balance, :product_id, :loan_id, :txn_amount, :total_interest_accrued, :total_finance_cost_accrued, :principal_amount, :repaid_amount, :status, :repayment_type, :product_type, :accrued_no_days, :transaction_date, :customer_id, :txn_ref_no, :settlement_status, :bank_name, :bank_branch, :bank_account, :bank_swift_code, :momo_type, :momo_provider, :momo_mobile_no, :narration, :automated, :created_by_id, :txn_status, :is_repayment, :is_disbursement])
    # |> validate_required([:loan_id, :txn_amount, :total_interest_accrued, :total_finance_cost_accrued, :principal_amount, :repaid_amount, :status, :repayment_type, :product_type, :accrued_no_days, :transaction_date, :customer_id, :txn_ref_no, :settlement_status, :bank_name, :bank_branch, :bank_account, :bank_swift_code, :momo_type, :momo_provider, :momo_mobile_no, :narration, :automated, :created_by_id, :txn_status, :is_repayment, :is_disbursement])
    |> validate_required([:loan_id, :customer_id])
  end
end
