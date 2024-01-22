defmodule LoanSystem.Repo.Migrations.CreateLoanproducts do
  use Ecto.Migration

  def change do
    create table(:loanproducts) do
      add :short_code, :string
      add :name, :string
      add :currency_code, :string
      add :min_principal_amount, :float
      add :max_principal_amount, :float
      add :arrearstolerance_amount, :float
      add :description, :string
      add :min_nominal_interest_rate_per_period, :float
      add :max_nominal_interest_rate_per_period, :float
      add :min_loan_period, :integer
      add :max_loan_period, :integer
      add :interest_method_type, :string
      add :min_number_of_repayments, :integer
      add :max_number_of_repayments, :integer
      add :start_date, :date
      add :close_date, :date
      add :days_in_month, :integer
      add :days_in_year, :integer
      add :external_id, :string
      add :overdue_days_for_npa, :integer
      add :max_outstanding_loan_balance, :float
      add :status, :string
      add :require_collateral, :boolean, default: false, null: false

      timestamps()
    end

  end
end
