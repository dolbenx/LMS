defmodule Loanmanagementsystem.Loan.Loan_applicant_reference do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_loan_reference" do
    field :contact_no, :string
    field :customer_id, :integer
    field :name, :string
    field :reference_no, :string


    timestamps()
  end

  @doc false
  def changeset(loan_applicant_reference, attrs) do
    loan_applicant_reference
    |> cast(attrs, [:customer_id, :name, :contact_no, :reference_no])
    # |> validate_required([:customer_id, :name, :contact_no])
  end
end
