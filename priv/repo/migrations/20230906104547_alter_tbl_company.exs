defmodule Loanmanagementsystem.Repo.Migrations.AlterTblCompany do
  use Ecto.Migration

  def up do
    alter table(:tbl_company) do
      add :area, :string
      add :twon, :string
      add :province, :string
      add :employer_industry_type, :string
      add :employer_office_building_name, :string
      add :employer_officer_street_name, :string

    end
  end

  def down do
    alter table(:tbl_company) do
      remove :area, :string
      remove :twon, :string
      remove :province, :string
      remove :employer_industry_type, :string
      remove :employer_office_building_name, :string
      remove :employer_officer_street_name, :string
    end
  end
end
