defmodule LoanSavingsSystem.Repo.Migrations.CreateTblAddresses do
  use Ecto.Migration

  def change do
    create table(:tbl_addresses) do
      add :addressLine1, :string
      add :addressLine2, :string
      add :city, :string
      add :districtId, :integer
      add :districtName, :string
      add :provinceId, :integer
      add :provinceName, :string
      add :countryId, :integer
      add :countryName, :string
      add :isCurrent, :boolean, default: false, null: false
      add :userId, :integer
      add :clientId, :integer

      timestamps()
    end

  end
end
