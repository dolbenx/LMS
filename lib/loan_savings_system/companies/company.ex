defmodule LoanSavingsSystem.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_company" do
    field :companyName, :string
    field :contactPhone, :string
    field :registrationNumber, :string
    field :taxNo, :string
    field :contactEmail, :string
    field :isEmployer, :boolean
    field :isSme, :boolean
    field :isOffTaker, :boolean
    field :createdByUserId, :integer
    field :createdByUserRoleId, :integer
    field :status, :string
    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:companyName, :contactPhone, :registrationNumber, :taxNo, :contactEmail, :isEmployer, :isSme, :isOffTaker, :createdByUserId, :createdByUserRoleId, :companyName])
    # |> validate_required([:companyName, :contactPhone, :registrationNumber, :taxNo, :contactEmail, :createdByUserId, :createdByUserRoleId])

  end
end
