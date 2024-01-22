defmodule LoanSavingsSystem.Repo.Migrations.CreateTblTelco do
  use Ecto.Migration

  def change do
    create table(:tbl_telco) do
      add :name, :string
      add :telcoIP, :string

      timestamps()
    end

  end
end
