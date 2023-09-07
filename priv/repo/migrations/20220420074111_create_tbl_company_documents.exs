defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCompanyDocuments do
  use Ecto.Migration

  def change do
    create table(:tbl_company_documents) do
      add :docName, :string
      add :userID, :integer
      add :companyID, :integer
      add :taxNo, :string
      add :docType, :string
      add :status, :string
      add :path, :string

      timestamps()
    end
  end
end
