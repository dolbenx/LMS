defmodule LoanSavingsSystem.Client.Clients do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_clients" do
    field :accountCreationEndpoint, :string
    field :balanceEnquiryEndpoint, :string
    field :bankId, :integer
    field :clientName, :string
    field :countryId, :integer
    field :defaultCurrencyDecimals, :integer
    field :defaultCurrencyId, :integer
    field :defaultCurrencyName, :string
    field :fundsTransferEndpoint, :string
    field :isBank, :boolean, default: false
    field :isDomicileAccountAtBank, :boolean, default: false
    field :status, :string
    field :ussdCode, :string
    field :contact_email, :string
    field :contact_url, :string

    timestamps()
  end

  @doc false
  def changeset(clients, attrs) do
    clients
    |> cast(attrs, [:contact_email, :contact_url, :ussdCode, :bankId, :isBank, :isDomicileAccountAtBank, :countryId, :accountCreationEndpoint, :balanceEnquiryEndpoint, :fundsTransferEndpoint, :defaultCurrencyId, :defaultCurrencyName, :status, :defaultCurrencyDecimals, :clientName])
    |> validate_required([:ussdCode, :bankId, :isBank, :isDomicileAccountAtBank, :countryId, :accountCreationEndpoint, :balanceEnquiryEndpoint, :fundsTransferEndpoint, :defaultCurrencyId, :defaultCurrencyName, :status, :defaultCurrencyDecimals, :clientName])
  end
end
