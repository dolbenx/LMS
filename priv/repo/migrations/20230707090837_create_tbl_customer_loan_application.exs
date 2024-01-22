defmodule Loanmanagementsystem.Repo.Migrations.CreateTblCustomerLoanApplication do
  use Ecto.Migration

  def change do
    create table(:tbl_customer_loan_application) do
      add :customer_id, :integer
      add :first_name, :string
      add :last_name, :string
      add :phone, :string
      add :email, :string
      add :loan_amount, :float
      add :loan_period, :float
      add :product, :string
      add :product_interet_rate, :float
      add :product_id, :integer
      add :pay_monthly, :float
      add :total_interest, :float
      add :total_pay_back, :float
      add :status, :string

      timestamps()
    end

  end
end
