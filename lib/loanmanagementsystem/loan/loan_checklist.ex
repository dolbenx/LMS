defmodule Loanmanagementsystem.Loan.Loan_checklist do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_loan_checklist" do
    field :gross_monthly_income, :string
    field :prood_of_resident, :string
    field :home_visit_done, :string
    field :latest_pacra_print_out, :string
    field :desired_term, :string
    field :company_bank_statement, :string
    field :bank_name, :string
    field :trading_license, :string
    field :id_no, :string
    field :collateral_pictures, :string
    field :employer_name, :string
    field :loan_amount_checklist, :string
    field :telephone, :string
    field :contract_agreements, :string
    field :reference_no, :string
    field :customer_id, :integer
    field :correct_account_number, :string
    field :payslip_3months_verified, :string
    field :latest_audited_financial_statement, :string
    field :call_memo, :string
    field :marital_status, :string
    field :loan_id, :integer
    field :citizenship_status, :string
    field :employment_status, :string
    field :has_running_loan, :string
    field :loan_purpose_checklist, :string
    field :completed_application_form, :string
    field :preferred_loan_repayment_method, :string
    field :certificate_of_incorporation, :string
    field :passport_size_photo, :string
    field :passport_size_photo_from_director, :string
    field :rent_payment, :string
    field :sales_record, :string
    field :board_allow_company_to_borrow, :string
    field :employer_letter, :string
    field :crb, :string
    field :loan_verified, :string
    field :bank_standing_payment_order, :string
    field :email_address, :string
    field :social_security_no, :string
    field :insurance_for_motor_vehicle, :string
    field :bank_statement, :string

    field :completed_approved_application, :string
    field :valid_id, :string
    field :trading_license_or_other, :string
    field :three_months_sale, :string
    field :moveable_or_immovable_collateral, :string
    field :motor_vehicle_insurance, :string
    field :crb_report, :string
    field :proof_of_residence, :string
    field :reference_letter, :string
    field :three_months_pay_slip, :string
    field :incorporation_doc, :string
    field :tax_clearance, :string
    field :rep_valid_id, :string
    field :tenancy_agreement, :string
    field :board_resolution, :string
    field :six_month_statement, :string

    timestamps()
  end

  @doc false
  def changeset(loan_checklist, attrs) do
    loan_checklist
    |> cast(attrs, [
    :completed_approved_application, :valid_id, :trading_license_or_other,
    :three_months_sale, :moveable_or_immovable_collateral, :motor_vehicle_insurance,
    :crb_report, :proof_of_residence, :reference_letter, :three_months_pay_slip,
    :incorporation_doc, :tax_clearance, :rep_valid_id, :tenancy_agreement,
    :customer_id, :loan_id, :reference_no, :social_security_no, :board_resolution,
    :passport_size_photo, :id_no, :citizenship_status, :marital_status, :email_address,
    :telephone, :prood_of_resident, :employment_status, :payslip_3months_verified,
    :employer_name, :gross_monthly_income, :rent_payment, :employer_letter, :has_running_loan,
    :completed_application_form, :crb, :loan_purpose_checklist, :call_memo, :desired_term,
    :loan_amount_checklist, :sales_record, :collateral_pictures, :insurance_for_motor_vehicle,
    :loan_verified, :home_visit_done, :bank_statement, :bank_name, :correct_account_number,
    :bank_standing_payment_order, :preferred_loan_repayment_method, :trading_license,
    :certificate_of_incorporation, :latest_pacra_print_out, :passport_size_photo_from_director,
    :latest_audited_financial_statement, :contract_agreements, :company_bank_statement,
    :board_allow_company_to_borrow, :six_month_statement,
    ])
    # |> validate_required([:customer_id, :loan_id, :reference_no, :social_security_no, :passport_size_photo, :id_no, :citizenship_status, :marital_status, :email_address, :telephone, :prood_of_resident, :employment_status, :payslip_3months_verified, :employer_name, :gross_monthly_income, :rent_payment, :employer_letter, :has_running_loan, :completed_application_form, :crb, :loan_purpose_checklist, :call_memo, :desired_term, :loan_amount_checklist, :sales_record, :collateral_pictures, :insurance_for_motor_vehicle, :loan_verified, :home_visit_done, :bank_statement, :bank_name, :correct_account_number, :bank_standing_payment_order, :preferred_loan_repayment_method, :trading_license, :certificate_of_incorporation, :latest_pacra_print_out, :passport_size_photo_from_director, :latest_audited_financial_statement, :contract_agreements, :company_bank_statement, :board_allow_company_to_borrow])
  end
end
