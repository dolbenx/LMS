defmodule Loanmanagementsystem.Loan.Bulk_loan_init_figures do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_init_figure" do
    field :balance, :float
    field :init_arrangement_fee, :float
    field :init_expected_repayment, :float
    field :init_finance_cost_accrued, :float
    field :init_interest_accrued, :float
    field :init_principal_amount, :float
    field :init_repaid_amount, :float
    field :loan_id, :integer
    field :product_type, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(bulk_loan_init_figures, attrs) do
    bulk_loan_init_figures
    |> cast(attrs, [:loan_id, :status, :init_interest_accrued, :init_finance_cost_accrued, :init_principal_amount, :init_repaid_amount, :balance, :init_arrangement_fee, :init_expected_repayment, :product_type])
    |> validate_required([:loan_id, :status, :init_interest_accrued, :init_finance_cost_accrued, :init_principal_amount, :init_repaid_amount, :balance, :init_arrangement_fee, :init_expected_repayment, :product_type])
  end
end
