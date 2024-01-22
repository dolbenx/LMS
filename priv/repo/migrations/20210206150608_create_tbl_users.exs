defmodule LoanSavingsSystem.Repo.Migrations.CreateTblUsers do
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


      timestamps()
    end

  end
end
