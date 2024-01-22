defmodule LoanSavingsSystem.Repo.Migrations.CreateTblCharge do
  use Ecto.Migration

  def change do
    create table(:tbl_charge) do
      add :chargeName, :string
      add :currency, :string
      add :currencyId, :integer
      add :isPenalty, :boolean, default: false, null: false
      add :clientId, :integer
      add :chargeType, :string
      add :chargeAmount, :float
      add :chargeWhen, :string

      timestamps()
    end

  end
end
