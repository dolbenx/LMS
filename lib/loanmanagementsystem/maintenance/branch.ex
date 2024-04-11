defmodule Loanmanagementsystem.Maintenance.Branch do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

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
