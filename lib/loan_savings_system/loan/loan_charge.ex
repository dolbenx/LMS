defmodule LoanSavingsSystem.Loan.LoanCharge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_charge" do
    field :amount, :float
    field :amount_outstanding_derived, :float
    field :amount_paid_derived, :float
    field :amount_waived_derived, :float
    field :amount_writtenoff_derived, :float
    field :calculation_on_amount, :float
    field :calculation_percentage, :float
    field :charge_amount_or_percentage, :float
    field :charge_calculation_enum, :string
    field :charge_id, :integer
    field :charge_payment_mode_enum, :string
    field :charge_time_enum, :string
    field :due_for_collection_as_of_date, :string
    field :is_active, :boolean, default: false
    field :is_paid_derived, :boolean, default: false
    field :is_penalty, :boolean, default: false
    field :is_waived, :boolean, default: false
    field :loan_id, :integer

    timestamps()
  end

  @doc false
  def changeset(loan_charge, attrs) do
    loan_charge
    |> cast(attrs, [:loan_id, :charge_id, :is_penalty, :charge_time_enum, :due_for_collection_as_of_date, :charge_calculation_enum, :charge_payment_mode_enum, :calculation_percentage, :calculation_on_amount, :charge_amount_or_percentage, :amount, :amount_paid_derived, :amount_waived_derived, :amount_writtenoff_derived, :amount_outstanding_derived, :is_paid_derived, :is_waived, :is_active])
    |> validate_required([:loan_id, :charge_id, :is_penalty, :charge_time_enum, :due_for_collection_as_of_date, :charge_calculation_enum, :charge_payment_mode_enum, :calculation_percentage, :calculation_on_amount, :charge_amount_or_percentage, :amount, :amount_paid_derived, :amount_waived_derived, :amount_writtenoff_derived, :amount_outstanding_derived, :is_paid_derived, :is_waived, :is_active])
  end
end
