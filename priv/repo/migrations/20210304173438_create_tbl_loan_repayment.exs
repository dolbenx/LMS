defmodule LoanSavingsSystem.Repo.Migrations.CreateTblLoanRepayment do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_repayment) do
      add :repaymentNo, :string
      add :dateOfRepayment, :string
      add :modeOfRepayment, :string
      add :amountRepaid, :float
      add :chequeNo, :string
      add :receiptNo, :string
      add :registeredByUserId, :integer
      add :recipientUserRoleId, :integer

      timestamps()
    end

  end
end
