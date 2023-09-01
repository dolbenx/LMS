defmodule Loanmanagementsystem.Maintenance.Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_branch" do
    field :approved_by, :integer
    field :branchCode, :string
    field :branchName, :string
    field :clientId, :integer
    field :created_by, :integer
    field :isDefaultUSSDBranch, :boolean, default: false
    field :status, :string
    field :province, :string
    field :city, :string
    field :branchAddress, :string

    timestamps()
  end

  @doc false
  def changeset(branch, attrs) do
    branch
    |> cast(attrs, [
      :branchAddress,
      :province,
      :city,
      :branchName,
      :branchCode,
      :isDefaultUSSDBranch,
      :clientId,
      :status,
      :created_by,
      :approved_by
    ])
    |> validate_required([
      :branchAddress,
      :province,
      :city,
      :branchName,
      :branchCode,
      :isDefaultUSSDBranch,
      :clientId,
      :status,
      :created_by
    ])
  end
end
