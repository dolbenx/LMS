defmodule LoanSystem.Repo.Migrations.CreateTblSystemSettings do
  use Ecto.Migration

  def change do
    create table(:tbl_system_settings) do
      add :name, :string
      add :value, :string
      add :last_updated_by, :string

      timestamps()
    end

  end
end
