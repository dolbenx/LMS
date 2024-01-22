defmodule Loanmanagementsystem.Loan.Loan_disbursement do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tbl_loan_payment_requisition" do
    field :address_or_designation, :string
    field :amount_paid, :float
    field :amount_requested, :float
    field :approved_by, :string
    field :approved_by_position, :string
    field :checked_by, :string
    field :checked_by_position, :string
    field :cheque_no, :string
    field :customer_id, :integer
    field :date_paid, :date
    field :gl_account, :string
    field :loan_id, :integer
    field :loan_purpose, :string
    field :payable_to, :string
    field :reference_no, :string
    field :requested_by, :string
    field :requested_by_position, :string
    field :net_disbursed_amount, :float

    timestamps()
  end

  @doc false
  def changeset(loan_disbursement, attrs) do
    loan_disbursement
    |> cast(attrs, [:customer_id, :loan_id, :net_disbursed_amount, :reference_no, :payable_to, :address_or_designation, :amount_requested, :amount_paid, :loan_purpose, :requested_by, :checked_by, :approved_by, :gl_account, :date_paid, :requested_by_position, :checked_by_position, :approved_by_position, :cheque_no])
    # |> validate_required([:customer_id, :loan_id, :reference_no, :payable_to, :address_or_designation, :amount_requested, :amount_paid, :loan_purpose, :requested_by, :checked_by, :approved_by, :gl_account, :date_paid, :requested_by_position, :checked_by_position, :approved_by_position, :cheque_no])
  end
end
