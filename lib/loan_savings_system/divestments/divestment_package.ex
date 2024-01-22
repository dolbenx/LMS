defmodule LoanSavingsSystem.Divestments.DivestmentPackage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_divestment_package" do
    field :clientId, :integer
    field :divestmentValuation, :float
    field :endPeriodDays, :integer
    field :productId, :integer
    field :startPeriodDays, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(divestment_package, attrs) do
    divestment_package
    |> cast(attrs, [:startPeriodDays, :endPeriodDays, :divestmentValuation, :productId, :status, :clientId])
    |> validate_required([:startPeriodDays, :endPeriodDays, :divestmentValuation, :productId, :status, :clientId])
  end
end
