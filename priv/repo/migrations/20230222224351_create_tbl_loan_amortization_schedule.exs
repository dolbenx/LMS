defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanAmortizationSchedule do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_amortization_schedule) do
      add :customer_id, :integer
      add :reference_no, :string
      add :loan_id, :integer
      add :loan_amount, :float
      add :interest_rate, :float
      add :term_in_months, :float
      add :month, :integer
      add :beginning_balance, :float
      add :payment, :float
      add :interest, :float
      add :principal, :float
      add :ending_balance, :float

      timestamps()
    end

  end
end
