defmodule LoanSavingsSystem.Repo.Migrations.CreateTblLoanProductDocumentType do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_product_document_type) do
      add :productId, :integer
      add :documentTypeId, :integer
      add :isRequired, :boolean, default: false, null: false

      timestamps()
    end

  end
end
