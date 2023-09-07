defmodule Loanmanagementsystem.Repo.Migrations.AlteredTblLoanFieldArrangementFeeAndFinanceFee do
  use Ecto.Migration

  def change do
    alter table(:tbl_loans) do
      add :arrangement_fee, :float
      add :finance_cost, :float

    end
  end
end
