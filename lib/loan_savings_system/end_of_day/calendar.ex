defmodule LoanSavingsSystem.EndOfDay.Calendar do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calendars" do
    field :createdby_id, :integer
    field :end_date, :date
    field :name, :string
    field :start_date, :date

    timestamps()
  end

  @doc false
  def changeset(calendar, attrs) do
    calendar
    |> cast(attrs, [:name, :start_date, :end_date, :createdby_id])
    |> validate_required([:name, :start_date, :end_date, :createdby_id])
  end
end
