defmodule Loanmanagementsystem.Companies.Client_company_details do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_client_company_details" do
    field :approval_trail, :string
    field :auth_level, :integer
    field :bank_id, :integer
    field :company_account_number, :string
    field :company_name, :string
    field :company_phone, :string
    field :company_registration_date, :date
    field :contact_email, :string
    field :createdByUserId, :integer
    field :createdByUserRoleId, :integer
    field :registration_number, :string
    field :status, :string
    field :taxno, :string
    field :company_department, :string
    field :company_bank_name, :string
    field :company_account_name, :string
    field :userId, :integer




    timestamps()
  end

  @doc false
  def changeset(client_company_details, attrs) do
    client_company_details
    |> cast(attrs, [
      :approval_trail,
      :auth_level,
      :userId,
      :company_name,
      :company_phone,
      :contact_email,
      :createdByUserId,
      :createdByUserRoleId,
      :registration_number,
      :status,
      :taxno,
      :company_registration_date,
      :company_account_number,
      :bank_id,
      :company_department,
      :company_bank_name,
      :company_account_name
    ])

    # |> validate_required([:company_name, :company_phone, :contact_email, :createdByUserId, :createdByUserRoleId, :registration_number, :status, :taxno, :company_registration_date, :company_account_number, :bank_id])
  end
end
