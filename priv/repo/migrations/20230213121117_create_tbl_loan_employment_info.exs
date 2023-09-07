defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanEmploymentInfo do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_employment_info) do
      add :customer_id, :integer
      add :reference_no, :string
      add :employer, :string
      add :address, :string
      add :employment_status, :string
      add :town, :string
      add :employer_email_address, :string
      add :employer_phone, :string
      add :job_title, :string
      add :supervisor_name, :string
      add :province, :string
      add :employment_date, :string
      add :date_to, :string
      add :applicant_name, :string
      add :company_name, :string
      add :granted_loan_amt, :string
      add :gross_salary, :string
      add :net_salary, :string
      add :other_outstanding_loans, :string
      add :accrued_gratuity, :string
      add :contact_no, :string
      add :authorised_signature, :text
      add :date, :string

      timestamps()
    end

  end
end
