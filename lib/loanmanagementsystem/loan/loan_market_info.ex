defmodule Loanmanagementsystem.Loan.Loan_market_info do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_loan_market_info" do
    field :customer_id, :integer
    field :duration_at_market, :string
    field :location_of_market, :string
    field :mobile_of_market_leader, :string
    field :name_of_market, :string
    field :name_of_market_leader, :string
    field :name_of_market_vice, :string
    field :reference_no, :string
    field :type_of_business, :string
    field :mobile_of_market_vice , :string
    field :stand_number , :string

    timestamps()
  end

  @doc false
  def changeset(loan_market_info, attrs) do
    loan_market_info
    |> cast(attrs, [:customer_id, :reference_no, :name_of_market, :location_of_market, :duration_at_market, :type_of_business, :name_of_market_leader, :mobile_of_market_leader, :name_of_market_vice, :mobile_of_market_vice, :stand_number])
    # |> validate_required([:customer_id, :reference_no, :name_of_market, :location_of_market, :duration_at_market, :type_of_business, :name_of_market_leader, :mobile_of_market_leader, :name_of_market_vice])
  end
end
