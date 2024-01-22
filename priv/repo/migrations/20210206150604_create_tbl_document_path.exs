defmodule LoanSavingsSystem.Repo.Migrations.CreateTblDocumentPath do
  use Ecto.Migration

  def change do
    create table(:tbl_document_path) do
      add :path, :string
      add :belongs_to, :string
      add :applicable_on, :string
      add :created_by, :integer
      add :approved_by, :integer
      add :status, :string
      add :path_name, :string

      timestamps()
    end
  end
end
