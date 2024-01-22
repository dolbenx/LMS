defmodule LoanSavingsSystem.Loan.LoanTransaction do
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

    timestamps()
  end

  @doc false
  def changeset(loan_transaction, attrs) do
    loan_transaction
    |> cast(attrs, [:loan_id, :branch_id, :payment_detail_id, :is_reversed, :external_id, :transaction_type_enum, :transaction_date, :amount, :principal_portion_derived, :interest_portion_derived, :fee_charges_portion_derived, :penalty_charges_portion_derived, :overpayment_portion_derived, :unrecognized_income_portion, :outstanding_loan_balance_derived, :submitted_on_date, :manually_adjusted_or_reversed, :manually_created_by_userid])
    |> validate_required([:loan_id, :branch_id, :payment_detail_id, :is_reversed, :external_id, :transaction_type_enum, :transaction_date, :amount, :principal_portion_derived, :interest_portion_derived, :fee_charges_portion_derived, :penalty_charges_portion_derived, :overpayment_portion_derived, :unrecognized_income_portion, :outstanding_loan_balance_derived, :submitted_on_date, :manually_adjusted_or_reversed, :manually_created_by_userid])
  end
end
