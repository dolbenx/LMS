defmodule Loanmanagementsystem.Loan.Loan_applicant_guarantor do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_loan_guarantor" do
    field :cost_of_sales, :float
    field :occupation, :string
    field :customer_id, :integer
    field :email, :string
    field :employer, :string
    field :gaurantor_sign_date, :date
    field :gaurantor_signature, :string
    field :guarantor_name, :string
    field :guarantor_phone_no, :string
    field :loan_applicant_name, :string
    field :name_of_cro_staff, :string
    field :name_of_witness, :string
    field :guarantor_witness_signature, :string
    field :witness_sign_date, :date
    field :net_profit_loss, :float
    field :nrc, :string
    field :other_expenses, :float
    field :other_income_bills, :float
    field :relationship, :string
    field :salary_loan, :float
    field :sale_business_rentals, :float
    field :staff_sign_date, :date
    field :staff_signature, :string
    field :total_income_expense, :float
    field :reference_no, :string

    timestamps()
  end

  @doc false
  def changeset(loan_applicant_guarantor, attrs) do
    loan_applicant_guarantor
    |> cast(attrs, [:customer_id, :salary_loan, :other_income_bills, :sale_business_rentals, :cost_of_sales, :other_expenses, :total_income_expense, :net_profit_loss, :guarantor_name, :nrc, :loan_applicant_name, :relationship, :gaurantor_signature, :gaurantor_sign_date, :occupation, :employer, :guarantor_phone_no, :email, :name_of_witness, :name_of_cro_staff, :staff_signature, :staff_sign_date, :reference_no, :guarantor_witness_signature, :witness_sign_date])
    # |> validate_required([:customer_id, :salary_loan, :other_income_bills, :sale_business_rentals, :cost_of_sales, :other_expenses, :total_income_expense, :net_profit_loss, :guarantor_name, :nrc, :loan_applicant_name, :relationship, :gaurantor_signature, :gaurantor_sign_date, :occupation, :employer, :guarantor_phone_no, :email, :name_of_witness, :name_of_cro_staff, :staff_signature, :staff_sign_date])
  end
end
