defmodule Loanmanagementsystem.Repo.Migrations.AlterGaurantorAddIncomeStatement do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_guarantor) do
      add :salary, :float
      add :other_income, :float
      add :business_sales, :float
      add :total_income, :float

    end
  end
end
