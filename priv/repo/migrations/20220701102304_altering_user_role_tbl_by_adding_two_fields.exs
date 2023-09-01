defmodule Loanmanagementsystem.Repo.Migrations.AlteringUserRoleTblByAddingTwoFields do
  use Ecto.Migration

  def up do
    alter table(:tbl_user_roles) do
      add :isStaff, :boolean
    end
  end

  def down do
    alter table(:tbl_user_roles) do
      remove :isStaff
    end
  end
end
