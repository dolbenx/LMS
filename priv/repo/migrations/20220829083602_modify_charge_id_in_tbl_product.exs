defmodule Loanmanagementsystem.Repo.Migrations.ModifyChargeIdInTblProduct do
  use Ecto.Migration

  def up do
    alter table(:tbl_products) do
      remove :charge_id
      add :charge_id, :map
    end
  end

  def down do
    alter table(:tbl_products) do
      remove :charge_id
    end
  end
end
