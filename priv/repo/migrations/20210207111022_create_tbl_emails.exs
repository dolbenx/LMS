defmodule LoanSavingsSystem.Repo.Migrations.CreateTblEmails do
  use Ecto.Migration

  def change do
    create table(:tbl_emails) do
      add :first_name, :string
      add :last_name, :string
      add :type, :string
      add :email, :string
      add :msg_count, :string
      add :status, :string
      add :msg, :string
      add :date_sent, :naive_datetime
      add :title, :string

      timestamps()
    end

  end
end
