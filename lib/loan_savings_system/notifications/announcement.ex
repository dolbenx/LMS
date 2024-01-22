defmodule LoanSavingsSystem.Notification.Announcements do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_announcements" do
    field :message, :string
    field :title, :string
    field :status, :string
    field :recipient, :string
    field :creator_id, :integer

    timestamps()
  end

  @doc false
  def changeset(announcements, attrs) do
    announcements
    |> cast(attrs, [:message, :status, :recipient, :creator_id, :title])
  end
end



