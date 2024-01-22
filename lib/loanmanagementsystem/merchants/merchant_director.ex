defmodule Loanmanagementsystem.Merchants.Merchant_director do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
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
      :merchantId
    ])

    # |> validate_required([:firstName, :lastName, :otherName, :directorIdentificationnNumber, :directorIdType, :mobileNumber, :emailAddress, :status, :merchantType, :merchantId])
  end
end
