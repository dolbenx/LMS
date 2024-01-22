defmodule Loanmanagementsystem.Repo.Migrations.AlterTblLoanTxn270923 do
  use Ecto.Migration

  def up do
    alter table(:tbl_transactions) do
      add :product_id, :integer
    end
  end

  def down do
    alter table(:tbl_transactions) do
      remove_if_exists(:product_id, :integer)
    end
  end
end
