defmodule LoanSystem.Repo.Migrations.CreateTblMnos do
  use Ecto.Migration

  def change do
    create table(:tbl_mnos) do
      add :name, :string
      add :code, :string
      add :url, :string
      add :username, :string
      add :password, :string

      timestamps()
    end

  end
end
