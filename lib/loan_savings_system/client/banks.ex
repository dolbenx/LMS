defmodule LoanSavingsSystem.Client.Banks do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_banks" do
    field :eod_url, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(banks, attrs) do
    banks
    |> cast(attrs, [:name, :eod_url])
    |> validate_required([:name, :eod_url])
  end
end
