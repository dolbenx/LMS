defmodule Loanmanagementsystem.Repo.Migrations.AlterUsersTable do
  use Ecto.Migration

  def up do
    alter table(:tbl_users) do
      add :upload_filename, :string
    end
  end

  def down do
    alter table(:tbl_users) do
      remove :upload_filename
    end
  end
end
