defmodule Loanmanagementsystem.Repo.Migrations.AlterTransLogAddClosingBalance do
  use Ecto.Migration

  def change do
    alter table(:tbl_trans_log) do
      add :closing_balance, :float
    end
  end
end
