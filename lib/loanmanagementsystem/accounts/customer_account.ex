defmodule Loanmanagementsystem.Accounts.Customer_account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_customer_accounts" do
    field(:account_number, :string)
    field(:status, :string)
    field(:user_id, :integer)
    field(:loan_officer_id, :integer)
    field :previous_Rm, :integer
    field :assignment_date, :date



    timestamps()
  end

  @doc false
  def changeset(customer_account, attrs) do
    customer_account
    |> cast(attrs, [:previous_Rm,:assignment_date,:user_id, :account_number, :status, :loan_officer_id])

    # |> validate_required([:user_id, :account_number, :status])
  end
end
