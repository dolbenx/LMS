defmodule Loanmanagementsystem.Loan.LoanTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_transaction" do
    field :amount, :float
    field :branch_id, :integer
    field :external_id, :string
    field :fee_charges_portion_derived, :float
    field :interest_portion_derived, :float
    field :is_reversed, :boolean, default: false
    field :loan_id, :integer
    field :manually_adjusted_or_reversed, :boolean, default: false
    field :manually_created_by_userid, :integer
    field :outstanding_loan_balance_derived, :float
    field :overpayment_portion_derived, :float
    field :payment_detail_id, :integer
    field :penalty_charges_portion_derived, :float
    field :principal_portion_derived, :float
    field :submitted_on_date, :date
    field :transaction_date, :date
    field :transaction_type_enum, :string
    field :unrecognized_income_portion, :float
    field :transaction_ref, :string
    field :settlementStatus, :string
    field :momoProvider, :string
    field :debit_account_number, :string
    field :debit_amount, :float
    field :credit_account_number, :string
    field :credit_amount, :float
    field :bank_name, :string
    field :bank_branch, :string
    field :bank_account_no, :string
    field :bank_account_name, :string
    field :bank_swift_code, :string
    field :mno_type, :string
    field :mno_mobile_no, :string
    field :customer_id, :integer
    field :narration, :string
    field :drcr_ind, :string

    timestamps()
  end

  @doc false
  def changeset(loan_transaction, attrs) do
    loan_transaction
    |> cast(attrs, [
      :debit_account_number,
      :drcr_ind,
      :mno_type,
      :mno_mobile_no,
      :bank_name,
      :bank_branch,
      :bank_account_no,
      :bank_account_name,
      :bank_swift_code,
      :customer_id,
      :narration,
      :debit_amount,
      :credit_account_number,
      :credit_amount,
      :loan_id,
      :branch_id,
      :settlementStatus,
      :momoProvider,
      :payment_detail_id,
      :is_reversed,
      :external_id,
      :transaction_type_enum,
      :transaction_date,
      :amount,
      :transaction_ref,
      :principal_portion_derived,
      :interest_portion_derived,
      :fee_charges_portion_derived,
      :penalty_charges_portion_derived,
      :overpayment_portion_derived,
      :unrecognized_income_portion,
      :outstanding_loan_balance_derived,
      :submitted_on_date,
      :manually_adjusted_or_reversed,
      :manually_created_by_userid
    ])

    # |> validate_required([:debit_account_number, :debit_amount, :credit_account_number, :credit_amount,:loan_id, :branch_id, :payment_detail_id, :is_reversed, :external_id, :transaction_type_enum, :transaction_date, :amount, :principal_portion_derived, :interest_portion_derived, :fee_charges_portion_derived, :penalty_charges_portion_derived, :overpayment_portion_derived, :unrecognized_income_portion, :outstanding_loan_balance_derived, :submitted_on_date, :manually_adjusted_or_reversed, :manually_created_by_userid])
  end

  def changesetforupdate(loan_transaction, attrs) do
    loan_transaction
    |> cast(attrs, [
      :loan_id,
      :branch_id,
      :mno_type,
      :drcr_ind,
      :mno_mobile_no,
      :bank_name,
      :bank_branch,
      :bank_account_no,
      :bank_account_name,
      :bank_swift_code,
      :customer_id,
      :narration,
      :settlementStatus,
      :momoProvider,
      :payment_detail_id,
      :is_reversed,
      :external_id,
      :transaction_type_enum,
      :transaction_date,
      :amount,
      :transaction_ref,
      :principal_portion_derived,
      :interest_portion_derived,
      :fee_charges_portion_derived,
      :penalty_charges_portion_derived,
      :overpayment_portion_derived,
      :unrecognized_income_portion,
      :outstanding_loan_balance_derived,
      :submitted_on_date,
      :manually_adjusted_or_reversed,
      :manually_created_by_userid
    ])
  end
end
