defmodule Loanmanagementsystem.Repo.Migrations.CreateTblDepartments do
  use Ecto.Migration

  def change do
    create table(:tbl_departments) do
      add :name, :string
      add :deptCode, :string
      add :companyId, :string
      add :status, :string

      timestamps()
    end
  end
end
