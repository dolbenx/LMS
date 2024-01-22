defmodule LoanSystem.Repo.Migrations.CreateTblUserRole do
  use Ecto.Migration

  def change do
    create table(:tbl_user_role) do
      add :created_by, :string
      add :role_description, :string
      add :role_name, :string
      add :user_id, :string

      timestamps()
    end

  end
end
