defmodule Loanmanagementsystem.Repo.Migrations.AlterTblLoanTxn031023 do
  use Ecto.Migration

  def up do
    alter table(:tbl_transactions) do
      add :is_bulk_upload, :boolean, default: false, null: false
    end
  end

  def down do
    alter table(:tbl_transactions) do
      remove_if_exists(:is_bulk_upload, :integer)
    end
  end
end
