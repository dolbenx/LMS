defmodule LoanSavingsSystem.Accounts.UserRole do
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

    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:userId, :roleType, :clientId, :status, :otp, :companyId, :netPay, :branchId, :isLoanOfficer])
    |> validate_required([:userId, :roleType, :status])
  end
end
