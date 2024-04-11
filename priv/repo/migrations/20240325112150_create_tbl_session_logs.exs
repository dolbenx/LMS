defmodule Loanmanagementsystem.Repo.Migrations.CreateTblSessionLogs do
  use Ecto.Migration

  def change do
    create table(:tbl_session_logs) do
      add :status, :boolean, default: false, null: false
      add :session_id, :string
      add :description, :string
      add :device_uuid, :string
      add :ip_address, :string
      add :device_type, :string
      add :known_browser, :boolean, default: false, null: false
      add :browser_details, :string
      add :full_browser_name, :string
      add :system_platform_name, :string
      add :portal, :string

      timestamps()
    end
  end
end
