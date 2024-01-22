defmodule LoanSavingsSystem.Repo.Migrations.CreateTblProvince do
  use Ecto.Migration

  def change do
    create table(:tbl_province) do
      add :name, :string
      add :countryId, :integer
      add :countryName, :string

      timestamps()
    end

  end
end
