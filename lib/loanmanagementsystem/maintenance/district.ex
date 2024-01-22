defmodule Loanmanagementsystem.Maintenance.District do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

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
