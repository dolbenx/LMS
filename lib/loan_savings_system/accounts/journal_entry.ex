defmodule LoanSavingsSystem.Accounts.JournalEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_journal_entry" do
    field :accountId, :integer
    field :amount, :float
    field :clientId, :integer
    field :crGLAccountId, :integer
    field :currency, :string
    field :currencyId, :integer
    field :drGLAccountId, :integer
    field :entryDate, :naive_datetime
    field :isReversed, :boolean, default: false
    field :isSystemEntry, :boolean, default: false
    field :productType, :string
    field :reversedTransactionId, :integer
    field :transactionId, :integer
    field :userId, :integer
    field :userRoleId, :integer

    timestamps()
  end

  @doc false
  def changeset(journal_entry, attrs) do
    journal_entry
    |> cast(attrs, [:accountId, :userRoleId, :userId, :productType, :isReversed, :transactionId, :reversedTransactionId, :isSystemEntry, :currency, :currencyId, :amount, :entryDate, :clientId, :crGLAccountId, :drGLAccountId])
    |> validate_required([:accountId, :userRoleId, :userId, :productType, :isReversed, :transactionId, :reversedTransactionId, :isSystemEntry, :currency, :currencyId, :amount, :entryDate, :clientId, :crGLAccountId, :drGLAccountId])
  end
end
