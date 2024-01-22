defmodule LoanSavingsSystem.SystemSetting.District do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_district" do
    field :countryId, :integer
    field :countryName, :string
    field :name, :string
    field :provinceId, :integer
    field :provinceName, :string

    timestamps()
  end

  @doc false
  def changeset(district, attrs) do
    district
    |> cast(attrs, [:name, :countryId, :countryName, :provinceId, :provinceName])
    |> validate_required([:name, :countryId, :countryName, :provinceId, :provinceName])
  end
end
