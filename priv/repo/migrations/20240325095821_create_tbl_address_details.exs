defmodule Loanmanagementsystem.Repo.Migrations.CreateTblAddressDetails do
  use Ecto.Migration

  def change do
    create table(:tbl_address_details) do
      add :accomodation_status, :string
      add :area, :string
      add :house_number, :string
      add :street_name, :string
      add :user_id, :integer
      add :years_at_current_address, :integer
      add :country, :integer
      add :province, :integer
      add :town, :integer

      timestamps()
    end
  end
end
