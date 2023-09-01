defmodule Loanmanagementsystem.Repo.Migrations.CreateTblHolidayMaintenance do
  use Ecto.Migration

  def change do
    create table(:tbl_holiday_maintenance) do
      add :year, :string
      add :month, :string
      add :holiday_date, :date
      add :holiday_description, :string
      add :status, :string

      timestamps()
    end
  end
end
