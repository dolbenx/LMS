defmodule Savings.Products.ProductsPeriod do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_product_period" do
    field :periodDays, :string
    field :periodType, :string
    field :productID, :integer
    field :status, :string
    field :defaultPeriod, :integer
    field :interest, :float
    field :interestType, :string
    field :yearLengthInDays, :integer

    timestamps()
  end

  @doc false
  def changeset(products_period, attrs) do
    products_period
    |> cast(attrs, [:productID, :periodDays, :periodType, :status, :interest, :interestType, :defaultPeriod, :yearLengthInDays])
    # |> validate_required([:productID, :periodDays, :periodType, :status, :interest, :interestType, :defaultPeriod, :yearLengthInDays])
  end
end
