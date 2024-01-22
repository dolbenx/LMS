defmodule Loanmanagementsystem.Repo.Migrations.AlterClientDocumentsAtLoanId do
  use Ecto.Migration

  def change do
    alter table(:tbl_client_documents) do
      add :loan_id, :integer
    end
  end
end
