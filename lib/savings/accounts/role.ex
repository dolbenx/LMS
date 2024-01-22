defmodule Savings.Accounts.Role do
  use Endon
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Savings.Accounts.Role.Localtime, :autogenerate, []}]
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

    # |> validate_required([:role_group, :role_desc, :role_str, :status])
  end

  defmodule Localtime do
    def autogenerate, do: Timex.local() |> DateTime.truncate(:second) |> DateTime.to_naive()
  end
end
