defmodule Loanmanagementsystem.Accounts.Client_Documents do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_client_documents" do
    field :name, :string
    field :path, :string
    field :company_id, :integer
    field :userID, :integer
    field :docType, :string
    field :status, :string
    field :clientID, :string
    field :createdBy, :string
    field :approvedBy, :string
    field :file, :string

    timestamps()
  end

  @doc false
  def changeset(client_documents, attrs) do
    client_documents
    |> cast(attrs, [
      :name,
      :path,
      :company_id,
      :userID,
      :docType,
      :status,
      :clientID,
      :createdBy,
      :approvedBy,
      :file
    ])

    # |> validate_required([:name, :path, :company_id, :userID, :docType, :status, :clientID])
  end
end
