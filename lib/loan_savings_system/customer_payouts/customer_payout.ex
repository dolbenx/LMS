defmodule LoanSavingsSystem.CustomerPayouts.CustomerPayout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_customerpayouts" do
    field :amount, :float
    field :fixedDepositId, :integer
    field :orderRef, :string
    field :payoutRequest, :string
    field :payoutResponse, :string
    field :payoutType, :string
    field :status, :string
    field :transactionDate, :date
    field :transactionId, :integer
    field :userId, :integer

    timestamps()
  end

  @doc false
  def changeset(customer_payout, attrs) do
    customer_payout
    |> cast(attrs, [:fixedDepositId, :orderRef, :status, :amount, :transactionId, :userId, :payoutType, :transactionDate, :payoutRequest, :payoutResponse])
    |> validate_required([:fixedDepositId, :orderRef, :status, :amount, :transactionId, :userId, :payoutType, :transactionDate, :payoutRequest, :payoutResponse])
  end
end
