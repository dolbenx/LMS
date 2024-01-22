defmodule Loanmanagementsystem.Repo.Migrations.CreateEmploymentType do
  use Ecto.Migration

  def change do
    create table(:tbl_employment_details) do
      add :employer, :string
      add :occupation, :string
      add :date_of_joining, :string
      add :employer_industry_type, :string
      add :employment_type, :string
      add :employee_number, :string
      add :job_title, :string
      add :hr_supervisor_name, :string
      add :hr_supervisor_mobile_number, :string
      add :hr_supervisor_email, :string
      add :employer_office_building_name, :string
      add :employer_officer_street_name, :string
      add :area, :string
      add :town, :string
      add :province, :string
      add :userId, :integer
      add :departmentId, :string
      add :mobile_network_operator, :string
      add :registered_name_mobile_number, :string
      add :contract_start_date, :date
      add :contract_end_date, :date
      add :company_id, :integer

      timestamps()
    end

    create unique_index(:tbl_employment_details, [:employee_number], name: :unique_employee_number)
    create unique_index(:tbl_employment_details, [:userId], name: :unique_userId)

  end
end
