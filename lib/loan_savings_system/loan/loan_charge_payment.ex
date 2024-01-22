defmodule LoanSavingsSystem.Loan.LoanChargePayment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_charge_payment" do
    field :amount, :float
    field :installment_number, :integer
    field :loan_charge_id, :integer
    field :loan_id, :integer
    field :loan_transaction_id, :integer

    timestamps()
  end

  @doc false
  def changeset(loan_charge_payment, attrs) do
    loan_charge_payment
    |> cast(attrs, [:loan_transaction_id, :loan_id, :loan_charge_id, :amount, :installment_number])
    |> validate_required([:loan_transaction_id, :loan_id, :loan_charge_id, :amount, :installment_number])
  end
end
