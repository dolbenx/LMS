defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCountry do
  use Ecto.Migration

  def change do
    create table(:tbl_country) do
      add :country_file_name, :string
      add :name, :string
      add :code, :string
      add :status, :string
      add :approved_by, :integer
      add :created_by, :integer

      timestamps()
    end
  end
end
