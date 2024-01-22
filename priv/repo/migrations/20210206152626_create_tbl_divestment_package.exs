defmodule LoanSavingsSystem.Repo.Migrations.CreateTblDivestmentPackage do
  use Ecto.Migration

  def change do
    create table(:tbl_divestment_package) do
      add :startPeriodDays, :integer
      add :endPeriodDays, :integer
      add :divestmentValuation, :float
      add :productId, :integer
      add :status, :string
      add :clientId, :integer

      timestamps()
    end

  end
end
