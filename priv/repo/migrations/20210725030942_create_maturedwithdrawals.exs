defmodule LoanSavingsSystem.Repo.Migrations.CreateMaturedwithdrawals do
  use Ecto.Migration

  def change do
    create table(:maturedwithdrawals) do
      add :clientId, :integer
      add :amount, :float
      add :fixedDepositId, :integer
      add :fixedPeriod, :integer
      add :interestRate, :float
      add :interestRateType, :string
      add :principalAmount, :float
      add :interestAccrued, :float
      add :userId, :integer
      add :userRoleId, :integer
      add :transactionId, :integer

      timestamps()
    end

  end
end
