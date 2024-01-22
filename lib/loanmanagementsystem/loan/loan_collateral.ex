defmodule Loanmanagementsystem.Loan.LoanCollateral do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_loan_collateral" do
    field :collateral_type, :string
    field :description, :string
    field :loan_id, :integer
    field :valuation, :float

    timestamps()
  end

  @doc false
  def changeset(loan_collateral, attrs) do
    loan_collateral
    |> cast(attrs, [:loan_id, :collateral_type, :valuation, :description])
    |> validate_required([:loan_id, :collateral_type, :valuation, :description])
  end
end
