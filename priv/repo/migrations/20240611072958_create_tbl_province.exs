defmodule Loanmanagementsystem.Repo.Migrations.CreateTblProvince do
  use Ecto.Migration

  def change do
    create table(:tbl_province) do
      add :name, :string
      add :country_id, :integer
      add :status, :string
      add :approved_by, :integer
      add :created_by, :integer

      timestamps()
    end
  end
end
