defmodule Loanmanagementsystem.Alerts.Alert do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

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
