defmodule LoanSavingsSystem.Accounts.GLAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_gl_account" do
    field :accountName, :string
    field :accountNumber, :string
    field :accountSubType, :string
    field :accountType, :string
    field :clientId, :integer
    field :createdByUserId, :integer

    timestamps()
  end

  @doc false
  def changeset(gl_account, attrs) do
    gl_account
    |> cast(attrs, [:accountType, :accountName, :accountNumber, :accountSubType, :clientId, :createdByUserId])
    |> validate_required([:accountType, :accountName, :accountNumber, :accountSubType, :clientId, :createdByUserId])
  end
end
