defmodule Loanmanagementsystem.Repo.Migrations.CreateTblMerchantAccount do
  use Ecto.Migration

  def change do
    create table(:tbl_merchant_account) do
      add :merchant_id, :integer
      add :merchant_number, :string
      add :balance, :float
      add :status, :string

      timestamps()
    end

  end
end
