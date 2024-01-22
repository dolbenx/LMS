defmodule Loanmanagementsystem.Loan.End_of_day do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tbl_end_of_day" do
    field :currencyId, :integer
    field :currencyName, :string
    field :date_ran, :utc_datetime
    field :end_date, :utc_datetime
    field :end_of_day_type, :string
    field :loan_id, :integer
    field :penalties_incurred, :float
    field :principal_amount, :float
    field :start_date, :utc_datetime
    field :status, :string
    field :total_interest_accrued, :float, default: 0.0
    field :eod_ref_no, :string

    timestamps()
  end

  @doc false
  def changeset(end_of_day, attrs) do
    end_of_day
    |> cast(attrs, [:eod_ref_no, :loan_id, :currencyId, :currencyName, :date_ran, :end_date, :end_of_day_type, :penalties_incurred, :start_date, :status, :total_interest_accrued, :principal_amount])
    # |> validate_required([:loan_id, :currencyId, :currencyName, :date_ran, :end_date, :end_of_day_type, :penalties_incurred, :start_date, :status, :total_interest_accrued, :principal_amount, :principal_amount])
  end
end
