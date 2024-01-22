defmodule LoanSavingsSystem.Client.NextOfKin do
  @derive {Jason.Encoder, only: [:firstName, :lastName, :otherName, :addressLine1, :addressLine2, :city, :districtId, :districtName, :provinceId, :provinceName, :accountId, :userId, :clientId]}
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_next_of_kin" do
    field :accountId, :integer
    field :addressLine1, :string
    field :addressLine2, :string
    field :city, :string
    field :clientId, :integer
    field :districtId, :integer
    field :districtName, :string
    field :firstName, :string
    field :lastName, :string
    field :otherName, :string
    field :provinceId, :integer
    field :provinceName, :string
    field :userId, :integer
    field :otp, :string
    field :email, :string
    field :phoneNumber, :string
    field :telephonenumber, :string
    field :occupation, :string
    field :placeofwork, :string
    field :relationship_id, :integer
    field :gender_id, :integer
    field :marital_status_id, :integer
    field :title_id, :integer
    field :dob, :date

    timestamps()
  end

  @doc false
  def changeset(next_of_kin, attrs) do
    next_of_kin
    |> cast(attrs, [:phoneNumber,
        :email, :otp, :firstName, :lastName, :otherName,
        :addressLine1, :addressLine2, :city, :districtId,
        :districtName, :provinceId, :provinceName, :accountId,
        :userId, :clientId, :telephonenumber, :occupation, :placeofwork,
        :relationship_id, :gender_id, :marital_status_id, :title_id, :dob
    ])
    # |> validate_required([:firstName, :phoneNumber, :email, :lastName, :userId]) #:otherName, :addressLine1, :addressLine2, :city, :districtId, :districtName, :provinceId, :provinceName,
  end
end
