defmodule LoanSavingsSystem.Loan.LoanPaidInAdvance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_paid_in_advance" do
    field :fee_charges_in_advance_derived, :float
    field :interest_in_advance_derived, :float
    field :loan_id, :integer
    field :penalty_charges_in_advance_derived, :float
    field :principal_in_advance_derived, :float
    field :total_in_advance_derived, :float

    timestamps()
  end

  @doc false
  def changeset(loan_paid_in_advance, attrs) do
    loan_paid_in_advance
    |> cast(attrs, [:loan_id, :principal_in_advance_derived, :interest_in_advance_derived, :fee_charges_in_advance_derived, :penalty_charges_in_advance_derived, :total_in_advance_derived])
    |> validate_required([:loan_id, :principal_in_advance_derived, :interest_in_advance_derived, :fee_charges_in_advance_derived, :penalty_charges_in_advance_derived, :total_in_advance_derived])
  end
end
