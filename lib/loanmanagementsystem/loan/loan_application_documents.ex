defmodule Loanmanagementsystem.Loan.Loan_application_documents do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_application_documents" do
    field :customer_id, :integer
    field :doc_name, :string
    field :doc_type, :string
    field :path, :string
    field :status, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(loan_application_documents, attrs) do
    loan_application_documents
    |> cast(attrs, [:doc_name, :doc_type, :status, :path, :customer_id, :user_id])
    |> validate_required([:doc_name, :doc_type, :status, :path, :customer_id, :user_id])
  end
end
