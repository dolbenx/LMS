defmodule Loanmanagementsystem.Configs.Titles do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_titles" do
    field :description, :string
    field :maker, :integer
    field :status, :string
    field :title, :string
    field :updater, :integer

    timestamps()
  end

  @doc false
  def changeset(titles, attrs) do
    titles
    |> cast(attrs, [:title, :description, :status, :updater, :maker])
    # |> validate_required([:title, :description, :status, :updater, :maker])
  end
end
