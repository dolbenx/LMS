defmodule Loanmanagementsystem.Repo.Migrations.AlterDisbursementTblAddNetDisbursementAmt do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_payment_requisition) do
      add :net_disbursed_amount, :float
    end
  end
end
