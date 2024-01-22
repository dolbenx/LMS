defmodule LoanSavingsSystem.EndOfDay.Holiday do
  use Ecto.Schema
  import Ecto.Changeset

  schema "holidays" do
    field :calendar_id, :integer
    field :from_date, :date
    field :maturity_payments_rescheduled_to, :date
    field :name, :string
    field :status, :string
    field :to_date, :date

    timestamps()
  end

  @doc false
  def changeset(holiday, attrs) do
    holiday
    |> cast(attrs, [:name, :from_date, :to_date, :maturity_payments_rescheduled_to, :status, :calendar_id])
    |> validate_required([:name, :from_date, :to_date, :maturity_payments_rescheduled_to, :status, :calendar_id])
  end
end
