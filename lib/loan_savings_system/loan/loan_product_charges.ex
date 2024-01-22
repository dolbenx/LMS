defmodule LoanSavingsSystem.Loan.LoanProductCharges do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_product_charges" do
    field :charge_id, :integer
    field :loan_product_id, :integer

    timestamps()
  end

  @doc false
  def changeset(loan_product_charges, attrs) do
    loan_product_charges
    |> cast(attrs, [:loan_product_id, :charge_id])
    |> validate_required([:loan_product_id, :charge_id])
  end
end
