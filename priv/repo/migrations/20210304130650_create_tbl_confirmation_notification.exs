defmodule LoanSavingsSystem.Repo.Migrations.CreateTblConfirmationNotification do
  use Ecto.Migration

  def change do
    create table(:tbl_confirmation_notification) do
      add :message, :string
      add :read, :boolean, default: false, null: false
      add :recipientUserID, :integer
      add :recipientUserRoleId, :integer
      add :sentByUserId, :integer
      add :sentByUserRoleId, :integer

      timestamps()
    end

  end
end
