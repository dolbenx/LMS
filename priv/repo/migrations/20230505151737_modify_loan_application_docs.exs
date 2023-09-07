defmodule Loanmanagementsystem.Repo.Migrations.ModifyLoanApplicationDocs do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_application_documents) do
      add :for_repayment, :boolean

    end
  end
end
