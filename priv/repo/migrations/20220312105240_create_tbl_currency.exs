defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCurrency do
  use Ecto.Migration

  def change do
    create table(:tbl_currency) do
      add :countryId, :integer
      add :isoCode, :string
      add :name, :string
      add :currencyDecimal, :integer

      timestamps()
    end
  end
end
