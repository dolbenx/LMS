defmodule Loanmanagementsystem.Merchants.Merchant_director do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_merchant_dir" do
    field :directorIdType, :string
    field :directorIdentificationnNumber, :string
    field :emailAddress, :string
    field :firstName, :string
    field :lastName, :string
    field :merchantId, :integer
    field :merchantType, :string
    field :mobileNumber, :string
    field :otherName, :string
    field :status, :string
    field :title, :string
    field :house_number, :string
    field :street_name, :string
    field :area, :string
    field :town, :string
    field :province, :string
    field :accomodation_status, :string
    field :years_at_current_address, :integer
    field :date_of_birth, :date
    field :gender, :string

    timestamps()
  end

  @doc false
  def changeset(merchant_director, attrs) do
    merchant_director
    |> cast(attrs, [
      :firstName,
      :lastName,
      :otherName,
      :directorIdentificationnNumber,
      :directorIdType,
      :mobileNumber,
      :emailAddress,
      :status,
      :merchantType,
      :merchantId,
      :title,
      :house_number,
      :street_name,
      :area,
      :town,
      :province,
      :accomodation_status,
      :years_at_current_address,
      :date_of_birth,
      :gender,

    ])

    # |> validate_required([:firstName, :lastName, :otherName, :directorIdentificationnNumber, :directorIdType, :mobileNumber, :emailAddress, :status, :merchantType, :merchantId])
  end
end
