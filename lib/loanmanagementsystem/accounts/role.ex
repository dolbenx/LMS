defmodule Loanmanagementsystem.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

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
    |> cast(attrs, [:role_group, :role_desc, :role_str, :status])
    |> validate_required([:role_group, :role_desc, :role_str, :status])
  end
end
