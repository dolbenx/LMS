defmodule Loanmanagementsystem.Maintenance.Alert_Maintenance do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_alert_maintenance" do
    field :alert_description, :string
    field :alert_type, :string
    field :message, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(alert__maintenance, attrs) do
    alert__maintenance
    |> cast(attrs, [:alert_type, :message, :alert_description, :status])
    |> validate_required([:alert_type, :message, :alert_description, :status])
  end
end
