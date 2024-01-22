defmodule LoanSavingsSystem.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_products" do
    field :clientId, :integer
    field :code, :string
    field :currencyDecimals, :integer
    field :currencyId, :integer
    field :currencyName, :string
    field :defaultPeriod, :integer
    field :details, :string
    field :interest, :float
    field :interestMode, :string
    field :interestType, :string
    field :maximumPrincipal, :float
    field :minimumPrincipal, :float
    field :name, :string
    field :periodType, :string
    field :productType, :string
    field :status, :string
    field :yearLengthInDays, :integer
    field :minimumPeriod, :integer
    field :maximumPeriod, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :code, :minimumPeriod, :maximumPeriod, :details, :currencyId, :currencyName, :currencyDecimals, :interest, :interestType, :interestMode, :defaultPeriod, :periodType, :productType, :minimumPrincipal, :maximumPrincipal, :clientId, :yearLengthInDays, :status])
    # |> validate_required([:name, :code, :details, :currencyId, :currencyName, :currencyDecimals, :interest, :interestType, :interestMode, :defaultPeriod, :periodType, :productType, :minimumPrincipal, :maximumPrincipal, :clientId, :yearLengthInDays, :status])
  end
end
