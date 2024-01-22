defmodule Loanmanagementsystem.Loan.Loan_funder do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_loan_funder" do
    field :funderID, :integer
    field :totalAmountFunded, :float, default: 0.0
    field :totalbalance, :float, default: 0.0
    field :totalinterest_accumulated, :float, default: 0.0
    field :status, :string
    field :payment_mode, :string
    field :funder_type, :string




    timestamps()
  end

  @doc false
  def changeset(loan_funder, attrs) do
    loan_funder
    |> cast(attrs, [:totalbalance, :totalinterest_accumulated, :funderID, :totalAmountFunded, :status, :payment_mode, :funder_type])
    # |> validate_required([:Totalbalance, :Totalinterest, :accumulated, :funderID, :TotalAmountFunded, :status])
  end
end
