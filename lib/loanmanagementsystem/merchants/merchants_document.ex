defmodule Loanmanagementsystem.Merchants.Merchants_document do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_merchant_and_agent_doc" do
    field :companyID, :integer
    field :docName, :string
    field :docType, :string
    field :path, :string
    field :status, :string
    field :taxNo, :string
    field :userID, :integer
    field :file, :string

    timestamps()
  end

  @doc false
  def changeset(merchants_document, attrs) do
    merchants_document
    |> cast(attrs, [:docName, :userID, :companyID, :taxNo, :docType, :status, :path, :file])

    # |> validate_required([:docName, :userID, :companyID, :taxNo, :docType, :status, :path])
  end
end
