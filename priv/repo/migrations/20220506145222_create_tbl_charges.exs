defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCharges do
  use Ecto.Migration

  def change do
    create table(:tbl_charges) do
      add :chargeAmount, :float
      add :chargeWhen, :string
      add :chargeName, :string
      add :chargeType, :string
      add :currency, :string
      add :currencyId, :integer
      add :isPenalty, :boolean, default: false, null: false
      add :code, :string
      add :accountToCredit, :string
      add :effectiveDate, :date


      timestamps()
    end
  end
end
