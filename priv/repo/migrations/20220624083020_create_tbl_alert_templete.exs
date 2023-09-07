defmodule Loanmanagementsystem.Repo.Migrations.CreateTblAlertTemplete do
  use Ecto.Migration

  def change do
    create table(:tbl_alert_templete) do
      add :alert_type, :string
      add :alert_message, :string
      add :status, :string

      timestamps()
    end
  end
end
