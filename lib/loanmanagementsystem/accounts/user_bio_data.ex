defmodule Loanmanagementsystem.Accounts.UserBioData do
  @derive {Jason.Encoder,
           only: [
             :firstName,
             :lastName,
             :userId,
             :otherName,
             :dateOfBirth,
             :meansOfIdentificationType,
             :meansOfIdentificationNumber,
             :title,
             :gender,
             :mobileNumber,
             :emailAddress
           ]}

  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tbl_user_bio_data" do
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
    field :idNo, :string
    field :bank_id, :integer
    field :bank_account_number, :string
    field :marital_status, :string
    field :nationality, :string
    field :number_of_dependants, :integer
    field :age, :integer
    field :disability_detail, :string
    field :disability_status, :string
    field :employee_confirmation, :boolean
    field :applicant_declaration, :boolean
    field :accept_conditions, :boolean

    timestamps()
  end

  @doc false
  def changeset(user_bio_data, attrs) do
    user_bio_data
    |> cast(attrs, [
      :nationality,
      :number_of_dependants,
      :marital_status,
      :bank_id,
      :bank_account_number,
      :firstName,
      :lastName,
      :idNo,
      :userId,
      :otherName,
      :dateOfBirth,
      :meansOfIdentificationType,
      :meansOfIdentificationNumber,
      :title,
      :gender,
      :mobileNumber,
      :emailAddress,
      :age,
      :disability_detail,
      :disability_status,
      :employee_confirmation,
      :applicant_declaration,
      :accept_conditions
    ])
    # |> validate_required([:userId, :otherName, :dateOfBirth, :meansOfIdentificationType, :title, :gender])
    # |> validate_length(:firstName, min: 2, max: 100, message: "should be between 3 to 100 characters")
    # |> validate_length(:lastName, min: 2, max: 100, message: "should be between 3 to 100 characters")
    |> validate_length(:emailAddress,
      min: 10,
      max: 150,
      message: "Email Length should be between 10 to 150 characters"
    )
    |> unique_constraint(:emailAddress,
      name: :unique_emailAddress,
      message: " Email address already exists"
    )

    # |> unique_constraint(:mobileNumber, name: :unique_mobileNumber, message: " Phone number already exists")
    # |> unique_constraint(:meansOfIdentificationNumber, name: :unique_meansOfIdentificationNumber, message: " ID number already exists")
  end

  def userbio_changeset(user_bio_data, attrs) do
    user_bio_data
    |> cast(attrs, [
      :firstName,
      :lastName,
      :userId,
      :otherName,
      :dateOfBirth,
      :meansOfIdentificationType,
      :meansOfIdentificationNumber,
      :title,
      :gender,
      :mobileNumber,
      :emailAddress,
      :age,
      :bank_id,
      :disability_detail,
      :disability_status
    ])

    # |> validate_required([:userId, :otherName, :dateOfBirth, :meansOfIdentificationType, :title, :gender])
    # |> validate_length(:firstName, min: 2, max: 100, message: "should be between 3 to 100 characters")
    # |> validate_length(:lastName, min: 2, max: 100, message: "should be between 3 to 100 characters")
    # |> validate_length(:emailAddress, min: 10, max: 150, message: "Email Length should be between 10 to 150 characters")
    # |> unique_constraint(:emailAddress, name: :unique_emailAddress, message: " Email address already exists")
    # |> unique_constraint(:mobileNumber, name: :unique_mobileNumber, message: " Phone number already exists")
    # |> unique_constraint(:meansOfIdentificationNumber, name: :unique_meansOfIdentificationNumber, message: " ID number already exists")
  end
end
