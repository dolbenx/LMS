defmodule Loanmanagementsystem.Repo.Migrations.CreateTblDistrict do
  use Ecto.Migration

  def change do
    create table(:tbl_district) do
      add :countryId, :integer
      add :countryName, :string
      add :name, :string
      add :provinceId, :integer
      add :provinceName, :string

      timestamps()
    end
  end
end
