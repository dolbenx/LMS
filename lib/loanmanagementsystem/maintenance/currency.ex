defmodule Loanmanagementsystem.Maintenance.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_currency" do
    field :acronym, :string
    field :approved_by, :integer
    field :country_id, :integer
    field :created_by, :integer
    field :currency_decimal, :integer
    field :iso_code, :string
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name, :acronym, :country_id, :iso_code, :currency_decimal, :status, :approved_by, :created_by])
    |> validate_required([:name, :acronym, :country_id, :iso_code, :currency_decimal, :status, :created_by])
  end
end
