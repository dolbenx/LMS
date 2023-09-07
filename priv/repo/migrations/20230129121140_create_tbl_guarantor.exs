defmodule Loanmanagementsystem.Repo.Migrations.CreateTblGuarantor do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_guarantor) do
      add :cost_of_sales, :float
      add :occupation, :string
      add :customer_id, :integer
      add :email, :string
      add :employer, :string
      add :gaurantor_sign_date, :date
      add :gaurantor_signature, :text
      add :guarantor_name, :string
      add :guarantor_phone_no, :string
      add :loan_applicant_name, :string
      add :name_of_cro_staff, :string
      add :name_of_witness, :string
      add :guarantor_witness_signature, :text
      add :witness_sign_date, :date
      add :net_profit_loss, :float
      add :nrc, :string
      add :other_expenses, :float
      add :other_income_bills, :float
      add :relationship, :string
      add :salary_loan, :float
      add :sale_business_rentals, :float
      add :staff_sign_date, :date
      add :staff_signature, :text
      add :total_income_expense, :float
      add :reference_no, :string


      timestamps()
    end

  end
end
