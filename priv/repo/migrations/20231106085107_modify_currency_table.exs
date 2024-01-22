defmodule Loanmanagementsystem.Repo.Migrations.ModifyCurrencyTable do
  use Ecto.Migration

  def up do
    alter table(:tbl_country) do
      add :currency_name, :string
      add :iso_code, :string
      add :currency_decimal, :integer
    end
  end

  def down do
    alter table(:tbl_country) do
      remove :currency_name
      remove :iso_code
      remove :currency_decimal
    end
  end
end
