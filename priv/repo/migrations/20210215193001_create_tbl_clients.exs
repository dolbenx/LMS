defmodule LoanSavingsSystem.Repo.Migrations.CreateTblClients do
  use Ecto.Migration

  def change do
    create table(:tbl_clients) do
      add :ussdCode, :string
      add :bankId, :integer
      add :isBank, :boolean, default: false, null: false
      add :isDomicileAccountAtBank, :boolean, default: false, null: false
      add :countryId, :integer
      add :accountCreationEndpoint, :string
      add :balanceEnquiryEndpoint, :string
      add :fundsTransferEndpoint, :string
      add :defaultCurrencyId, :integer
      add :defaultCurrencyName, :string
      add :status, :string
      add :defaultCurrencyDecimals, :integer
      add :clientName, :string
      add :contact_email, :string
      add :contact_url, :string

      timestamps()
    end

  end
end
