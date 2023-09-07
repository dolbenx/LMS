defmodule Loanmanagementsystem.Companies.Company_Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_company_branches" do
    field :branchCode, :string
    field :companyId, :string
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(company__branch, attrs) do
    company__branch
    |> cast(attrs, [:name, :branchCode, :companyId, :status])
    |> validate_required([:name, :branchCode, :companyId, :status])
  end
end
