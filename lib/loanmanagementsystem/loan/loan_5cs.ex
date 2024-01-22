defmodule Loanmanagementsystem.Loan.Loan_5cs do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_loan_5cs_analysis" do
    field :capacity, :string
    field :capital, :string
    field :character, :string
    field :collateral, :string
    field :condition, :string
    field :customer_id, :integer
    field :loan_id, :integer
    field :reference_no, :string

    timestamps()
  end

  @doc false
  def changeset(loan_5cs, attrs) do
    loan_5cs
    |> cast(attrs, [:customer_id, :loan_id, :reference_no, :character, :capacity, :capital, :condition, :collateral])
    # |> validate_required([:customer_id, :loan_id, :reference_no, :character, :capacity, :capital, :condition, :collateral])
  end
end
