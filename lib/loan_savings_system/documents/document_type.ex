defmodule LoanSavingsSystem.Documents.DocumentType  do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_document_type" do
    field :required, :string, default: "NO"
    field :doc_type, :string
    field :status, :string, default: "PENDING"
    field :belongs_to, :string
    field :created_by, :integer
    field :approved_by, :integer
    field :applicable_to, :string
    field :description, :string
    field :documentFormats, :string
    field :name, :string
    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:applicable_to, :approved_by, :created_by, :belongs_to, :status, :doc_type, :required, :description, :documentFormats, :name])
    # |> validate_required([:created_by, :belongs_to, :status, :document_type, :required])
  end

end
