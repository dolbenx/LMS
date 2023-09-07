defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCustomerAccounts do
  use Ecto.Migration

  def change do
    create table(:tbl_customer_accounts) do
      add :user_id, :integer
      add :account_number, :string
      add :status, :string
      add :loan_officer_id, :integer

      timestamps()
    end
  end
end
