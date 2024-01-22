defmodule Loanmanagementsystem.Loan.Loan_disbursement_schedule do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tbl_loan_disbursement_schedule" do
    field :account_number, :string
    field :applicant_name, :string
    field :applicant_signature, :string
    field :applied_amount, :float
    field :approved_amount, :float
    field :bank_name, :string
    field :branch, :string
    field :crb, :float
    field :credit_manager, :string
    field :customer_id, :integer
    field :date, :date
    field :finance_manager, :string
    field :insurance, :float
    field :interet_per_month, :float
    field :loan_id, :integer
    field :month_installment, :float
    field :motor_insurance, :float
    field :net_disbiursed, :float
    field :prepared_by, :string
    field :processing_fee, :float
    field :reference_no, :string
    field :repayment_period, :string
    field :senior_operation_officer, :string
    field :account_name, :string
    field :swiftcode, :string
    field :mno_provider, :string
    field :mobile_number, :string

    timestamps()
  end

  @doc false
  def changeset(loan_disbursement_schedule, attrs) do
    loan_disbursement_schedule
    |> cast(attrs, [:customer_id, :account_name, :swiftcode, :mno_provider, :mobile_number, :reference_no, :applicant_name, :applied_amount, :approved_amount, :processing_fee, :insurance, :crb, :motor_insurance, :net_disbiursed, :interet_per_month, :repayment_period, :month_installment, :date, :prepared_by, :senior_operation_officer, :credit_manager, :finance_manager, :account_number, :bank_name, :branch, :loan_id, :applicant_signature])
    # |> validate_required([:customer_id, :reference_no, :applicant_name, :applied_amount, :approved_amount, :processing_fee, :insurance, :crb, :motor_insurance, :net_disbiursed, :interet_per_month, :repayment_period, :month_installment, :date, :prepared_by, :senior_operation_officer, :credit_manager, :finance_manager, :account_number, :bank_name, :branch, :loan_id, :applicant_signature])
  end
end
