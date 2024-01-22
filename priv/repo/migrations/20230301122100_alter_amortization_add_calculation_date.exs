defmodule Loanmanagementsystem.Repo.Migrations.AlterAmortizationAddCalculationDate do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_amortization_schedule) do
      add :calculation_date, :date

    end
  end
end
