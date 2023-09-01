defmodule Loanmanagementsystem.Repo.Migrations.CreateTblAlertMaintenance do
  use Ecto.Migration

  def change do
    create table(:tbl_alert_maintenance) do
      add :alert_type, :string
      add :message, :string
      add :alert_description, :string
      add :status, :string

      timestamps()
    end
  end
end
