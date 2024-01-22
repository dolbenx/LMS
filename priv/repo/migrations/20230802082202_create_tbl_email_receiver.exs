defmodule Loanmanagementsystem.Repo.Migrations.CreateTblEmailReceiver do
  use Ecto.Migration

  def change do
    create table(:tbl_email_receiver) do
      add :email, :string
      add :status, :string
      add :name, :string

      timestamps()
    end

  end
end
