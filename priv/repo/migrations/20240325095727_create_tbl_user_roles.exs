defmodule Loanmanagementsystem.Repo.Migrations.CreateTblUserRoles do
  use Ecto.Migration

  def change do
    create table(:tbl_user_roles) do
      add :role_type, :string
      add :status, :string
      add :user_id, :integer
      add :session, :string
      add :permissions, :string
      add :auth_level, :integer

      timestamps()
    end
  end
end
