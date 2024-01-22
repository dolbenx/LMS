defmodule Loanmanagementsystem.Charges.Product_charges do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_product_charges" do
    field :charge_id, :integer
    field :product_id, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(product_charges, attrs) do
    product_charges
    |> cast(attrs, [:product_id, :charge_id, :status])
    # |> validate_required([:product_id, :charge_id, :status])
  end
end
