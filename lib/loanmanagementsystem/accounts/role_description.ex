defmodule Loanmanagementsystem.Accounts.RoleDescription do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_role_description" do
    field :role_description, :string
    field :status, :string
    field :user_Id, :integer
    field :role_id, :integer

    timestamps()
  end

  @doc false
  def changeset(role_description, attrs) do
    role_description
    |> cast(attrs, [:role_description, :status, :user_Id, :role_id])
    |> validate_required([:role_description, :status, :user_Id, :role_id])
  end
end
