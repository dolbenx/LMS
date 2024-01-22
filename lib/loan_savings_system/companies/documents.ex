defmodule LoanSavingsSystem.Companies.Documents do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_comapny_documents" do
    field :docName, :string
    field :userID, :integer
    field :companyID, :integer
    field :taxNo, :string
    field :docType, :string
    field :status, :string
    field :path, :string
    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:path, :status, :docName, :userID, :companyID, :taxNo, :docType])
    |> validate_required([:docName, :userID, :companyID, :taxNo, :docType])
  end
end
