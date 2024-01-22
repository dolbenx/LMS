defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanClientIncomeAssessment do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_client_income_assessment) do
      add :customer_id, :integer
      add :reference_no, :string
      add :business_type, :string
      add :jan, :string
      add :jan_bank_stat, :float
      add :jan_mobile_stat, :float
      add :jan_total, :float
      add :dec, :string
      add :dec_bank_stat, :float
      add :dec_mobile_stat, :float
      add :dec_total, :float
      add :nov, :string
      add :nov_bank_stat, :float
      add :nov_mobile_stat, :float
      add :nov_total, :float
      add :average_income, :float
      add :dstv, :float
      add :food, :float
      add :school, :float
      add :utilities, :float
      add :loan_installment, :float
      add :salaries, :float
      add :stationery, :float
      add :transport, :float
      add :total_expenses, :float
      add :available_income, :float
      add :loan_installment_total, :float
      add :dsr, :float

      timestamps()
    end

  end
end
