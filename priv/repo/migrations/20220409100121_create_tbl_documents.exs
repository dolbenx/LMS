defmodule Loanmanagementsystem.Repo.Migrations.CreateTblDocuments do
  use Ecto.Migration

  def change do
    create table(:tbl_documents) do
      add :name, :string
      add :path_id, :integer
      add :company_id, :integer

      timestamps()
    end
  end
end
