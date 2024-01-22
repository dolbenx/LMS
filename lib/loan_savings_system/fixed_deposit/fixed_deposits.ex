defmodule LoanSavingsSystem.FixedDeposit.FixedDeposits do
  @derive {Jason.Encoder, only: [:accountId, :branchId, :productId, :principalAmount, :fixedPeriod, :fixedPeriodType, :interestRate, :interestRateType, :expectedInterest, :accruedInterest, :isMatured, :isDivested, :divestmentPackageId, :currencyId, :currency, :currencyDecimals, :yearLengthInDays, :totalDepositCharge, :totalWithdrawalCharge, :totalPenalties, :userRoleId, :userId, :totalAmountPaidOut, :startDate, :endDate, :clientId, :divestmentId, :productInterestMode]}


  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_fixed_deposit" do
    field :accountId, :integer
    field :accruedInterest, :float
    field :clientId, :integer
    field :currency, :string
    field :currencyDecimals, :integer
    field :currencyId, :integer
    field :divestmentId, :integer
    field :divestmentPackageId, :integer
    field :endDate, :utc_datetime
    field :expectedInterest, :float
    field :fixedPeriod, :integer
    field :fixedPeriodType, :string
    field :interestRate, :float
    field :interestRateType, :string
    field :isDivested, :boolean, default: false
    field :isMatured, :boolean, default: false
    field :isWithdrawn, :boolean, default: false
    field :principalAmount, :float
    field :productId, :integer
    field :startDate, :utc_datetime
    field :totalAmountPaidOut, :float
    field :totalDepositCharge, :float
    field :totalPenalties, :float
    field :totalWithdrawalCharge, :float
    field :userId, :integer
    field :userRoleId, :integer
    field :yearLengthInDays, :integer
    field :branchId, :integer
	field :productInterestMode, :string
    field :divestedInterestRate, :float
    field :divestedInterestRateType, :string
    field :amountDivested, :float
    field :divestedInterestAmount, :float
    field :divestedPeriod, :integer
    field :fixedDepositStatus, :string
    field :lastEndOfDayDate, :utc_datetime
	field :customerName, :string
	field :autoCreditOnMaturityDone, :boolean
	field :autoCreditOnMaturity, :boolean
	field :autoRollOverAmount, :float



    timestamps()
  end

  @doc false
  def changeset(fixed_deposits, attrs) do
    fixed_deposits
    |> cast(attrs, [:autoCreditOnMaturityDone, :autoCreditOnMaturity, :autoRollOverAmount, :customerName, :isWithdrawn , :lastEndOfDayDate, :fixedDepositStatus, :accountId, :branchId, :productId, :principalAmount, :fixedPeriod, :fixedPeriodType, :interestRate, :interestRateType, :expectedInterest, :accruedInterest, :isMatured, :isDivested, :divestmentPackageId, :currencyId, :currency, :currencyDecimals, :yearLengthInDays, :totalDepositCharge, :totalWithdrawalCharge, :totalPenalties, :userRoleId, :userId, :totalAmountPaidOut, :startDate, :endDate, :clientId, :divestmentId, :productInterestMode, :divestedInterestRate, :divestedInterestRateType, :amountDivested, :divestedInterestAmount, :divestedPeriod])
    |> validate_required([:accountId, :productId, :principalAmount, :fixedPeriod, :fixedPeriodType, :interestRate, :interestRateType, :expectedInterest, :accruedInterest, :isMatured, :isDivested, :currencyId, :currency, :currencyDecimals, :yearLengthInDays, :totalDepositCharge, :totalWithdrawalCharge, :totalPenalties, :userRoleId, :userId, :totalAmountPaidOut, :startDate, :endDate, :clientId, :productInterestMode])
  end
  
  @doc false
  def changesetForUpdate(fixed_deposits, attrs) do
    fixed_deposits
    |> cast(attrs, [:autoCreditOnMaturityDone, :autoCreditOnMaturity, :autoRollOverAmount, :customerName, :isWithdrawn , :lastEndOfDayDate, :fixedDepositStatus, :accountId, :branchId, :productId, :principalAmount, :fixedPeriod, :fixedPeriodType, :interestRate, :interestRateType, :expectedInterest, :accruedInterest, :isMatured, :isDivested, :divestmentPackageId, :currencyId, :currency, :currencyDecimals, :yearLengthInDays, :totalDepositCharge, :totalWithdrawalCharge, :totalPenalties, :userRoleId, :userId, :totalAmountPaidOut, :startDate, :endDate, :clientId, :divestmentId, :productInterestMode, :divestedInterestRate, :divestedInterestRateType, :amountDivested, :divestedInterestAmount, :divestedPeriod])
  end
end
