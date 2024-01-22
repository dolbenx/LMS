defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanChecklist do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_checklist) do
      add :customer_id, :integer
      add :loan_id, :integer
      add :reference_no, :string
      add :social_security_no, :string
      add :passport_size_photo, :string
      add :id_no, :string
      add :citizenship_status, :string
      add :marital_status, :string
      add :email_address, :string
      add :telephone, :string
      add :prood_of_resident, :string
      add :employment_status, :string
      add :payslip_3months_verified, :string
      add :employer_name, :string
      add :gross_monthly_income, :string
      add :rent_payment, :string
      add :employer_letter, :string
      add :has_running_loan, :string
      add :completed_application_form, :string
      add :crb, :string
      add :loan_purpose_checklist, :string
      add :call_memo, :string
      add :desired_term, :string
      add :loan_amount_checklist, :string
      add :sales_record, :string
      add :collateral_pictures, :string
      add :insurance_for_motor_vehicle, :string
      add :loan_verified, :string
      add :home_visit_done, :string
      add :bank_statement, :string
      add :bank_name, :string
      add :correct_account_number, :string
      add :bank_standing_payment_order, :string
      add :preferred_loan_repayment_method, :string
      add :trading_license, :string
      add :certificate_of_incorporation, :string
      add :latest_pacra_print_out, :string
      add :passport_size_photo_from_director, :string
      add :latest_audited_financial_statement, :string
      add :contract_agreements, :string
      add :company_bank_statement, :string
      add :board_allow_company_to_borrow, :string

      timestamps()
    end

  end
end
