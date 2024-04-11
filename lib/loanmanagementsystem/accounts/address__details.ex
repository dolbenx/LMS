defmodule Loanmanagementsystem.Accounts.Address_Details do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_address_details" do
    field :accomodation_status, :string
    field :area, :string
    field :house_number, :string
    field :street_name, :string
    field :town, :string
    field :userId, :integer
    field :year_at_current_address, :integer
    field :province, :string

    timestamps()
  end

  @doc false
  def changeset(address__details, attrs) do
    address__details
    |> cast(attrs, [
      :province,
      :accomodation_status,
      :area,
      :house_number,
      :street_name,
      :town,
      :userId,
      :year_at_current_address,
    ])

    # |> validate_required([:accomodation_status, :area, :house_number, :street_name, :town, :userId, :year_at_current_address])
  end
end
