defmodule LoanSavingsSystem.SystemDirectories.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_system_directories" do
    field :bulk_trns, :string
    field :esb_complete, :string
    field :esb_downloa, :string
    field :failed, :string
    field :processed, :string

    timestamps()
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:bulk_trns, :esb_complete, :esb_downloa, :failed, :processed])
    |> validate_required([:bulk_trns, :esb_complete, :esb_downloa, :failed, :processed])
  end
end
