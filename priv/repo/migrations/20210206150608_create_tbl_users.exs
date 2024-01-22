defmodule LoanSavingsSystem.Repo.Migrations.CreateTblUsers do
  use Ecto.Migration

  def change do
    create table(:tbl_users) do
      add :username, :string
      add :password, :string
      add :status, :string
      add :pin, :string
      add :auto_password, :string
      add :password_fail_count, :integer
      add :company_id, :integer
      add :classification_id, :integer
      add :login_attempt, :integer
      add(:role_id, :integer)

      timestamps()
    end

    create unique_index(:tbl_users, [:username], name: :unique_username)
  end
end
