defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCompanyBranches do
  use Ecto.Migration

  def change do
    create table(:tbl_company_branches) do
      add :name, :string
      add :branchCode, :string
      add :companyId, :string
      add :status, :string

      timestamps()
    end
  end
end
