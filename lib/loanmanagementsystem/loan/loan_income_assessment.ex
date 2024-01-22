defmodule Loanmanagementsystem.Loan.Loan_income_assessment do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_loan_client_income_assessment" do
    field :customer_id, :integer
    field :reference_no, :string
    field :business_type, :string
    field :jan, :string
    field :jan_bank_stat, :float
    field :jan_mobile_stat, :float
    field :jan_total, :float
    field :dec, :string
    field :dec_bank_stat, :float
    field :dec_mobile_stat, :float
    field :dec_total, :float
    field :nov, :string
    field :nov_bank_stat, :float
    field :nov_mobile_stat, :float
    field :nov_total, :float
    field :average_income, :float
    field :dstv, :float
    field :food, :float
    field :school, :float
    field :utilities, :float
    field :loan_installment, :float
    field :salaries, :float
    field :stationery, :float
    field :transport, :float
    field :total_expenses, :float
    field :available_income, :float
    field :loan_installment_total, :float
    field :dsr, :float

    timestamps()
  end

  @doc false
  def changeset(loan_income_assessment, attrs) do
    loan_income_assessment
    |> cast(attrs, [:customer_id, :reference_no, :business_type, :jan, :jan_bank_stat, :jan_mobile_stat, :jan_total, :dec, :dec_bank_stat, :dec_mobile_stat, :dec_total, :nov, :nov_bank_stat, :nov_mobile_stat, :nov_total, :average_income, :dstv, :food, :school, :utilities, :loan_installment, :salaries, :stationery, :transport, :total_expenses, :available_income, :loan_installment_total, :dsr])
    # |> validate_required([:customer_id, :reference_no, :business_type, :jan, :jan_total, :dec, :dec_total, :nov, :nov_total, :average_income, :dstv, :food, :school, :utilities, :loan_installment, :salaries, :stationery, :transport, :total_expenses, :available_income, :loan_installment_total, :dsr])
  end
end
