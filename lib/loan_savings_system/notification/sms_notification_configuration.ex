defmodule LoanSavingsSystem.Notification.SmsNotificationConfiguration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_sms_notification_configuration" do
    field :actionType, :string
    field :days, :integer
    field :interval, :integer
    field :intervaltype, :string
    field :message, :string
    field :numberOfSms, :integer
	  field :status, :string

    timestamps()
  end

  @doc false
  def changeset(sms_notification_configuration, attrs) do
    sms_notification_configuration
    |> cast(attrs, [:status, :days, :actionType, :numberOfSms, :interval, :intervaltype, :message])
    |> validate_required([:days, :actionType, :numberOfSms, :interval, :intervaltype, :message])
  end
end
