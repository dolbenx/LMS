defmodule Loanmanagementsystem.Products.Product do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tbl_products" do
    field(:clientId, :integer)
    field(:code, :string)
    field(:currencyDecimals, :integer)
    field(:currencyId, :integer)
    field(:currencyName, :string)
    field(:defaultPeriod, :integer)
    field(:details, :string)
    field(:interest, :float)
    field(:interestMode, :string)
    field(:interestType, :string)
    field(:maximumPrincipal, :float)
    field(:minimumPrincipal, :float)
    field(:name, :string)
    field(:periodType, :string)
    field(:productType, :string)
    field(:status, :string)
    field(:yearLengthInDays, :integer)
    field(:principle_account_id, :integer)
    field(:interest_account_id, :integer)
    field(:charges_account_id, :integer)
    field(:classification_id, :integer)
    field(:charge_id, :map)
    field(:reference_id, :integer)
    field(:reason, :string)
    field :insurance, :float
    field :proccessing_fee, :float
    field :crb_fee, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :charge_id,
      :reference_id,
      :reason,
      :insurance,
      :proccessing_fee,
      :crb_fee,
      :classification_id,
      :charges_account_id,
      :interest_account_id,
      :principle_account_id,
      :name,
      :code,
      :details,
      :currencyId,
      :currencyName,
      :currencyDecimals,
      :interest,
      :interestType,
      :interestMode,
      :defaultPeriod,
      :periodType,
      :productType,
      :minimumPrincipal,
      :maximumPrincipal,
      :clientId,
      :yearLengthInDays,
      :status
    ])
    |> unique_constraint(:tbl_products_pkey, name: :name)

    # |> validate_required([
    #   :classification_id,
    #   :charges_account_id,
    #   :interest_account_id,
    #   :principle_account_id,
    #   :name,
    #   :code,
    #   :details,
    #   :currencyId,
    #   :currencyName,
    #   :currencyDecimals,
    #   :interest,
    #   :interestMode,
    #   :defaultPeriod,
    #   :productType,
    #   :minimumPrincipal,
    #   :maximumPrincipal,
    #   :clientId,
    #   :yearLengthInDays,
    #   :status
    # ])
  end
end
