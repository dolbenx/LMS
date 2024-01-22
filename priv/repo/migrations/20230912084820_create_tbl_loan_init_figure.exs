defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanInitFigure do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_init_figure) do
      add :loan_id, :integer
      add :status, :string
      add :init_interest_accrued, :float
      add :init_finance_cost_accrued, :float
      add :init_principal_amount, :float
      add :init_repaid_amount, :float
      add :balance, :float
      add :init_arrangement_fee, :float
      add :init_expected_repayment, :float
      add :product_type, :string

      timestamps()
    end

  end
end
