defmodule LoanSavingsSystem.Products.ProductCharge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_product_charge" do
    field :chargeId, :integer
    field :productId, :integer
    field :chargeWhen, :string

    timestamps()
  end

  @doc false
  def changeset(product_charge, attrs) do
    product_charge
    |> cast(attrs, [:productId, :chargeId, :chargeWhen])
    |> validate_required([:productId, :chargeId, :chargeWhen])
  end
end
