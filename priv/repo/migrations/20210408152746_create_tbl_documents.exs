defmodule LoanSystem.Repo.Migrations.CreateTblDocuments do
  use Ecto.Migration

  def change do
    create table(:tbl_documents) do
      add :external_id, :integer
      add :document_type, :string
      add :document_file, :string

      timestamps()
    end

  end
end
