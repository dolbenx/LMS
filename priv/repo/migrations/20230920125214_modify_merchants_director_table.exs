defmodule Loanmanagementsystem.Repo.Migrations.ModifyMerchantsDirectorTable do
  use Ecto.Migration

  def up do
    alter table(:tbl_merchant_dir) do
      add :date_of_birth, :date
      add :title, :string
      add :gender, :string
      add :house_number, :string
      add :street_name, :string
      add :area, :string
      add :town, :string
      add :province, :string
      add :accomodation_status, :string
      add :years_at_current_address, :integer
    end
  end

  def down do
    alter table(:tbl_merchant_dir) do
      remove :date_of_birth
      remove :title
      remove :gender
      remove :house_number
      remove :street_name
      remove :area
      remove :town
      remove :province
      remove :accomodation_status
      remove :years_at_current_address
    end
  end
end
