defmodule LoanSavingsSystem.Repo.Migrations.CreateTblDistrict do
  use Ecto.Migration

  def change do
    create table(:tbl_district) do
      add :name, :string
      add :countryId, :integer
      add :countryName, :string
      add :provinceId, :integer
      add :provinceName, :string

      timestamps()
    end

  end
end
