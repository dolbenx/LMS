defmodule Loanmanagementsystem.Repo.Migrations.CreateTblClientDocuments do
  use Ecto.Migration

  def change do
    create table(:tbl_client_documents) do
      add :name, :string
      add :path, :string
      add :company_id, :integer
      add :userID, :integer
      add :docType, :string
      add :status, :string
      add :clientID, :string
      add :createdBy, :string
      add :approvedBy, :string
      add :file, :string

      timestamps()
    end
  end
end
