defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCustomerBalance do
  use Ecto.Migration

  def change do
    create table(:tbl_customer_balance) do
      add :account_number, :string
      add :balance, :float
      add :user_id, :integer

      timestamps()
    end

    create unique_index(:tbl_customer_balance, [:account_number], name: :unique_account_number)
  end
end
