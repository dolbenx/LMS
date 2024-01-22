defmodule Loanmanagementsystem.Loan.Payments_transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_payments_transaction" do
    field :employee_id, :integer
    field :employee_number, :string
    field :loan_id, :integer
    field :merchant_id, :integer
    field :payment_amount, :float
    field :reference_no, :string

    timestamps()
  end

  @doc false
  def changeset(payments_transaction, attrs) do
    payments_transaction
    |> cast(attrs, [:employee_id, :merchant_id, :loan_id, :employee_number, :payment_amount, :reference_no])
    |> validate_required([:employee_id, :merchant_id, :loan_id, :employee_number, :payment_amount, :reference_no])
  end
end
