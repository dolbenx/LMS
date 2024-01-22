defmodule LoanSavingsSystem.Repo.Migrations.CreateTblLoanDocuments do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_documents) do
      add :loanId, :integer
      add :documentName, :string
      add :documentLocation, :string
      add :updatedByUserId, :integer
      add :updatedByUseroleId, :integer

      timestamps()
    end

  end
end
