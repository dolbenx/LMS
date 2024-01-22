defmodule Loanmanagementsystem.Merchants.Merchant do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

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
    field :qr_code_name, :string
    field :merchant_number, :string
    field :qr_code_path, :string
    field :user_id, :integer

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
      :companyAccountNumber,
      :qr_code_name,
      :merchant_number,
      :qr_code_path,
      :user_id
    ])

    # |> validate_required([:merchantType, :bankId, :companyName, :businessName, :businessNature, :companyPhone, :registrationNumber, :taxno, :contactEmail, :createdByUserId, :createdByUserRoleId, :status, :approval_trail, :authLevel, :companyRegistrationDate, :companyAccountNumber])
  end
end
