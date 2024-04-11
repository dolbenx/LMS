defmodule Loanmanagementsystem.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_roles" do
    field :role_desc, :string
    field :role_group, :string
    field :role_str, :map
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:role_desc, :role_group, :role_str, :status])
    |> validate_required([:role_desc, :role_group, :role_str, :status])
  end
end
