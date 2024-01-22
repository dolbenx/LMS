defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanDisbursementSchedule do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_disbursement_schedule) do
      add :customer_id, :integer
      add :reference_no, :string
      add :applicant_name, :string
      add :applied_amount, :float
      add :approved_amount, :float
      add :processing_fee, :float
      add :insurance, :float
      add :crb, :float
      add :motor_insurance, :float
      add :net_disbiursed, :float
      add :interet_per_month, :float
      add :repayment_period, :string
      add :month_installment, :float
      add :date, :date
      add :prepared_by, :string
      add :senior_operation_officer, :string
      add :credit_manager, :string
      add :finance_manager, :string
      add :account_number, :string
      add :bank_name, :string
      add :branch, :string
      add :loan_id, :integer
      add :applicant_signature, :text

      timestamps()
    end

  end
end
