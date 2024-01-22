defmodule Loanmanagementsystem.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  #

  schema "tbl_company" do
    field :approval_trail, :string
    field :auth_level, :integer
    field :companyName, :string
    field :companyPhone, :string
    field :contactEmail, :string
    field :createdByUserId, :integer
    field :createdByUserRoleId, :integer
    field :isEmployer, :boolean, default: false
    field :isOfftaker, :boolean, default: false
    field :isSme, :boolean, default: false
    field :registrationNumber, :string
    field :status, :string
    field :taxno, :string
    field :companyRegistrationDate, :date
    field :companyAccountNumber, :string
    field :bank_id, :integer
    field :user_bio_id, :integer

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [
      :bank_id,
      :user_bio_id,
      :companyName,
      :companyPhone,
      :registrationNumber,
      :taxno,
      :contactEmail,
      :isEmployer,
      :isSme,
      :isOfftaker,
      :createdByUserId,
      :createdByUserRoleId,
      :status,
      :approval_trail,
      :auth_level,
      :companyRegistrationDate,
      :companyAccountNumber
    ])
    |> validate_required([
      :bank_id,
      :companyName,
      :companyPhone,
      :registrationNumber,
      :taxno,
      :contactEmail,
      :isEmployer,
      :isSme,
      :isOfftaker,
      :createdByUserId,
      :createdByUserRoleId,
      :status,
      :companyRegistrationDate,
      :companyAccountNumber
    ])

    # |> validate_required([:companyName, :companyPhone, :registrationNumber, :taxno, :contactEmail, :isEmployer, :isSme, :isOfftaker, :createdByUserId, :createdByUserRoleId, :status, :approval_trail, :auth_level])
  end
end
