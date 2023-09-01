defmodule Loanmanagementsystem.Accounts.Client_reference do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tbl_client_reference" do
    field :contact_no, :string
    field :customer_id, :integer
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(client_reference, attrs) do
    client_reference
    |> cast(attrs, [:customer_id, :name, :contact_no, :status])
    # |> validate_required([:customer_id, :name, :contact_no, :status])
  end
end
