defmodule LoanSavingsSystem.Repo.Migrations.CreateTblDocumentType do
    use Ecto.Migration

    def change do
      create table(:tbl_document_type) do
        add :required, :string
        add :doc_type, :string
        add :status, :string, default: "PENDING"
        add :belongs_to, :string
        add :created_by, :integer
        add :approved_by, :integer
        add :applicable_to, :string
        add :description, :string
        add :documentFormats, :string
        add :name, :string

        timestamps()
      end

    end
  end
