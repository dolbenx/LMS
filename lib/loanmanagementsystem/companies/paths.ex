defmodule Loanmanagementsystem.Companies.Paths do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_paths" do
    field :name, :string
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(paths, attrs) do
    paths
    |> cast(attrs, [:path, :name])
    |> validate_required([:path, :name])
  end
end
