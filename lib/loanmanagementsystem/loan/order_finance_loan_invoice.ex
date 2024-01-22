defmodule Loanmanagementsystem.Loan.Order_finance_loan_invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_order_finace_loan_invoice" do
    field :customer_id, :integer
    field :item_description, :string
    field :loan_id, :integer
    field :order_date, :date
    field :order_number, :string
    field :order_value, :float
    field :status, :string
    field :tenor, :integer
    field :expected_due_date, :date

    timestamps()
  end

  @doc false
  def changeset(order_finance_loan_invoice, attrs) do
    order_finance_loan_invoice
    |> cast(attrs, [:item_description, :order_value, :order_number, :tenor, :status, :loan_id, :order_date, :customer_id, :expected_due_date])
    # |> validate_required([:item_description, :order_value, :order_number, :tenor, :status, :loan_id, :order_date, :customer_id, :expected_due_date])
  end
end
