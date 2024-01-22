defmodule Loanmanagementsystem.Merchants.Merchants_document do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_merchant_and_agent_doc" do
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
  def changeset(merchants_document, attrs) do
    merchants_document
    |> cast(attrs, [:docName, :userID, :companyID, :taxNo, :docType, :status, :path])

    # |> validate_required([:docName, :userID, :companyID, :taxNo, :docType, :status, :path])
  end
end
