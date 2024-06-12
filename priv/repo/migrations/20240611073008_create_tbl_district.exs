defmodule Loanmanagementsystem.Repo.Migrations.CreateTblDistrict do
  use Ecto.Migration

  def change do
    create table(:tbl_district) do
      add :name, :string
      add :country_id, :integer
      add :province_id, :integer
      add :status, :string
      add :approved_by, :integer
      add :created_by, :integer

      timestamps()
    end
  end
end
