defmodule LoanSavingsSystem.Documents.OffTakerDocument do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_off_taker_DocumentTypes" do
    field :companyId, :integer
    field :documentTypeId, :integer

    timestamps()
  end

  @doc false
  def changeset(off_taker_document, attrs) do
    off_taker_document
    |> cast(attrs, [:companyId, :documentTypeId])
    |> validate_required([:companyId, :documentTypeId])
  end
end
