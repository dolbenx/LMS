defmodule LoanSystem.Repo.Migrations.CreateUssds do
  use Ecto.Migration

  def change do
    create table(:ussds) do

      timestamps()
    end

  end
end
