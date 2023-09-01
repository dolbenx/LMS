defmodule Loanmanagementsystem.Repo.Migrations.CreateTblPasswordMaintenance do
  use Ecto.Migration

  def change do
    create table(:tbl_password_maintenance) do
      add :user_id, :integer
      add :password_format, :string
      add :min_length, :string
      add :max_length, :string

      timestamps()
    end
  end
end
