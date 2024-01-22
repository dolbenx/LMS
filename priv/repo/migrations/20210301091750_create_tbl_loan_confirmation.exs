defmodule LoanSavingsSystem.Repo.Migrations.CreateTblLoanConfirmation do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_confirmation) do
      add :loan_documentId, :integer
      add :documentTypeId, :string
      add :companyId, :integer
      add :status, :string
      add :sentByUserRoleId, :integer
      add :sentByUserId, :integer
      add :details, :string
      add :submitedBy, :string

      timestamps()
    end

  end
end
