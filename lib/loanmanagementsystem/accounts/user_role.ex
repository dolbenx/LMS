defmodule Loanmanagementsystem.Accounts.UserRole do
  @derive {Jason.Encoder, only: [:userId, :roleType, :status, :otp]}

  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_user_roles" do
    field :roleType, :string
    field :status, :string
    field :userId, :integer
    field :otp, :string
    field :studentID, :string
    field :studentLevel, :string
    field :session, :string
    field :permissions, :string
    field :auth_level, :integer
    field :client_type, :string
    field :isStaff, :boolean, default: false
    field :loan_limit, :decimal

    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [
      :userId,
      :roleType,
      :status,
      :otp,
      :studentID,
      :studentLevel,
      :session,
      :permissions,
      :auth_level,
      :client_type,
      :isStaff,
      :loan_limit
    ])

    # |> validate_required([:userId, :roleType, :status])
  end
end
