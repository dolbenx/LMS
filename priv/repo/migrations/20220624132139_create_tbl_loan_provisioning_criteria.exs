defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanProvisioningCriteria do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_provisioning_criteria) do
      add :criteriaName, :string
      add :productId, :integer
      add :minAge, :string
      add :maxAge, :string
      add :percentage, :string
      add :liability_account_id, :string
      add :expense_account_id, :string
      add :category, :string

      timestamps()
    end
  end
end
