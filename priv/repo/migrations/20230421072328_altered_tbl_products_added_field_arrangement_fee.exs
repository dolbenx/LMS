defmodule Loanmanagementsystem.Repo.Migrations.AlteredTblProductsAddedFieldArrangementFee do
  use Ecto.Migration

  def change do
    alter table(:tbl_products) do
      add :arrangement_fee, :float

    end
  end
end
