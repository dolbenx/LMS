defmodule LoanSavingsSystem.Repo.Migrations.AlterTblUsersAndAddRoleId do
  use Ecto.Migration

  def up do
    alter table(:tbl_users) do
      add :role_id, :integer
    end
  end

  def down do
    alter table(:tbl_users) do
      remove :role_id
    end
  end
end
