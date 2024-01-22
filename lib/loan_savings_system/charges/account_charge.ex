defmodule LoanSavingsSystem.Charges.AccountCharge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_account_charge" do
    field :accountId, :integer
    field :amountCharged, :float
    field :balance, :float
    field :chargeId, :integer
    field :dateCharged, :date
    field :datePaid, :date
    field :isPaid, :boolean, default: false
    field :userId, :integer
    field :fixedDepositId, :integer

    timestamps()
  end

  @doc false
  def changeset(account_charge, attrs) do
    account_charge
    |> cast(attrs, [:fixedDepositId, :accountId, :chargeId, :amountCharged, :isPaid, :dateCharged, :datePaid, :balance, :userId])
    |> validate_required([:accountId, :chargeId, :amountCharged, :isPaid, :dateCharged, :datePaid, :balance, :userId])
  end
end
