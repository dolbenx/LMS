defmodule Loanmanagementsystem.Loan.Customer_loan_application do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_customer_loan_application" do
    field :customer_id, :integer
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :loan_amount, :float
    field :loan_period, :float
    field :pay_monthly, :float
    field :phone, :string
    field :product, :string
    field :product_id, :integer
    field :product_interet_rate, :float
    field :status, :string
    field :total_interest, :float
    field :total_pay_back, :float

    timestamps()
  end

  @doc false
  def changeset(customer_loan_application, attrs) do
    customer_loan_application
    |> cast(attrs, [:customer_id, :first_name, :last_name, :phone, :email, :loan_amount, :loan_period, :product, :product_interet_rate, :product_id, :pay_monthly, :total_interest, :total_pay_back, :status])
    # |> validate_required([:customer_id, :first_name, :last_name, :phone, :email, :loan_amount, :loan_period, :product, :product_interet_rate, :product_id, :pay_monthly, :total_interest, :total_pay_back, :status])
  end
end
