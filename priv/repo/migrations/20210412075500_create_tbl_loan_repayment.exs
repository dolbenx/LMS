defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanRepayment do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_repayment) do
      add :repayment, :string
      add :dateOfRepayment, :string
      add :modeOfRepayment, :string
      add :amountRepaid, :float
      add :chequeNo, :string
      add :receiptNo, :string
      add :registeredByUserId, :integer
      add :recipientUserRoleId, :integer
      add :company_id, :integer

      timestamps()
    end

    create unique_index(:tbl_loan_repayment, [:receiptNo], name: :unique_receiptNo)
    create unique_index(:tbl_loan_repayment, [:chequeNo], name: :unique_chequeNo)
  end
end
