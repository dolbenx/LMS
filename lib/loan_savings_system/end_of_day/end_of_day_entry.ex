defmodule LoanSavingsSystem.EndOfDay.EndOfDayEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_end_of_day_entries" do
    field :currencyId, :integer
    field :currencyName, :string
    field :end_of_day_date, :utc_datetime
    field :end_of_day_id, :integer
    field :interest_accrued, :float
    field :penalties_incurred, :float
    field :status, :string
	field :fixed_deposit_id, :integer
	field :accrual_start_date, :utc_datetime
	field :accrual_end_date, :utc_datetime
	field :accrual_period, :integer

    timestamps()
  end

  @doc false
  def changeset(end_of_day_entry, attrs) do
    end_of_day_entry
    |> cast(attrs, [:accrual_start_date, :accrual_end_date, :accrual_period, :end_of_day_id, :interest_accrued, :penalties_incurred, :end_of_day_date, :status, :currencyId, :currencyName, :fixed_deposit_id])
    |> validate_required([:accrual_start_date, :accrual_end_date, :accrual_period, :end_of_day_id, :interest_accrued, :penalties_incurred, :end_of_day_date, :status, :currencyId, :currencyName, :fixed_deposit_id])
  end
end
