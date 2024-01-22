defmodule Loanmanagementsystem.Companies.Employee_account do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_employee_account" do
    field(:balance, :float, default: 0.0)
    field :employee_id, :integer
    field :employee_number, :string
    field :limit, :float
    field :status, :string
    field(:limit_balance, :float, default: 0.0)

    timestamps()
  end

  @doc false
  def changeset(employee_account, attrs) do
    employee_account
    |> cast(attrs, [:employee_id, :employee_number, :balance, :status, :limit, :limit_balance])
    |> validate_required([:employee_id, :employee_number, :balance, :status, :limit, :limit_balance])
  end
end
