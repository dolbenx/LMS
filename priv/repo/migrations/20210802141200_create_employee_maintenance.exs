defmodule Loanmanagementsystem.Repo.Migrations.CreateTblEmployeeMaintenance do
  use Ecto.Migration

  def change do
    create table(:tbl_employee_maintenance) do
      add :mobile_network_operator, :string
      add :registered_name_mobile_number, :string
      add :userId, :integer
      add :departmentId, :integer
      add :roleTypeId, :integer
      add :nrc_image, :text
      add :employee_number, :string
      add :branchId, :integer
      add :employee_status, :string
      add :job_title, :string

      timestamps()
    end
  end
end
