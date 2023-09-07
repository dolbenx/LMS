defmodule Loanmanagementsystem.Repo.Migrations.AlterTransLogAddAccountCategory do
  use Ecto.Migration

  def change do
    alter table(:tbl_trans_log) do
      add :account_category, :string
    end
  end
end
