defmodule Savings.Repo.Migrations.CreateTblUsers do
  use Ecto.Migration

  def change do
    create table(:tbl_users) do
      add :username, :string
      add :password, :string
      add :clientId, :integer
      add :createdByUserId, :integer
      add :status, :string
      add :canOperate, :boolean
      add :ussdActive, :integer
      add :pin, :string
      add :auto_password, :string
      add :password_fail_count, :integer
      add :securityQuestionId, :integer
      add :securityQuestionAnswer, :string
      add :security_question_fail_count, :integer
      add :role_id, :integer
      add :login_attempt, :integer
      add :remote_ip, :string
      add :last_login_dt, :naive_datetime
      timestamps()
    end
  end
end
