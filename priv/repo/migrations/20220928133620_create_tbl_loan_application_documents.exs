defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanApplicationDocuments do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_application_documents) do
      add :doc_name, :string
      add :doc_type, :string
      add :status, :string
      add :path, :string
      add :customer_id, :integer
      add :loan_id, :integer
      add :fileName, :string

      timestamps()
    end

  end
end
