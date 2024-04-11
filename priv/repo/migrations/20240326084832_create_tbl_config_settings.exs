defmodule Loanmanagementsystem.Repo.Migrations.CreateTblConfigSettings do
  use Ecto.Migration

  def change do
    create table(:tbl_config_settings) do
      add :name, :string
      add :value, :string
      add :value_type, :string
      add :description, :string
      add :deleted_at, :naive_datetime
      add :updated_by, :string

      timestamps()
    end
  end
end
