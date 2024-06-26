defmodule Loanmanagementsystem.Repo.Migrations.CreateTblRoles do
  use Ecto.Migration

  def change do
    create table(:tbl_roles) do
      add :role_desc, :string
      add :role_group, :string
      add :role_str, :map
      add :status, :string

      timestamps()
    end
  end
end
