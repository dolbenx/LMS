defmodule Loanmanagementsystem.Repo.Migrations.CreateTblEndOfDay do
  use Ecto.Migration

  def change do
    create table(:tbl_end_of_day) do
      add :loan_id, :integer
      add :currencyId, :integer
      add :currencyName, :string
      add :date_ran, :utc_datetime
      add :end_date, :utc_datetime
      add :end_of_day_type, :string
      add :penalties_incurred, :float
      add :start_date, :utc_datetime
      add :status, :string
      add :total_interest_accrued, :float, default: 0.0
      add :principal_amount, :float

      timestamps()
    end

  end
end
