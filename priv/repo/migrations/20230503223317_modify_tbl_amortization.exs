defmodule Loanmanagementsystem.Repo.Migrations.ModifyTblAmortization do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_amortization_schedule) do
      add :date, :date
      add :calculation_date, :date

    end
  end
end
