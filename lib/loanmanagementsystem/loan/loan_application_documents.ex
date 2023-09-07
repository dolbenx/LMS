defmodule Loanmanagementsystem.Loan.Loan_application_documents do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_application_documents" do
    field :customer_id, :integer
    field :doc_name, :string
    field :doc_type, :string
    field :path, :string
    field :status, :string
    field :loan_id, :integer
    field :fileName, :string
    field :for_repayment, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(loan_application_documents, attrs) do
    loan_application_documents
    |> cast(attrs, [:fileName, :doc_name, :doc_type, :status, :path, :customer_id, :loan_id, :for_repayment])
    |> validate_required([:fileName, :doc_name, :doc_type, :status, :path, :customer_id, :loan_id])
  end
end
