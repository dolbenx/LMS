defmodule LoanSystem.Repo.Migrations.CreateTblEmailSender do
  use Ecto.Migration

  def change do
    create table(:tbl_email_sender) do
      add :email, :string
      add :status, :string
      add :password, :string


      timestamps()
    end

  end
end
