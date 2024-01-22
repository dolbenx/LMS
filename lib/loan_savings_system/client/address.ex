defmodule LoanSavingsSystem.Client.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_addresses" do
    field :addressLine1, :string
    field :addressLine2, :string
    field :city, :string
    field :clientId, :integer
    field :countryId, :integer
    field :countryName, :string
    field :districtId, :integer
    field :districtName, :string
    field :isCurrent, :boolean, default: false
    field :provinceId, :integer
    field :provinceName, :string
    field :userId, :integer

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:addressLine1, :addressLine2, :city, :districtId, :districtName, :provinceId, :provinceName, :countryId, :countryName, :isCurrent, :userId, :clientId])
    |> validate_required([:addressLine1, :addressLine2, :city, :districtId, :districtName, :provinceId, :provinceName, :countryId, :countryName, :isCurrent, :userId, :clientId])
  end
end
