defmodule LoanSavingsSystem.Repo.Migrations.CreateTblEmployee do
  use Ecto.Migration

  def change do
    create table(:tbl_employee) do
      add :companyId, :integer
      add :employerId, :integer
      add :userRoleId, :integer
      add :userId, :integer
      add :status, :string

      timestamps()
    end

  end
end
