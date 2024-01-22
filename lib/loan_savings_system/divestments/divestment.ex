defmodule LoanSavingsSystem.Divestments.Divestment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_divestments" do
    field :clientId, :integer
    field :divestAmount, :float
    field :divestmentDate, :date
    field :divestmentDayCount, :integer
    field :divestmentValuation, :float
    field :fixedDepositId, :integer
    field :fixedPeriod, :integer
    field :interestAccrued, :float
    field :interestRate, :float
    field :interestRateType, :string
    field :principalAmount, :float
    field :userId, :integer
    field :userRoleId, :integer
    field :divestmentType, :string
    field :customerName, :string
    field :currencyDecimals, :integer
    field :currency, :string


    timestamps()
  end

  @doc false
  def changeset(divestment, attrs) do
    divestment
    |> cast(attrs, [:currencyDecimals, :currency, :customerName, :divestmentType, :fixedDepositId, :principalAmount, :fixedPeriod, :interestRate, :interestRateType, :divestmentDate, :divestmentDayCount, :divestmentValuation, :divestAmount, :clientId, :interestAccrued, :userId, :userRoleId])
    |> validate_required([:fixedDepositId, :principalAmount, :fixedPeriod, :interestRate, :interestRateType, :divestmentDate, :divestmentDayCount, :divestmentValuation, :divestAmount, :clientId, :interestAccrued, :userId, :userRoleId])
  end
end
