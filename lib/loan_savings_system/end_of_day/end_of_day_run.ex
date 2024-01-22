defmodule LoanSavingsSystem.EndOfDay.EndOfDayRun do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_end_of_day" do
    field :currencyId, :integer
    field :currencyName, :string
    field :date_ran, :utc_datetime
    field :end_date, :utc_datetime
    field :end_of_day_type, :string
    field :penalties_incurred, :float
    field :start_date, :utc_datetime
    field :status, :string
    field :total_interest_accrued, :float
    field :total_principal_deposited, :float
    field :total_charge_deposit, :float
    field :divestment_principal_total, :float
    field :divestment_interest_total, :float
	field :withdrawals_principal_total, :float
	field :withdrawals_interest_total, :float

    timestamps()
  end

  @doc false
  def changeset(end_of_day_run, attrs) do
    end_of_day_run
    |> cast(attrs, [:withdrawals_interest_total, :withdrawals_principal_total, :divestment_principal_total, :divestment_interest_total, :date_ran, :total_interest_accrued, :penalties_incurred, :end_of_day_type, :start_date, :end_date, :status, :currencyId, :currencyName, :total_principal_deposited, :total_charge_deposit])
    |> validate_required([:divestment_principal_total, :divestment_interest_total, :date_ran, :total_interest_accrued, :penalties_incurred, :end_of_day_type, :start_date, :end_date, :status, :currencyId, :currencyName, :total_principal_deposited, :total_charge_deposit])
  end

  @doc false
  def changesetForUpdate(end_of_day_run, attrs) do
    end_of_day_run
    |> cast(attrs, [:withdrawals_interest_total, :withdrawals_principal_total, :divestment_principal_total, :divestment_interest_total, :date_ran, :total_interest_accrued, :penalties_incurred, :end_of_day_type, :start_date, :end_date, :status, :currencyId, :currencyName, :total_principal_deposited, :total_charge_deposit])
  end
end
