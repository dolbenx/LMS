defmodule Loanmanagementsystem.Repo.Migrations.ModifyRoleDescription do
  use Ecto.Migration

  def up do
    alter table(:tbl_role_description) do
      add :role_id, :integer
    end
  end

  def down do
    alter table(:tbl_role_description) do
      remove :role_id
    end
  end
end
