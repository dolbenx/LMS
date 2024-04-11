defmodule Loanmanagementsystem.Maintenance.Holiday_mgt do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_holiday_maintenance" do
    field :holiday_date, :date
    field :holiday_description, :string
    field :month, :string
    field :year, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(holiday_mgt, attrs) do
    holiday_mgt
    |> cast(attrs, [:year, :month, :holiday_date, :holiday_description, :status])
    |> validate_required([:year, :month, :holiday_date, :holiday_description])
  end
end
