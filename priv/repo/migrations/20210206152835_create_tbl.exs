defmodule LoanSavingsSystem.Repo.Migrations.CreateTbl do
  use Ecto.Migration

  def change do
    create table(:tbl) do
      add :_employer, :string
      add :companyId, :integer
      add :status, :string

      timestamps()
    end

  end
end
