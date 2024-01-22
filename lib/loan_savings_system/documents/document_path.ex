defmodule LoanSavingsSystem.Documents.DocumentPath do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_document_path" do
    field :path, :string
    field :belongs_to, :string
    field :applicable_on, :string
    field :created_by, :integer
    field :approved_by, :integer
    field :status, :string
    field :path_name, :string

    timestamps()
  end

  @doc false
  def changeset(document_path, attrs) do
    document_path
    |> cast(attrs, [:path_name, :path, :belongs_to, :applicable_on, :created_by, :approved_by, :status])
    |> validate_required([:path_name, :path, :belongs_to, :applicable_on, :created_by, :status])
  end
end
