defmodule LoanSavingsSystem.Repo.Migrations.CreateCalendars do
  use Ecto.Migration

  def change do
    create table(:calendars) do
      add :name, :string
      add :start_date, :date
      add :end_date, :date
      add :createdby_id, :integer

      timestamps()
    end

  end
end
