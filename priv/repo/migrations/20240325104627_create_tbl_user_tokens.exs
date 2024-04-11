defmodule Loanmanagementsystem.Repo.Migrations.CreateTblUserTokens do
  use Ecto.Migration

  def change do
    create table(:tbl_user_tokens) do
      add :user_id, references(:tbl_users, on_delete: :delete_all), null: false
      add :token, :binary
      add :context, :string
      add :sent_to, :string
      add :login_timestamp, :naive_datetime

      timestamps()
    end

    create index(:tbl_user_tokens, [:user_id])
    create unique_index(:tbl_user_tokens, [:context, :token])
  end
end
