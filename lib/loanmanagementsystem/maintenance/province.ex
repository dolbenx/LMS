defmodule Loanmanagementsystem.Maintenance.Province do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_province" do
    field :countryId, :integer
    field :countryName, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(province, attrs) do
    province
    |> cast(attrs, [:countryId, :countryName, :name])
    |> validate_required([:countryId, :countryName, :name])
  end
end
