defmodule Loanmanagementsystem.Maintenance.Country do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_country" do
    field :country_file_name, :string
    field :name, :string
    field :code, :string
    field :currency_name, :string
    field :iso_code, :string
    field :currency_decimal, :integer

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name, :country_file_name, :code, :currency_decimal, :iso_code, :currency_name])
    |> validate_required([:name, :country_file_name, :code])
  end
end
