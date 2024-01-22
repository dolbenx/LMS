defmodule LoanSavingsSystem.Accounts.BankStaffRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_bank_staff_role" do
    field :permissions, :string
    field :roleName, :string

    timestamps()
  end

  @doc false
  def changeset(bank_staff_role, attrs) do
    bank_staff_role
    |> cast(attrs, [:roleName, :permissions])
    |> validate_required([:roleName, :permissions])
  end
end
