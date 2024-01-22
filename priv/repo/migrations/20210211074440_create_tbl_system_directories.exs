defmodule LoanSavingsSystem.Repo.Migrations.CreateTblSystemDirectories do
  use Ecto.Migration

  def change do
    create table(:tbl_system_directories) do
      add :bulk_trns, :string
      add :esb_complete, :string
      add :esb_downloa, :string
      add :failed, :string
      add :processed, :string

      timestamps()
    end

  end
end
