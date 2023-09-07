defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanColleteralDocuments do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_colleteral_documents) do
      add :name, :string
      add :userID, :integer
      add :file, :string
      add :company_id, :integer
      add :path, :string
      add :docType, :string
      add :clientID, :integer
      add :reference_no, :string
      add :status, :string
      add :serialNo, :string

      timestamps()
    end

  end
end
