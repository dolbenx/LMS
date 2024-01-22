defmodule LoanSavingsSystem.Repo.Migrations.ModifyRolestrTblRoles do
  use Ecto.Migration

      def up do
        alter table(:tbl_roles) do
          remove :role_str
          add :role_str, :map
        end
      end

  def down do
    alter table(:tbl_roles) do
      remove :role_str
    end
  end

end
