defmodule LoanSavingsSystem.Loan.LoanInstallmentCharge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_installment_charge" do
    field :amount, :float
    field :amount_outstanding_derived, :float
    field :amount_paid_derived, :float
    field :amount_waived_derived, :float
    field :amount_writtenoff_derived, :float
    field :due_date, :date
    field :is_paid_derived, :boolean, default: false
    field :is_waived, :boolean, default: false
    field :loan_charge_id, :integer
    field :loan_schedule_id, :integer

    timestamps()
  end

  @doc false
  def changeset(loan_installment_charge, attrs) do
    loan_installment_charge
    |> cast(attrs, [:loan_charge_id, :loan_schedule_id, :due_date, :amount, :amount_paid_derived, :amount_waived_derived, :amount_writtenoff_derived, :amount_outstanding_derived, :is_paid_derived, :is_waived])
    |> validate_required([:loan_charge_id, :loan_schedule_id, :due_date, :amount, :amount_paid_derived, :amount_waived_derived, :amount_writtenoff_derived, :amount_outstanding_derived, :is_paid_derived, :is_waived])
  end
end
