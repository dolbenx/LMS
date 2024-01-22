defmodule LoanSavingsSystem.Documents.LoanDocumentConfirmationRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_confirmation" do
    field :companyId, :integer
    field :details, :string
    field :documentTypeId, :string
    field :loan_documentId, :integer
    field :sentByUserId, :integer
    field :sentByUserRoleId, :integer
    field :status, :string
    field :submitedBy, :string

    timestamps()
  end

  @doc false
  def changeset(loan_document_confirmation_request, attrs) do
    loan_document_confirmation_request
    |> cast(attrs, [:loan_documentId, :documentTypeId, :companyId, :status, :sentByUserRoleId, :sentByUserId, :details, :submitedBy])
    |> validate_required([:loan_documentId, :documentTypeId, :companyId, :status, :sentByUserRoleId, :sentByUserId, :details, :submitedBy])
  end
end
