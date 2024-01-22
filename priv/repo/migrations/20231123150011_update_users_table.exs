defmodule Loanmanagementsystem.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def up do
    alter table(:tbl_users) do
      add :remote_ip, :string
      add :last_login_dt, :date
    end
  end

  def down do
    alter table(:tbl_users) do
      remove :remote_ip
      remove :last_login_dt

    end
  end
end
