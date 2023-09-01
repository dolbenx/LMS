defmodule Loanmanagementsystem.Repo.Migrations.CreateTblAccount do
  use Ecto.Migration

  def change do
    create table(:tbl_account) do
      add :clientId, :integer
      add :accountNo, :string
      add :userId, :integer
      add :status, :string
      add :mobile_number, :string
      add :userRoleId, :integer
      add :branchId, :integer
      add :accountType, :string
      add :pin, :string
      add :password_fail_count, :integer
      add :securityQuestionAnswer, :string
      add :securityQuestionAnswerId, :integer
      add :security_question_fail_count, :integer
      add :permissions, :string
      add :telegram_id, :string

      timestamps()
    end
  end
end
