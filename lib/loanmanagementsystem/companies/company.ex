defmodule Loanmanagementsystem.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

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

    field :area, :string
    field :twon, :string
    field :province, :string
    field :employer_industry_type, :string
    field :employer_office_building_name, :string
    field :employer_officer_street_name, :string
    field :business_sector, :string

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [
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
      :approval_trail,
      :auth_level,
      :companyRegistrationDate,
      :companyAccountNumber,
      :area,
      :twon,
      :province,
      :employer_industry_type,
      :employer_office_building_name,
      :employer_officer_street_name,
      :business_sector
    ])
    |> validate_required([
      :companyName,
      # :companyPhone,
    ])

    # |> validate_required([:companyName, :companyPhone, :registrationNumber, :taxno, :contactEmail, :isEmployer, :isSme, :isOfftaker, :createdByUserId, :createdByUserRoleId, :status, :approval_trail, :auth_level])
  end
end
