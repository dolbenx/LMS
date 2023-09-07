defmodule Loanmanagementsystem.Repo.Migrations.AlterTransLogFilename do
  use Ecto.Migration

  def up do
    alter table(:tbl_trans_log) do
      add :journalentry_filename, :string
    end
  end

  def down do
    alter table(:tbl_trans_log) do
      remove :journalentry_filename, :string
    end
  end
end
