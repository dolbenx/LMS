defmodule Loanmanagementsystem.Maintenance.District do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
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
    |> cast(attrs, [:countryId, :countryName, :name, :provinceId, :provinceName])
    |> validate_required([:countryId, :countryName, :provinceId, :name, :provinceName])
  end
end
