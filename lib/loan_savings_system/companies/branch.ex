defmodule LoanSavingsSystem.Companies.Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_branch" do
    field :branchCode, :string
    field :branchName, :string
    field :clientId, :integer
    field :isDefaultUSSDBranch, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(branch, attrs) do
    branch
    |> cast(attrs, [:branchName, :branchCode, :isDefaultUSSDBranch, :clientId])
    |> validate_required([:branchName, :branchCode, :isDefaultUSSDBranch, :clientId])
  end
end
