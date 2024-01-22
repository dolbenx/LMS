defmodule LoanSavingsSystem.Repo.Migrations.CreateTblBanks do
  use Ecto.Migration

  def change do
    create table(:tbl_banks) do
      add :name, :string
      add :eod_url, :string

      timestamps()
    end

  end
end
