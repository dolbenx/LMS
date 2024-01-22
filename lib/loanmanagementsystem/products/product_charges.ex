defmodule Loanmanagementsystem.Products.Product_charges do
  use Ecto.Schema
  import Ecto.Changeset

  schema "product_id" do
    field :charge_id, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(product_charges, attrs) do
    product_charges
    |> cast(attrs, [:charge_id, :status])
    # |> validate_required([:charge_id, :status])
  end
end
