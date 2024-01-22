defmodule LoanSavingsSystem.Client.UserBioData do
  @derive {Jason.Encoder, only: [:firstName, :lastName, :userId, :otherName, :dateOfBirth, :meansOfIdentificationType, :meansOfIdentificationNumber, :title, :gender, :mobileNumber, :emailAddress, :clientId]}

  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_user_bio_data" do
    field :clientId, :integer
    field :dateOfBirth, :date
    field :emailAddress, :string
    field :firstName, :string
    field :gender, :string
    field :lastName, :string
    field :meansOfIdentificationNumber, :string
    field :meansOfIdentificationType, :string
    field :mobileNumber, :string
    field :otherName, :string
    field :title, :string
    field :userId, :integer

    timestamps()
  end

  @doc false
  def changeset(user_bio_data, attrs) do
    user_bio_data
    |> cast(attrs, [:firstName, :lastName, :userId, :otherName, :dateOfBirth, :meansOfIdentificationType, :meansOfIdentificationNumber, :title, :gender, :mobileNumber, :emailAddress, :clientId])
   # |> validate_required([:userId, :otherName, :dateOfBirth, :meansOfIdentificationType, :title, :gender, :clientId])
    |> validate_length(:firstName, min: 2, max: 100, message: "should be between 3 to 100 characters")
    |> validate_length(:lastName, min: 2, max: 100, message: "should be between 3 to 100 characters")
    |> validate_length(:emailAddress, min: 10, max: 150, message: "Email Length should be between 10 to 150 characters")
    |> unique_constraint(:emailAddress, name: :unique_emailAddress, message: " Email address already exists")
    |> unique_constraint(:mobileNumber, name: :unique_mobileNumber, message: " Phone number already exists")
    |> unique_constraint(:meansOfIdentificationNumber, name: :unique_meansOfIdentificationNumber, message: " ID number already exists")
  end
end
