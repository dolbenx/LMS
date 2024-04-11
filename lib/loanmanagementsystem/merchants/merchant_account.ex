defmodule Loanmanagementsystem.Merchants.Merchant_account do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_merchant_account" do
    field(:balance, :float, default: 0.0)
    field :merchant_id, :integer
    field :merchant_number, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(merchant_account, attrs) do
    merchant_account
    |> cast(attrs, [:merchant_id, :merchant_number, :balance, :status])
    |> validate_required([:merchant_id, :merchant_number, :balance, :status])
  end
end
