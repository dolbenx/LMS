defmodule LoanSavingsSystem.Repo.Migrations.CreateTblLoans do
  use Ecto.Migration

  def change do
    create table(:tbl_loans) do
      add :account_no, :string
      add :external_id, :string
      add :customer_id, :integer
      add :product_id, :integer
      add :loan_status, :string
      add :loan_type, :string
      add :currency_code, :string
      add :principal_amount_proposed, :float
      add :principal_amount, :float
      add :approved_principal, :float
      add :annual_nominal_interest_rate, :float
      add :interest_method, :string
      add :term_frequency, :integer
      add :term_frequency_type, :string
      add :repay_every, :integer
      add :repay_every_type, :string
      add :number_of_repayments, :integer
      add :approvedon_date, :date
      add :approvedon_userid, :integer
      add :expected_disbursedon_date, :date
      add :disbursedon_date, :date
      add :disbursedon_userid, :integer
      add :expected_maturity_date, :date
      add :interest_calculated_from_date, :date
      add :closedon_date, :date
      add :closedon_userid, :integer
      add :total_charges_due_at_disbursement_derived, :float
      add :principal_disbursed_derived, :float
      add :principal_repaid_derived, :float
      add :principal_writtenoff_derived, :float
      add :principal_outstanding_derived, :float
      add :interest_charged_derived, :float
      add :interest_repaid_derived, :float
      add :interest_waived_derived, :float
      add :interest_writtenoff_derived, :float
      add :interest_outstanding_derived, :float
      add :fee_charges_charged_derived, :float
      add :fee_charges_repaid_derived, :float
      add :fee_charges_waived_derived, :float
      add :fee_charges_writtenoff_derived, :float
      add :fee_charges_outstanding_derived, :float
      add :penalty_charges_charged_derived, :float
      add :penalty_charges_repaid_derived, :float
      add :penalty_charges_waived_derived, :float
      add :penalty_charges_writtenoff_derived, :float
      add :penalty_charges_outstanding_derived, :float
      add :total_expected_repayment_derived, :float
      add :total_repayment_derived, :float
      add :total_expected_costofloan_derived, :float
      add :total_costofloan_derived, :float
      add :total_waived_derived, :float
      add :total_writtenoff_derived, :float
      add :total_outstanding_derived, :float
      add :total_overpaid_derived, :float
      add :rejectedon_date, :date
      add :rejectedon_userid, :integer
      add :withdrawnon_date, :date
      add :withdrawnon_userid, :integer
      add :writtenoffon_date, :date
      add :loan_counter, :integer
      add :is_npa, :boolean, default: false, null: false
      add :is_legacyloan, :boolean, default: false, null: false
      add :branch_id, :integer
      add :branch_name, :string
      add :company_id, :integer
      add :actual_nominal_interest_rate, :float
      add :actual_nominal_interest_rate_type, :string
      add :loan_userroleid, :integer
      add :loan_userid, :integer
      add :year_length_in_days, :integer

      timestamps()
    end

  end
end
