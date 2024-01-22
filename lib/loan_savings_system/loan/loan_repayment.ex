defmodule LoanSavingsSystem.Loan.LoanRepayment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_repayment" do
    field :amountRepaid, :float
    field :chequeNo, :string
    field :dateOfRepayment, :string
    field :modeOfRepayment, :string
    field :receiptNo, :string
    field :recipientUserRoleId, :integer
    field :registeredByUserId, :integer
    field :repaymentNo, :string

    timestamps()
  end

  @doc false
  def changeset(loan_repayment, attrs) do
    loan_repayment
    |> cast(attrs, [:repaymentNo, :dateOfRepayment, :modeOfRepayment, :amountRepaid, :chequeNo, :receiptNo, :registeredByUserId, :recipientUserRoleId])
    |> validate_required([:repaymentNo, :dateOfRepayment, :modeOfRepayment, :amountRepaid, :chequeNo, :receiptNo, :registeredByUserId, :recipientUserRoleId])
  end
end
