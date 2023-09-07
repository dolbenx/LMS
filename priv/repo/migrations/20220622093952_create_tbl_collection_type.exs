defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCollectionType do
  use Ecto.Migration

  def change do
    create table(:tbl_collection_type) do
      add :collection_type_description, :string
      add :system_id, :string

      timestamps()
    end
  end
end
