defmodule Loanmanagementsystem.Repo.Migrations.AlterLoanCustomerDetailsAddCrb do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_customer_details) do
      add :crb_consent, :string
    end
  end
end
