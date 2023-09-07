defmodule Loanmanagementsystem.Repo.Migrations.CreateTblBatchNumber do
  use Ecto.Migration

  def change do
    create table(:tbl_batch_number) do
      add :batch_no, :string
      add :trans_date, :string
      add :value_date, :string
      add :current_user, :string
      add :last_user, :string
      add :batch_type, :string
      add :status, :string
      add :uuid, :string
      add :last_user_id, references(:tbl_users, column: :id, on_delete: :nilify_all)
      add :current_user_id, references(:tbl_users, column: :id)

      timestamps()
    end
  end
end
