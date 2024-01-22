defmodule LoanSavingsSystem.Repo.Migrations.CreateTblEndOfDayEntries do
  use Ecto.Migration

  def change do
    create table(:tbl_end_of_day_entries) do
      add :end_of_day_id, :integer
      add :interest_accrued, :float
      add :penalties_incurred, :float
      add :end_of_day_date, :utc_datetime
      add :status, :string
      add :currencyId, :integer
      add :currencyName, :string
	  add :fixed_deposit_id, :integer
	  add :accrual_start_date, :utc_datetime
	  add :accrual_end_date, :utc_datetime
	  add :accrual_period, :integer

      timestamps()
    end

  end
end
