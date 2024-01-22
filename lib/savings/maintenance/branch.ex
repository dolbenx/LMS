defmodule Savings.Maintenance.Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_branch" do
    field :branchCode, :string
    field :branchName, :string
    field :isDefaultUSSDBranch, :boolean, default: false
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(branch, attrs) do
    branch
    |> cast(attrs, [:branchName, :branchCode, :isDefaultUSSDBranch, :status])
    |> validate_required([:branchName, :branchCode, :isDefaultUSSDBranch, :status])
  end
end
