defmodule Loanmanagementsystem.Repo.Migrations.CreateTblBranchs do
  use Ecto.Migration

  def change do
    create table(:tbl_branchs) do
      add :branch_code, :string
      add :branch_name, :string
      add :bank_id, :integer
      add :is_default_ussd_branch, :boolean, default: false, null: false
      add :status, :string
      add :country_id, :integer
      add :province_id, :integer
      add :district_id, :integer
      add :branch_address, :string
      add :approved_by, :integer
      add :created_by, :integer

      timestamps()
    end
  end
end
