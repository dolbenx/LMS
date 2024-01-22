defmodule LoanSavingsSystem.Repo.Migrations.CreateTblProducts do
  use Ecto.Migration

  def change do
    create table(:tbl_products) do
      add :name, :string
      add :code, :string
      add :details, :string
      add :currencyId, :integer
      add :currencyName, :string
      add :currencyDecimals, :integer
      add :interest, :float
      add :interestType, :string
      add :interestMode, :string
      add :defaultPeriod, :integer
      add :periodType, :string
      add :productType, :string
      add :minimumPrincipal, :float
      add :maximumPrincipal, :float
      add :clientId, :integer
      add :yearLengthInDays, :integer
      add :status, :string
      add :minimumPeriod, :integer
      add :maximumPeriod, :integer

      timestamps()
    end

  end
end
