defmodule Loanmanagementsystem.Merchants.Merchant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_merchant" do
    field :approval_trail, :string
    field :authLevel, :integer
    field :bankId, :integer
    field :businessName, :string
    field :businessNature, :string
    field :companyAccountNumber, :string
    field :companyName, :string
    field :companyPhone, :string
    field :companyRegistrationDate, :date
    field :contactEmail, :string
    field :createdByUserId, :integer
    field :createdByUserRoleId, :integer
    field :merchantType, :string
    field :registrationNumber, :string
    field :status, :string
    field :taxno, :string

    timestamps()
  end

  @doc false
  def changeset(merchant, attrs) do
    merchant
    |> cast(attrs, [
      :merchantType,
      :bankId,
      :companyName,
      :businessName,
      :businessNature,
      :companyPhone,
      :registrationNumber,
      :taxno,
      :contactEmail,
      :createdByUserId,
      :createdByUserRoleId,
      :status,
      :approval_trail,
      :authLevel,
      :companyRegistrationDate,
      :companyAccountNumber
    ])

    # |> validate_required([:merchantType, :bankId, :companyName, :businessName, :businessNature, :companyPhone, :registrationNumber, :taxno, :contactEmail, :createdByUserId, :createdByUserRoleId, :status, :approval_trail, :authLevel, :companyRegistrationDate, :companyAccountNumber])
  end
end
