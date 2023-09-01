defmodule Loanmanagementsystem.Repo.Migrations.CreateTblWorkingdaysMaintenance do
  use Ecto.Migration

  def change do
    create table(:tbl_workingdays_maintenance) do
      add :monday, :string
      add :tuesday, :string
      add :wednesday, :string
      add :thursday, :string
      add :friday, :string
      add :saturday, :string
      add :sunday, :string

      timestamps()
    end
  end
end
