defmodule Loanmanagementsystem.Repo.Migrations.CreateTblBanks do
  use Ecto.Migration

  def change do
    create table(:tbl_banks) do
      add :acronym, :string
      add :bank_code, :string
      add :bank_descrip, :string
      add :process_branch, :string
      add :swift_code, :string
      add :bank_name, :string
      add :status, :string
      add :country_id, :integer
      add :province_id, :integer
      add :city_id, :integer
      add :district_id, :integer
      add :bank_address, :string
      add :approved_by, :integer
      add :created_by, :integer

      timestamps()
    end
  end
end
