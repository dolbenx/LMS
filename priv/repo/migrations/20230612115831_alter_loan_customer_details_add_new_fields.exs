defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanCustomerDetailsAddNewFields do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_customer_details) do
      add :sector, :string
      add :geographical_location, :string
      add :type_of_facility, :string
      add :employee_number, :string
    end
  end
end
