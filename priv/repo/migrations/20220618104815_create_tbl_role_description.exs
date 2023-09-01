defmodule Loanmanagementsystem.Repo.Migrations.CreateTblRoleDescription do
  use Ecto.Migration

  def change do
    create table(:tbl_role_description) do
      add :role_description, :string
      add :status, :string
      add :user_Id, :integer

      timestamps()
    end
  end
end
