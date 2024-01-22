defmodule LoanSavingsSystem.Repo.Migrations.CreateTblCurrency do
  use Ecto.Migration

  def change do
    create table(:tbl_currency) do
      add :name, :string
      add :isoCode, :string
      add :countryId, :integer

      timestamps()
    end

  end
end
