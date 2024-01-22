defmodule LoanSavingsSystem.Repo.Migrations.CreateTblCountry do
  use Ecto.Migration

  def change do
    create table(:tbl_country) do
      add :name, :string
      add :country_file_name, :string

      timestamps()
    end

  end
end
