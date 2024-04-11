defmodule Loanmanagementsystem.Logs.SessionLogs do
  use Ecto.Schema
  import Ecto.Changeset

  use Endon

  alias Loanmanagementsystem.Accounts.User

  @columns [
    :session_id,
    :status,
    :portal,
    :description,
    :device_uuid,
    :system_platform_name,
    :ip_address,
    :full_browser_name,
    :browser_details,
    :user_id,
    :device_type,
    :known_browser
  ]

  schema "tbl_session_logs" do
    field :status, :boolean
    field :session_id, :string
    field :description, :string
    field :device_uuid, :string
    field :ip_address, :string
    field :device_type, :string
    field :known_browser, :boolean
    field :browser_details, :string
    field :full_browser_name, :string
    field :system_platform_name, :string
    field :portal, :string, default: "FRONTEND"

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(logs, attrs) do
    logs
    |> cast(attrs, @columns)
  end

end
