defmodule LoanSystem.Repo.Migrations.CreateTblSystemDirectories do
  use Ecto.Migration

  def change do
    create table(:tbl_system_directories) do
      add :failed, :string
      add :processed, :string
      add :bulk_trns, :string
      add :esb_complete, :string
      add :esb_download, :string
      add :esb_failed, :string
      add :esb_pending, :string
      add :internet_trns, :string
      add :inwards, :string
      add :outwards, :string
      add :errors, :string
      add :auth_status, :string
      add :modification, :string
      add :reason, :string

      timestamps()
    end

  end
end
