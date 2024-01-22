defmodule Savings.Repo.Migrations.ModifyTransactions do
  use Ecto.Migration

  def change do
    alter table(:tbl_transactions) do
      modify :requestData, :text
      modify :responseData, :text
    end
  end
end
