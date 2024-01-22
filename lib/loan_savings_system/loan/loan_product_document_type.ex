defmodule LoanSavingsSystem.Loan.LoanProductDocumentType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_product_document_type" do
    field :documentTypeId, :integer
    field :isRequired, :boolean, default: false
    field :productId, :integer

    timestamps()
  end

  @doc false
  def changeset(loan_product_document_type, attrs) do
    loan_product_document_type
    |> cast(attrs, [:productId, :documentTypeId, :isRequired])
    |> validate_required([:productId, :documentTypeId, :isRequired])
  end
end
