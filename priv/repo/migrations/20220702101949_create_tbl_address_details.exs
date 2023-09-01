defmodule Loanmanagementsystem.Repo.Migrations.CreateTblAddressDetails do
  use Ecto.Migration

  def change do
    create table(:tbl_address_details) do
      add :accomodation_status, :string
      add :area, :string
      add :house_number, :string
      add :street_name, :string
      add :town, :string
      add :userId, :integer
      add :year_at_current_address, :integer
      add :province, :string

      timestamps()
    end
  end
end
