defmodule LoanSavingsSystem.Charges.Charge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_charge" do
    field :chargeAmount, :float
    field :chargeWhen, :string
    field :chargeName, :string
    field :chargeType, :string
    field :clientId, :integer
    field :currency, :string
    field :currencyId, :integer
    field :isPenalty, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(charge, attrs) do
    charge
    |> cast(attrs, [:chargeName, :chargeWhen, :currency, :currencyId, :isPenalty, :clientId, :chargeType, :chargeAmount])
    |> validate_required([:chargeName, :chargeWhen, :currency, :currencyId, :isPenalty, :clientId, :chargeType, :chargeAmount])
  end
end
