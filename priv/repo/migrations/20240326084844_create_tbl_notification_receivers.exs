defmodule Loanmanagementsystem.Repo.Migrations.CreateTblNotificationReceivers do
  use Ecto.Migration

  def change do
    create table(:tbl_notification_receivers) do
      add :name, :string
      add :email, :string
      add :status, :string
      add :company, :string

      timestamps()
    end
  end
end
