defmodule Loanmanagementsystem.Repo.Migrations.CreateTblUsers do
  use Ecto.Migration

  def change do
    create table(:tbl_users) do
      add :username, :string
      add :password, :string
      add :status, :string
      add :pin, :string
      add :password_fail_count, :integer
      add :auto_password, :string
      add :external_id, :integer
      add :classification_id, :integer
      add :is_rm, :boolean, default: false, null: false
      add :is_employee, :boolean, default: false, null: false
      add :is_employer, :boolean, default: false, null: false
      add :is_sme, :boolean, default: false, null: false
      add :is_admin, :boolean, default: false, null: false
      add :is_offtaker, :boolean, default: false, null: false
      add :role_id, :integer

      timestamps()
    end
    create unique_index(:tbl_users, [:username], name: :unique_username)
  end

end
