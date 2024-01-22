defmodule Loanmanagementsystem.Repo.Migrations.CreateTblEndOfDayEntries do
  use Ecto.Migration

  def change do
    create table(:tbl_end_of_day_entries) do
      add :currencyId, :integer
      add :currencyName, :string
      add :end_of_day_date, :utc_datetime
      add :end_of_day_id, :integer
      add :interest_accrued, :float
      add :penalties_incurred, :float
      add :charges_incurred, :float
      add :status, :string
      add :loan_id, :integer
      add :accrual_start_date, :utc_datetime
      add :accrual_end_date, :utc_datetime
      add :accrual_period, :integer
      add :principal_amount, :float

      timestamps()
    end

  end
end
