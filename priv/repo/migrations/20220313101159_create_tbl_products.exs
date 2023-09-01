defmodule Loanmanagementsystem.Repo.Migrations.CreateTblProducts do
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
      add :principle_account_id, :integer
      add :interest_account_id, :integer
      add :charges_account_id, :integer
      add :classification_id, :integer
      add :charge_id, :integer
      add :reference_id, :integer
      add :reason, :string
      add :finance_cost, :float
      add :arrangement_fee, :float

      timestamps()
    end
  end
end
