defmodule Loanmanagementsystem.Repo.Migrations.CreateTblAccountsMgt do
  use Ecto.Migration

  def change do
    create table(:tbl_accounts_mgt) do
      add :account_no, :string
      add :account_name, :string
      add :type, :string
      add :status, :string

      timestamps()
    end

  end
end
