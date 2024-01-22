defmodule Loanmanagementsystem.Payment.Collection do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

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
