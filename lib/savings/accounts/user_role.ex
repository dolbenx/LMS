defmodule Savings.Accounts.UserRole do
  @derive {Jason.Encoder, only: [:userId, :roleType, :clientId, :status, :otp, :companyId]}

  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_user_roles" do
    field :clientId, :integer
    field :roleType, :string
    field :status, :string
    field :userId, :integer
    field :otp, :string
    field :companyId, :integer
    field :netPay, :float
    field :branchId, :integer
    field :isLoanOfficer, :boolean
    field :permissions, :string
    field :roleId, :integer

    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [
      :roleId,
      :userId,
      :roleType,
      :clientId,
      :status,
      :otp,
      :companyId,
      :netPay,
      :branchId,
      :isLoanOfficer,
      :permissions
    ])

    # |> validate_required([:userId, :roleType, :status])
  end

  def changesetforupdate(user_role, attrs) do
    user_role
    |> cast(attrs, [
      :roleId,
      :userId,
      :roleType,
      :clientId,
      :status,
      :otp,
      :companyId,
      :netPay,
      :branchId,
      :isLoanOfficer,
      :permissions
    ])
  end
end
