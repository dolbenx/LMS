defmodule LoanSavingsSystem.Repo.Migrations.CreateTblOnPlatformNotifications do
  use Ecto.Migration

  def change do
    create table(:tbl_on_platform_notifications) do
      add :message, :string
      add :status, :boolean, default: false
      add :recipient_id, :integer
      add :recipient_user_id, :integer
      add :creator_id, :integer
      add :creator_user_id, :integer
      add :belongs_to, :string
      add :type, :string
      add :url, :string

      timestamps()
    end

  end
end
