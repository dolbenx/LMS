defmodule Loanmanagementsystem.Companies.Paths do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

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
