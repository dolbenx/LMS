defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanCustomerDetailsAddCompanyDetails do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_customer_details) do
      add :designation, :string
      add :company_name, :string
      add :company_phone_no, :string
      add :company_email, :string
      add :company_tpin, :string
    end
  end
end
