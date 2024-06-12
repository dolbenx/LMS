defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCurrency do
  use Ecto.Migration

  def change do
    create table(:tbl_currency) do
      add :name, :string
      add :acronym, :string
      add :country_id, :integer
      add :iso_code, :string
      add :currency_decimal, :integer
      add :status, :string
      add :approved_by, :integer
      add :created_by, :integer

      timestamps()
    end
  end
end
