defmodule Loanmanagementsystem.Maintenance.Currency do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_currency" do
    field :countryId, :integer
    field :isoCode, :string
    field :name, :string
    field :currencyDecimal, :integer

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:currencyDecimal, :countryId, :isoCode, :name])
    |> validate_required([:currencyDecimal, :countryId, :isoCode, :name])
  end
end
