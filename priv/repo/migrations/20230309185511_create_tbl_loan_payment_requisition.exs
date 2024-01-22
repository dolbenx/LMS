defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanPaymentRequisition do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_payment_requisition) do
      add :customer_id, :integer
      add :loan_id, :integer
      add :reference_no, :string
      add :payable_to, :string
      add :address_or_designation, :string
      add :amount_requested, :float
      add :amount_paid, :float
      add :loan_purpose, :string
      add :requested_by, :string
      add :checked_by, :string
      add :approved_by, :string
      add :gl_account, :string
      add :date_paid, :date
      add :requested_by_position, :string
      add :checked_by_position, :string
      add :approved_by_position, :string
      add :cheque_no, :string

      timestamps()
    end

  end
end
