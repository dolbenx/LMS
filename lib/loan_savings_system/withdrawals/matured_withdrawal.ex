defmodule LoanSavingsSystem.Withdrawals.MaturedWithdrawal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "maturedwithdrawals" do
    field :amount, :float
    field :clientId, :integer
    field :fixedDepositId, :integer
    field :fixedPeriod, :integer
    field :interestAccrued, :float
    field :interestRate, :float
    field :interestRateType, :string
    field :principalAmount, :float
    field :transactionId, :integer
    field :userId, :integer
    field :userRoleId, :integer

    timestamps()
  end

  @doc false
  def changeset(matured_withdrawal, attrs) do
    matured_withdrawal
    |> cast(attrs, [:clientId, :amount, :fixedDepositId, :fixedPeriod, :interestRate, :interestRateType, :principalAmount, :interestAccrued, :userId, :userRoleId, :transactionId])
    |> validate_required([:clientId, :amount, :fixedDepositId, :fixedPeriod, :interestRate, :interestRateType, :principalAmount, :interestAccrued, :userId, :userRoleId, :transactionId])
  end
end
