defmodule LoanSavingsSystem.Repo.Migrations.CreateTblAnnouncements do
  use Ecto.Migration

  def change do
    create table(:tbl_announcements) do
      add :message, :string
      add :title, :string
      add :status, :string
      add :recipient, :string
      add :creator_id, :integer

      timestamps()
    end
  end
end
