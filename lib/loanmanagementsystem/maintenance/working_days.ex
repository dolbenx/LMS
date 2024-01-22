defmodule Loanmanagementsystem.Maintenance.Working_days do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_workingdays_maintenance" do
    field :friday, :string, default: "No"
    field :monday, :string, default: "No"
    field :saturday, :string, default: "No"
    field :sunday, :string, default: "No"
    field :thursday, :string, default: "No"
    field :tuesday, :string, default: "No"
    field :wednesday, :string, default: "No"

    timestamps()
  end

  @doc false
  def changeset(working_days, attrs) do
    working_days
    |> cast(attrs, [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday])

    # |> validate_required([:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday])
  end
end
