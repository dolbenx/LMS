defmodule LoanSavingsSystem.Repo.Migrations.CreateTblUserRoles do
  use Ecto.Migration

  def change do
    create table(:tbl_user_roles) do
      add :userId, :integer
      add :roleType, :string
      add :status, :string
      add :otp, :string
      add :studentID, :string
      add :studentLevel, :string
      add :session, :string
      add :permissions, :string
      add :auth_level, :integer

      timestamps()
    end
  end
end
