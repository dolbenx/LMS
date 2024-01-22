defmodule LoanSavingsSystem.Repo.Migrations.CreateHolidays do
  use Ecto.Migration

  def change do
    create table(:holidays) do
      add :name, :string
      add :from_date, :date
      add :to_date, :date
      add :maturity_payments_rescheduled_to, :date
      add :status, :string
      add :calendar_id, :integer

      timestamps()
    end

  end
end
