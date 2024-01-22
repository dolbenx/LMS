defmodule Loanmanagementsystem.Loan.Loan_amortization_schedule do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_loan_amortization_schedule" do
    field :beginning_balance, :float
    field :customer_id, :integer
    field :ending_balance, :float
    field :interest, :float
    field :interest_rate, :float
    field :loan_amount, :float
    field :loan_id, :integer
    field :month, :integer
    field :payment, :float
    field :principal, :float
    field :reference_no, :string
    field :term_in_months, :float
    field :date, :date
    field :calculation_date, :date



    timestamps()
  end

  @doc false
  def changeset(loan_amortization_schedule, attrs) do
    loan_amortization_schedule
    |> cast(attrs, [:date, :calculation_date, :customer_id, :loan_id, :reference_no, :loan_amount, :interest_rate, :term_in_months, :month, :beginning_balance, :payment, :interest, :principal, :ending_balance])
    |> validate_required([:customer_id, :loan_id, :reference_no, :loan_amount, :interest_rate, :term_in_months, :month, :beginning_balance, :payment, :interest, :principal, :ending_balance])
  end
end
