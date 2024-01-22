defmodule LoanSystem.Repo.Migrations.CreateTblUserLogs do
  use Ecto.Migration

  def change do
    create table(:tbl_user_logs) do
      add :activity, :string
      add :user_id, :integer

      timestamps()
    end

  end
end
