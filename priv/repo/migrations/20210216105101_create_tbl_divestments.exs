defmodule Savings.Repo.Migrations.CreateTblDivestments do
  use Ecto.Migration

  def change do
    create table(:tbl_divestments) do
      add :fixedDepositId, :integer
      add :principalAmount, :float
      add :fixedPeriod, :integer
      add :interestRate, :float
      add :interestRateType, :string
      add :divestmentDate, :date
      add :divestmentDayCount, :integer
      add :divestmentValuation, :float
      add :divestAmount, :float
      add :clientId, :integer
      add :interestAccrued, :float
      add :userId, :integer
      add :userRoleId, :integer
      add :customerName, :string
      add :currencyDecimals, :integer
      add :currency, :string
      add :divestmentType, :string


      timestamps()
    end

  end
end
