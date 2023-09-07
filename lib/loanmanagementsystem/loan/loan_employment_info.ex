defmodule Loanmanagementsystem.Loan.Loan_employment_info do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_loan_employment_info" do
    field :accrued_gratuity, :string
    field :address, :string
    field :applicant_name, :string
    field :authorised_signature, :string
    field :company_name, :string
    field :contact_no, :string
    field :customer_id, :integer
    field :date, :string
    field :date_to, :string
    field :employer, :string
    field :employer_email_address, :string
    field :employer_phone, :string
    field :employment_date, :string
    field :employment_status, :string
    field :granted_loan_amt, :string
    field :gross_salary, :string
    field :job_title, :string
    field :net_salary, :string
    field :other_outstanding_loans, :string
    field :province, :string
    field :reference_no, :string
    field :supervisor_name, :string
    field :town, :string

    timestamps()
  end

  @doc false
  def changeset(loan_employment_info, attrs) do
    loan_employment_info
    |> cast(attrs, [:customer_id, :reference_no, :employer, :address, :employment_status, :town, :employer_email_address, :employer_phone, :supervisor_name, :province, :employment_date, :date_to, :applicant_name, :company_name, :granted_loan_amt, :gross_salary, :net_salary, :other_outstanding_loans, :accrued_gratuity, :contact_no, :authorised_signature, :job_title, :date])
    # |> validate_required([:customer_id, :reference_no, :employer, :address, :employment_status, :town, :employer_email_address, :employer_phone, :supervisor_name, :province, :employment_date, :date_to, :applicant_name, :company_name, :granted_loan_amt, :gross_salary, :net_salary, :other_outstanding_loans, :accrued_gratuity, :contact_no, :authorised_signature, :job_title, :date])
  end
end
