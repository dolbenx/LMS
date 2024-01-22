defmodule Loanmanagementsystem.Payment.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_collection_type" do
    field :collection_type_description, :string
    field :system_id, :string

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:collection_type_description, :system_id])
    |> validate_required([:collection_type_description, :system_id])
  end
end
