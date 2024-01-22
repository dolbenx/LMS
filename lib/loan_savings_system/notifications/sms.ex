defmodule LoanSavingsSystem.Notifications.Sms do
  use Endon
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_sms" do
    field :mobile, :string
    field :msg, :string
    field :msg_count, :string, default: "0"
    field :status, :string
    field :type, :string
    field :date_sent, :naive_datetime


    timestamps()
  end

  @doc false
  def changeset(sms, attrs) do
    sms
    |> cast(attrs, [:type, :mobile, :msg_count, :status, :msg])
    |> validate_required([:type, :mobile, :msg_count, :status, :msg])
  end
end
