defmodule Loanmanagementsystem.Employment.Employment_Details do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_employment_details" do
    field :area, :string
    field :date_of_joining, :string
    field :employee_number, :string
    field :employer, :string
    field :employer_industry_type, :string
    field :employer_office_building_name, :string
    field :employer_officer_street_name, :string
    field :employment_type, :string
    field :hr_supervisor_email, :string
    field :hr_supervisor_mobile_number, :string
    field :hr_supervisor_name, :string
    field :job_title, :string
    field :occupation, :string
    field :province, :string
    field :town, :string
    field :userId, :integer
    field :departmentId, :integer
    field :mobile_network_operator, :string
    field :registered_name_mobile_number, :string
    field :contract_start_date, :date
    field :contract_end_date, :date
    field :company_id, :integer
    timestamps()
  end

  @doc false
  def changeset(employment__details, attrs) do
    employment__details
    |> cast(attrs, [
      :employer,
      :departmentId,
      :occupation,
      :date_of_joining,
      :employer_industry_type,
      :employment_type,
      :employee_number,
      :job_title,
      :hr_supervisor_name,
      :hr_supervisor_mobile_number,
      :hr_supervisor_email,
      :employer_office_building_name,
      :employer_officer_street_name,
      :area,
      :town,
      :province,
      :userId,
      :mobile_network_operator,
      :registered_name_mobile_number,
      :contract_start_date,
      :contract_end_date,
      :company_id
    ])

    # |> validate_required([
    #   :employer,
    #   :departmentId,
    #   :occupation,
    #   :date_of_joining,
    #   :employer_industry_type,
    #   :employment_type,
    #   :employee_number,
    #   :job_title,
    #   :hr_supervisor_name,
    #   :hr_supervisor_mobile_number,
    #   :hr_supervisor_email,
    #   :employer_office_building_name,
    #   :employer_officer_street_name,
    #   :area,
    #   :town,
    #   :province,
    #   :userId
    # ])
  end
end
