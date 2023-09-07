defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanDisbursement do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_disbursement) do
      add :loan_product, :string
      add :currency, :string
      add :amount, :float
      add :disbursement_dt, :string
      add :mode_of_disbursement, :string
      add :comp_mno_type, :string
      add :comp_mobile_no, :string
      add :comp_bank_name, :string
      add :comp_bank_account_no, :string
      add :comp_swift_code, :string
      add :comp_account_name, :string
      add :comp_expiry_month, :string
      add :comp_expiry_year, :string
      add :comp_cvv, :string
      add :customer_mno_type, :string
      add :customer_mno_mobile_no, :string
      add :customer_bank_name, :string
      add :customer_bank_account_no, :string
      add :customer_swift_code, :string
      add :customer_account_name, :string
      add :customer_expiry_month, :string
      add :customer_expiry_year, :string
      add :customer_cvv, :string
      add :maker_id, :integer
      add :customer_id, :integer
      add :loan_id, :integer
      add :product_id, :integer
      add :status, :string
      add :narration, :string

      timestamps()
    end
  end
end
