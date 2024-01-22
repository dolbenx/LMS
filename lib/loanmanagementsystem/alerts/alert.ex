defmodule Loanmanagementsystem.Alerts.Alert do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_alert_templete" do
    field :alert_message, :string
    field :alert_type, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(alert, attrs) do
    alert
    |> cast(attrs, [:alert_type, :alert_message, :status])
    |> validate_required([:alert_type, :alert_message, :status])
  end
end
