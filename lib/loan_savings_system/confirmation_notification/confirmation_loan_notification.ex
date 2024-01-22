defmodule LoanSavingsSystem.ConfirmationNotification.ConfirmationLoanNotification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_confirmation_notification" do
    field :message, :string
    field :read, :boolean, default: false
    field :recipientUserID, :integer
    field :recipientUserRoleId, :integer
    field :sentByUserId, :integer
    field :sentByUserRoleId, :integer

    timestamps()
  end


  @doc false
  def changeset(confirmation__loan__notification, attrs) do
    confirmation__loan__notification
    |> cast(attrs, [:message, :sentByUserId, :sentByUserRoleId, :recipientUserID, :recipientUserRoleId, :read])
    |> validate_required([:message, :sentByUserId, :sentByUserRoleId, :recipientUserID, :recipientUserRoleId, :read])
  end
end
