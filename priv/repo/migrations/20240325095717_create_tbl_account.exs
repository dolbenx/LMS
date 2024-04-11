defmodule Loanmanagementsystem.Repo.Migrations.CreateTblAccount do
  use Ecto.Migration

  def change do
    create table(:tbl_account) do
      add :account_number, :string
      add :external_id, :integer
      add :status, :string
      add :user_id, :integer
      add :mobile_number, :string
      add :user_role_id, :integer
      add :account_type, :string
      add :available_balance, :float
      add :current_balance, :float
      add :total_debited, :float
      add :total_credited, :float
      add :limit, :float

      timestamps()
    end
  end
end
