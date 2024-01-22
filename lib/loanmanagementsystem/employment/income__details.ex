defmodule Loanmanagementsystem.Employment.Income_Details do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_income_details" do
    field :gross_pay, :float
    field :net_pay, :float
    field :pay_day, :string
    field :total_deductions, :float
    field :total_expenses, :float
    field :upload_payslip, :string
    field :userId, :integer

    timestamps()
  end

  @doc false
  def changeset(income__details, attrs) do
    income__details
    |> cast(attrs, [
      :pay_day,
      :gross_pay,
      :total_deductions,
      :net_pay,
      :total_expenses,
      :upload_payslip,
      :userId
    ])
    |> validate_required([
      :pay_day,
      :gross_pay,
      # :total_deductions,
      :net_pay,
      # :total_expenses,
      :userId
    ])
  end
end
