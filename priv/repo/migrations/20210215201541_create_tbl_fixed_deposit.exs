defmodule LoanSavingsSystem.Repo.Migrations.CreateTblFixedDeposit do
  use Ecto.Migration

  def change do
    create table(:tbl_fixed_deposit) do
      add :accountId, :integer
      add :productId, :integer
      add :principalAmount, :float
      add :fixedPeriod, :integer
      add :fixedPeriodType, :string
      add :interestRate, :float
      add :interestRateType, :string
      add :expectedInterest, :float
      add :accruedInterest, :float
      add :isMatured, :boolean, default: false, null: false
      add :isDivested, :boolean, default: false, null: false
      add :divestmentPackageId, :integer
      add :currencyId, :integer
      add :currency, :string
      add :currencyDecimals, :integer
      add :yearLengthInDays, :integer
      add :totalDepositCharge, :float
      add :totalWithdrawalCharge, :float
      add :totalPenalties, :float
      add :userRoleId, :integer
      add :userId, :integer
      add :totalAmountPaidOut, :float
      add :startDate, :utc_datetime
      add :endDate, :utc_datetime
      add :clientId, :integer
      add :divestmentId, :integer
      add :branchId, :integer
	  add :productInterestMode, :string
      add :divestedInterestRate, :float
      add :divestedInterestRateType, :string
      add :amountDivested, :float
      add :divestedInterestAmount, :float
      add :divestedPeriod, :integer
      add :fixedDepositStatus, :string
      add :lastEndOfDayDate, :utc_datetime
      add :isWithdrawn, :boolean
	  add :customerName, :string
	  add :autoCreditOnMaturityDone, :boolean
	  add :autoCreditOnMaturity, :boolean
	  add :autoRollOverAmount, :float
	  
      timestamps()
    end

  end
end
