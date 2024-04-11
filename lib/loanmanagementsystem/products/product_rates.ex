defmodule Loanmanagementsystem.Products.Product_rates do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_product_rates" do
    field :interest_rates, :float
    field :processing_fee, :float
    field :product_id, :integer
    field :product_name, :string
    field :repayment, :string
    field :status, :string
    field :tenor, :integer

    timestamps()
  end

  @doc false
  def changeset(product_rates, attrs) do
    product_rates
    |> cast(attrs, [
      :product_id,
      :product_name,
      :tenor,
      :repayment,
      :interest_rates,
      :processing_fee,
      :status
    ])
    |> validate_required([
      :product_id,
      :product_name,
      :tenor,
      :repayment,
      :interest_rates,
      :processing_fee,
      :status
    ])
  end
end
