defmodule Loanmanagementsystem.Repo.Migrations.CreateTblIncomeDetails do
  use Ecto.Migration

  def change do
    create table(:tbl_income_details) do
      add :pay_day, :date
      add :gross_pay, :float
      add :total_deductions, :float
      add :net_pay, :float
      add :total_expenses, :float
      add :upload_payslip, :string
      add :userId, :integer

      timestamps()
    end
  end
end
