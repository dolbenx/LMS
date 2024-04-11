defmodule Loanmanagementsystem.Accounts.AddressDetails do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_address_details" do
    field :accomodation_status, :string
    field :area, :string
    field :country, :integer
    field :house_number, :string
    field :province, :integer
    field :street_name, :string
    field :town, :integer
    field :user_id, :integer
    field :years_at_current_address, :integer

    timestamps()
  end

  @doc false
  def changeset(address_details, attrs) do
    address_details
    |> cast(attrs, [:accomodation_status, :area, :house_number, :street_name, :user_id, :years_at_current_address, :country, :province, :town])
    |> validate_required([:accomodation_status, :area, :house_number, :street_name, :user_id, :years_at_current_address, :country, :province, :town])
  end
end
