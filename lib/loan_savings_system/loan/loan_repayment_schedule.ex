defmodule LoanSavingsSystem.Loan.LoanRepaymentSchedule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_repayment_schedule" do
    field :accrual_fee_charges_derived, :float
    field :accrual_interest_derived, :float
    field :accrual_penalty_charges_derived, :float
    field :completed_derived, :float
    field :createdby_id, :integer
    field :duedate, :date
    field :fee_charges_amount, :float
    field :fee_charges_completed_derived, :float
    field :fee_charges_waived_derived, :float
    field :fee_charges_writtenoff_derived, :float
    field :fromdate, :date
    field :installment, :float
    field :interest_amount, :float
    field :interest_completed_derived, :float
    field :interest_waived_derived, :float
    field :interest_writtenoff_derived, :float
    field :lastmodifiedby_id, :integer
    field :loan_id, :integer
    field :obligations_met_on_date, :date
    field :penalty_charges_amount, :float
    field :penalty_charges_completed_derived, :float
    field :penalty_charges_waived_derived, :float
    field :penalty_charges_writtenoff_derived, :float
    field :principal_amount, :float
    field :principal_completed_derived, :float
    field :principal_writtenoff_derived, :float
    field :total_paid_in_advance_derived, :float
    field :total_paid_late_derived, :float
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(loan_repayment_schedule, attrs) do
    loan_repayment_schedule
    |> cast(attrs, [:loan_id, :fromdate, :duedate, :installment, :principal_amount, :principal_completed_derived, :principal_writtenoff_derived, :interest_amount, :interest_completed_derived, :interest_writtenoff_derived, :interest_waived_derived, :accrual_interest_derived, :fee_charges_amount, :fee_charges_completed_derived, :fee_charges_writtenoff_derived, :fee_charges_waived_derived, :accrual_fee_charges_derived, :penalty_charges_amount, :penalty_charges_completed_derived, :penalty_charges_writtenoff_derived, :penalty_charges_waived_derived, :accrual_penalty_charges_derived, :total_paid_in_advance_derived, :total_paid_late_derived, :completed_derived, :createdby_id, :lastmodifiedby_id, :obligations_met_on_date, :status])
    |> validate_required([:loan_id, :fromdate, :duedate, :installment, :principal_amount, :principal_completed_derived, :principal_writtenoff_derived, :interest_amount, :interest_completed_derived, :interest_writtenoff_derived, :interest_waived_derived, :accrual_interest_derived, :fee_charges_amount, :fee_charges_completed_derived, :fee_charges_writtenoff_derived, :fee_charges_waived_derived, :accrual_fee_charges_derived, :penalty_charges_amount, :penalty_charges_completed_derived, :penalty_charges_writtenoff_derived, :penalty_charges_waived_derived, :accrual_penalty_charges_derived, :total_paid_in_advance_derived, :total_paid_late_derived, :completed_derived, :createdby_id, :lastmodifiedby_id, :obligations_met_on_date, :status])
  end
end
