defmodule Loanmanagementsystem.Accounts.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_user_roles" do
    field :auth_level, :integer
    field :permissions, :string
    field :role_type, :string
    field :session, :string
    field :status, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:role_type, :status, :user_id, :session, :permissions, :auth_level])
    |> validate_required([:role_type, :status, :user_id, :session, :permissions, :auth_level])
  end
end
