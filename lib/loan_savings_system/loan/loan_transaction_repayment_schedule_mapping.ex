defmodule LoanSavingsSystem.Loan.LoanTransactionRepaymentScheduleMapping do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_transaction_repayment_schedule_mapping" do
    field :amount, :float
    field :fee_charges_portion_derived, :float
    field :interest_portion_derived, :float
    field :loan_repayment_schedule_id, :integer
    field :loan_transaction_id, :integer
    field :penalty_charges_portion_derived, :float
    field :principal_portion_derived, :float

    timestamps()
  end

  @doc false
  def changeset(loan_transaction_repayment_schedule_mapping, attrs) do
    loan_transaction_repayment_schedule_mapping
    |> cast(attrs, [:loan_transaction_id, :loan_repayment_schedule_id, :amount, :principal_portion_derived, :interest_portion_derived, :fee_charges_portion_derived, :penalty_charges_portion_derived])
    |> validate_required([:loan_transaction_id, :loan_repayment_schedule_id, :amount, :principal_portion_derived, :interest_portion_derived, :fee_charges_portion_derived, :penalty_charges_portion_derived])
  end
end
