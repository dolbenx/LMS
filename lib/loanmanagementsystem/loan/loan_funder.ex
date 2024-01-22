defmodule Loanmanagementsystem.Loan.Loan_funder do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_loan_funder" do
    field :funderID, :integer
    field :totalAmountFunded, :float, default: 0.0
    field :totalbalance, :float, default: 0.0
    field :totalinterest_accumulated, :float, default: 0.0
    field :status, :string
    field :payment_mode, :string
    field :funder_type, :string
    field :is_company , :boolean




    timestamps()
  end

  @doc false
  def changeset(loan_funder, attrs) do
    loan_funder
    |> cast(attrs, [:is_company, :totalbalance, :totalinterest_accumulated, :funderID, :totalAmountFunded, :status, :payment_mode, :funder_type])
    # |> validate_required([:Totalbalance, :Totalinterest, :accumulated, :funderID, :TotalAmountFunded, :status])
  end
end
