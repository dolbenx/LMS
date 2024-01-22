defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanCreditScore do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_credit_score) do
      add :customer_id, :integer
      add :loan_id, :integer
      add :reference_no, :string
      add :applicant_name, :string
      add :type_of_loan, :string
      add :loan_amount, :float
      add :cro_staff, :string
      add :date_of_credit_score, :date
      add :weighted_credit_score, :float
      add :business_employment_experience, :string
      add :family_situation, :string
      add :borrowing_history, :string
      add :dti_ratio, :string
      add :collateral_assessment, :string
      add :type_of_collateral, :string
      add :applicant_character, :string
      add :number_of_reference, :string
      add :total_score, :float
      add :credit_analyst, :string
      add :signature, :text

      timestamps()
    end

  end
end
