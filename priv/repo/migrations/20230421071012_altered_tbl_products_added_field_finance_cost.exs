defmodule Loanmanagementsystem.Repo.Migrations.AlteredTblProductsAddedFieldFinanceCost do
  use Ecto.Migration

  def change do
    alter table(:tbl_products) do
      add :finance_cost, :float

    end
  end
end
