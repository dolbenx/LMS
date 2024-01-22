defmodule LoanSystem.Repo.Migrations.CreateTblOldPassword do
  use Ecto.Migration

  def change do
    create table(:tbl_old_password) do
      add :date_created, :string
      add :email, :string
      add :password, :string
      add :user_id, :integer

      timestamps()
    end

  end
end
