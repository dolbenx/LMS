defmodule LoanSystem.Repo.Migrations.CreateTblLoanCollateral do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_collateral) do
      add :loan_id, :integer
      add :collateral_type, :string
      add :valuation, :float
      add :description, :string

      timestamps()
    end

  end
end
