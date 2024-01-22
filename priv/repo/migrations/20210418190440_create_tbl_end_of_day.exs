defmodule LoanSavingsSystem.Repo.Migrations.CreateTblEndOfDay do
  use Ecto.Migration

  def change do
    create table(:tbl_end_of_day) do
      add :date_ran, :utc_datetime  
      add :total_interest_accrued, :float
      add :penalties_incurred, :float
      add :end_of_day_type, :string
      add :start_date, :utc_datetime  
      add :end_date, :utc_datetime  
      add :status, :string
      add :currencyId, :integer
      add :currencyName, :string
	add :total_principal_deposited, :float
	add :total_charge_deposit, :float
	add :divestment_principal_total, :float
	add :divestment_interest_total, :float
	add :withdrawals_principal_total, :float
	add :withdrawals_interest_total, :float
      

      timestamps()
    end

  end
end
