defmodule Loanmanagementsystem.Repo.Migrations.CreateTblProvince do
  use Ecto.Migration

  def change do
    create table(:tbl_province) do
      add :countryId, :integer
      add :countryName, :string
      add :name, :string

      timestamps()
    end
  end
end
