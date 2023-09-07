defmodule Loanmanagementsystem.Repo.Migrations.ModifyTblProducts do
  use Ecto.Migration

  def up do
    alter table(:tbl_products) do
      remove :charge_id
      add :charge_id, :text
    end
  end

  def down do
    alter table(:tbl_products) do
      remove :charge_id
    end
  end
end
