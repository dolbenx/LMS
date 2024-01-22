defmodule Savings.Repo.Migrations.CreateTblProductPeriod do
  use Ecto.Migration

  def change do
    create table(:tbl_product_period) do
      add :productID, :integer
      add :periodDays, :string
      add :periodType, :string
      add :status, :string
      add :defaultPeriod, :integer
      add :interest, :float
      add :interestType, :string
      add :yearLengthInDays, :integer

      timestamps()
    end
  end
end
