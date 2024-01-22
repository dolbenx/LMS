defmodule LoanSavingsSystem.Repo.Migrations.CreateTblSecurityQuestions do
  use Ecto.Migration

  def change do
    create table(:tbl_security_questions) do
      add :question, :string
      add :status, :string

      timestamps()
    end

  end
end
