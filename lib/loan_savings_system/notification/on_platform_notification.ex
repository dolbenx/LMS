defmodule LoanSavingsSystem.Notification.OnPlatformNotification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_on_platform_notifications" do
    field :message, :string
    field :status, :boolean, default: false
    field :recipient_id, :integer
    field :recipient_user_id, :integer
    field :creator_id, :integer
    field :creator_user_id, :integer
    field :belongs_to, :string
    field :type, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(on_platform_notification, attrs) do
    on_platform_notification
    |> cast(attrs, [:url, :message, :type, :belongs_to, :status, :recipient_id, :recipient_user_id, :creator_id, :creator_user_id])
    |> validate_required([:url, :message, :type, :belongs_to, :status, :creator_id, :creator_user_id ])
  end
end
