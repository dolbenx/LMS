defmodule LoanSavingsSystem.Repo.Migrations.CreateTblJournalEntry do
  use Ecto.Migration

  def change do
    create table(:tbl_journal_entry) do
      add :accountId, :integer
      add :userRoleId, :integer
      add :userId, :integer
      add :productType, :string
      add :isReversed, :boolean, default: false, null: false
      add :transactionId, :integer
      add :reversedTransactionId, :integer
      add :isSystemEntry, :boolean, default: false, null: false
      add :currency, :string
      add :currencyId, :integer
      add :amount, :float
      add :entryDate, :naive_datetime
      add :clientId, :integer
      add :crGLAccountId, :integer
      add :drGLAccountId, :integer

      timestamps()
    end

  end
end
