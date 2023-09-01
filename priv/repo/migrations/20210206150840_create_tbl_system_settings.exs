defmodule Loanmanagementsystem.Repo.Migrations.CreateTblSystemSettings do
  use Ecto.Migration

  def change do
    create table(:tbl_system_settings) do
      add :username, :string
      add :password, :string
      add :host, :string
      add :sender, :string
      add :max_attempts, :string

      timestamps()
    end
  end
end
