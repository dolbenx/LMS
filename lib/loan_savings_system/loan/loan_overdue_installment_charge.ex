defmodule LoanSavingsSystem.Loan.LoanOverdueInstallmentCharge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_overdue_installment_charge" do
    field :loan_charge_id, :integer
    field :loan_schedule_id, :integer
    field :overdue_amount, :float

    timestamps()
  end

  @doc false
  def changeset(loan_overdue_installment_charge, attrs) do
    loan_overdue_installment_charge
    |> cast(attrs, [:loan_charge_id, :loan_schedule_id, :overdue_amount])
    |> validate_required([:loan_charge_id, :loan_schedule_id, :overdue_amount])
  end
end
