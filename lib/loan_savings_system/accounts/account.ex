defmodule LoanSavingsSystem.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_account" do
    field :DateClosed, :date
    field :accountNo, :string
    field :accountType, :string
    field :accountVersion, :float
    field :blockedByUserId, :integer
    field :blockedReason, :string
    field :clientId, :integer
    field :currencyDecimals, :integer
    field :currencyId, :integer
    field :currencyName, :string
    field :deactivatedReason, :string
    field :derivedAccountBalance, :float
    field :externalId, :string
    field :accountOfficerId, :integer
    field :status, :string
    field :totalCharges, :float
    field :totalDeposits, :float
    field :totalInterestEarned, :float
    field :totalInterestPosted, :float
    field :totalPenalties, :float
    field :totalTax, :float
    field :totalWithdrawals, :float
    field :userId, :integer
    field :userRoleId, :integer
    field :branchId, :integer

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:accountOfficerId, :branchId, :userRoleId, :deactivatedReason, :blockedReason, :clientId, :accountNo, :externalId, :accountType, :DateClosed, :currencyId, :currencyDecimals, :currencyName, :totalDeposits, :totalWithdrawals, :totalCharges, :totalPenalties, :totalInterestEarned, :totalInterestPosted, :totalTax, :accountVersion, :derivedAccountBalance, :userId, :blockedByUserId, :status])
    |> validate_required([:accountOfficerId, :branchId, :userRoleId, :deactivatedReason, :blockedReason, :clientId, :accountNo, :externalId, :accountType, :DateClosed, :currencyId, :currencyDecimals, :currencyName, :totalDeposits, :totalWithdrawals, :totalCharges, :totalPenalties, :totalInterestEarned, :totalInterestPosted, :totalTax, :accountVersion, :derivedAccountBalance, :userId, :blockedByUserId, :status])
  end




  @doc false
  def changesetForUpdate(account, attrs) do
    account
    |> cast(attrs, [:accountOfficerId, :deactivatedReason, :blockedReason, :clientId, :accountNo, :externalId, :accountType, :DateClosed, :currencyId, :currencyDecimals, :currencyName, :totalDeposits, :totalWithdrawals, :totalCharges, :totalPenalties, :totalInterestEarned, :totalInterestPosted, :totalTax, :accountVersion, :derivedAccountBalance, :userId, :blockedByUserId, :status, :userRoleId])
  end
end
