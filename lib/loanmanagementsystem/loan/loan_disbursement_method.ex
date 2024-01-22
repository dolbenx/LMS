defmodule Loanmanagementsystem.Loan.Loan_disbursement_method do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_disbursement_method" do
    field :amount, :float
    field :currency, :string
    field :disbursement_method, :string
    field :loan_id, :integer
    field :product_id, :integer
    field :userId, :integer
    field :accountNumber, :string

    timestamps()
  end

  @doc false
  def changeset(loan_disbursement_method, attrs) do
    loan_disbursement_method
    |> cast(attrs, [:product_id, :currency, :amount, :disbursement_method, :loan_id, :userId, :accountNumber])
    |> validate_required([:product_id, :currency, :amount, :disbursement_method, :loan_id, :userId, :accountNumber])
  end
end
