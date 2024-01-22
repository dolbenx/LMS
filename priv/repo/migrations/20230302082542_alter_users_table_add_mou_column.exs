defmodule Loanmanagementsystem.Repo.Migrations.AlterUsersTableAddMouColumn do
  use Ecto.Migration

  def change do
    alter table(:tbl_users) do
      add :with_mou, :boolean, default: false, null: false
    end
  end
end
