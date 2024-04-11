defmodule Loanmanagementsystem.Charges.Charge do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_charges" do
    field :chargeAmount, :float
    field :chargeName, :string
    field :chargeType, :string
    field :chargeWhen, :string
    field :currency, :string
    field :currencyId, :integer
    field :isPenalty, :boolean, default: false

    field :code, :string
    field :accountToCredit, :string
    field :effectiveDate, :date

    timestamps()
  end

  @doc false
  def changeset(charge, attrs) do
    charge
    |> cast(attrs, [
      :chargeAmount,
      :chargeWhen,
      :chargeName,
      :chargeType,
      :currency,
      :currencyId,
      :isPenalty,

      :code,
      :accountToCredit,
      :effectiveDate
    ])
    |> validate_required([
      :chargeAmount,
      :chargeWhen,
      :chargeName,
      :chargeType,
      :currency,
      :currencyId,
      :isPenalty,

      :code,
      :accountToCredit,
      :effectiveDate
    ])
  end
end
