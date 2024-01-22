defmodule LoanSavingsSystem.SystemSetting.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_currency" do
    field :countryId, :integer
    field :isoCode, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name, :isoCode, :countryId])
    |> validate_required([:name, :isoCode, :countryId])
  end
end
