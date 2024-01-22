defmodule LoanSavingsSystem.Repo.Migrations.CreateTblAccount do
  use Ecto.Migration

  def change do
    create table(:tbl_account) do
      add :accountOfficerId, :integer
      add :deactivatedReason, :string
      add :blockedReason, :string
      add :clientId, :integer
      add :accountNo, :string
      add :externalId, :string
      add :productId, :integer
      add :accountType, :string
      add :DateClosed, :date
      add :currencyId, :integer
      add :currencyDecimals, :integer
      add :currencyName, :string
      add :totalDeposits, :float
      add :totalWithdrawals, :float
      add :totalCharges, :float
      add :totalPenalties, :float
      add :totalInterestEarned, :float
      add :totalInterestPosted, :float
      add :totalTax, :float
      add :accountVersion, :float
      add :derivedAccountBalance, :float
      add :userId, :integer
      add :blockedByUserId, :integer
      add :status, :string
      add :userRoleId, :integer
      add :branchId, :integer
      timestamps()
    end

  end
end
