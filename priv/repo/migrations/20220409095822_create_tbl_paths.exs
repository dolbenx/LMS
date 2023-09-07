defmodule Loanmanagementsystem.Repo.Migrations.CreateTblPaths do
  use Ecto.Migration

  def change do
    create table(:tbl_paths) do
      add :path, :string
      add :name, :string

      timestamps()
    end
  end
end
