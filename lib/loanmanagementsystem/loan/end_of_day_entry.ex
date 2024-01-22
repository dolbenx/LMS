defmodule Loanmanagementsystem.Loan.End_of_day_entry do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tbl_end_of_day_entries" do
    field :accrual_end_date, :utc_datetime
    field :accrual_period, :integer
    field :accrual_start_date, :utc_datetime
    field :charges_incurred, :float
    field :currencyId, :integer
    field :currencyName, :string
    field :end_of_day_date, :utc_datetime
    field :end_of_day_id, :integer
    field :interest_accrued, :float
    field :loan_id, :integer
    field :penalties_incurred, :float
    field :principal_amount, :float
    field :status, :string
    field :finance_cost_accrued, :float
    field :eod_ref_no, :string

    timestamps()
  end

  @doc false
  def changeset(end_of_day_entry, attrs) do
    end_of_day_entry
    |> cast(attrs, [:eod_ref_no, :finance_cost_accrued, :currencyId, :currencyName, :end_of_day_date, :end_of_day_id, :interest_accrued, :penalties_incurred, :charges_incurred, :status, :loan_id, :accrual_start_date, :accrual_end_date, :accrual_period, :principal_amount])
    # |> validate_required([:currencyId, :currencyName, :end_of_day_date, :end_of_day_id, :interest_accrued, :penalties_incurred, :charges_incurred, :status, :loan_id, :accrual_start_date, :accrual_end_date, :accrual_period, :principal_amount])
  end
end
