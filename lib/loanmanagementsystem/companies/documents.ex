defmodule Loanmanagementsystem.Companies.Documents do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_company_documents" do
    field :companyID, :integer
    field :docName, :string
    field :docType, :string
    field :path, :string
    field :status, :string
    field :taxNo, :string
    field :userID, :integer

    timestamps()
  end

  @doc false
  def changeset(documents, attrs) do
    documents
    |> cast(attrs, [:docName, :userID, :companyID, :taxNo, :docType, :status, :path])

    # |> validate_required([:docName, :userID, :companyID, :taxNo, :docType, :status, :path])
  end
end
