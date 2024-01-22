defmodule Loanmanagementsystem.Repo.Migrations.AlterAmortizationScheduleAddDate do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_amortization_schedule) do
      add :date, :date

    end
  end
end
