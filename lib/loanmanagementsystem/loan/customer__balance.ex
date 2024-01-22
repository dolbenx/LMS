defmodule Loanmanagementsystem.Loan.Customer_Balance do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_customer_balance" do
    field :account_number, :string
    field :balance, :float, default: 0.0
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(customer__balance, attrs) do
    customer__balance
    |> cast(attrs, [:account_number, :balance, :user_id])
    |> validate_required([:account_number, :balance, :user_id])
  end
end
